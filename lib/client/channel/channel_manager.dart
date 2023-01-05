import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/client/channel/origin_version_length_field_decoder.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';
import 'package:ash_go/common/util/serializer_util.dart';

typedef Connected = void Function(ChannelManager channelManager);

class ChannelManager {
  Socket? _channel;
  String host = "192.168.1.104";
  final _serializerUtil = const JsonSerializerUtil();
  final _seriesIds = SeriesIdInteger(0);
  final OriginVersionLengthFieldDecoder _lengthFieldDecoder =
      OriginVersionLengthFieldDecoder(
          OriginVersionPacket.PACKET_MAX_LENGTH,
          Packet.MAGIC_NUMBER_FIELD_LENGTH +
              Packet.VERSION_FIELD_LENGTH +
              OriginVersionPacket.TYPE_FIELD_LENGTH,
          lengthField: OriginVersionPacket.LENGTH_FIELD_LENGTH,
          postLengthField: OriginVersionPacket.SERIES_ID_FIELD_LENGTH +
              OriginVersionPacket.SERIALIZE_TYPE_FIELD_LENGTH);
  int port = 8896;

  ChannelManager([Connected? connected]) {
    Socket.connect(host, port).then((value) {
      _channel = value;
      connected?.call(this);

      return value;
    }).then((value) {
      value.listen((event) {
        _lengthFieldDecoder.collecting(event);
      });
    });
  }
  String getReceive() {
    return utf8.decode(_lengthFieldDecoder
        .resultPackets[_lengthFieldDecoder.resultPackets.length - 1]
        .takeBytes());
  }

//TODO 应当把Packet封装加上，此处作为简化直接从frame写入byte数组
  void send(ClientFrame frame, int seriesId, SerializeType serializeType) {
    var contentData = _serializerUtil.serializer(frame);
    ByteBuf sendData = ByteBuf();
    sendData.writeInt(Packet.MAGIC_NUMBER);
    sendData.writeByte(OriginVersionPacket.VERSION.index);
    sendData.writeShort(frame.getPacketType().index);
    sendData.writeInt(contentData.length);
    sendData.writeByte(serializeType.index);
    sendData.writeInt(seriesId);

    sendData.writeBytes(contentData);
    _channel!.add(sendData.takeBytes());
  }

  get isConnected {
    return _channel != null;
  }
}

class SeriesIdInteger {
  int _value;
  static const ALONE_PACKET_SERIES_ID = 0x7fffffff;
  SeriesIdInteger(this._value);

  int getAndIncrement() {
    var temp = _value;
    _value = (++_value) % ALONE_PACKET_SERIES_ID;
    return temp;
  }
}
