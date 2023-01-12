import 'dart:async';

import 'dart:io';

import 'dart:typed_data';

import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/protocol_version.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/client/channel/origin_version_length_field_decoder.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';
import 'package:async/async.dart';

typedef Connected = void Function(ChannelManager channelManager);

class ChannelManager {
  Socket? _channel;

  String host = "192.168.1.104";
  int port = 8896;

  final _serializerUtil = const JsonSerializerUtil();

  final OriginVersionLengthFieldDecoder _lengthFieldDecoder =
      OriginVersionLengthFieldDecoder(
          OriginVersionPacket.PACKET_MAX_LENGTH,
          Packet.MAGIC_NUMBER_FIELD_LENGTH +
              Packet.VERSION_FIELD_LENGTH +
              OriginVersionPacket.TYPE_FIELD_LENGTH,
          lengthField: OriginVersionPacket.LENGTH_FIELD_LENGTH,
          postLengthField: OriginVersionPacket.SERIES_ID_FIELD_LENGTH +
              OriginVersionPacket.SERIALIZE_TYPE_FIELD_LENGTH);
  final Completer _connectState = Completer();

  final serverFrameController = StreamController<ServerFrame>();

  late final serverFrameQueue;
  ServerFrame buildServerFrame(ByteBuf buf) {
    var magicNumber = buf.readInt();
    var version = ProtocolVersion.values[buf.readBtye()];

    var type = PacketType.values[buf.readShort()];
    var length = buf.readInt();
    var serializeType = SerializeType.values[buf.readBtye()];
    var seriesId = buf.readInt();

    var jsonBytes = Uint8List.sublistView(
        buf.getContent(), _lengthFieldDecoder.headerLength, buf.writerIndex);

    var serverFrame = _serializerUtil.deserializer(jsonBytes, type);

    serverFrame.seriesId = seriesId;

    return serverFrame;
  }

  ChannelManager([Connected? connected]) {
    serverFrameQueue = StreamQueue<ServerFrame>(serverFrameController.stream);

    _lengthFieldDecoder.packetProcess = (ByteBuf buf) {
      var serverFrame = buildServerFrame(buf);
      serverFrameController.add(serverFrame);
    };

    Socket.connect(host, port).then((value) {
      _channel = value;
      _connectState.complete();
      connected?.call(this);

      return value;
    }).then((value) {
      value.listen((event) {
        _lengthFieldDecoder.collecting(event);
      });
    }).onError((error, stackTrace) {
      _connectState.completeError(error!);
    });
  }

  // void sendSingleSide(ClientFrame frame) async {
  //   await _connectState.future;

  //   print('client push...');
  //   _send(frame);
  // }
//TODO 应当把Packet封装加上，此处作为简化直接从frame写入byte数组

  void _send(ClientFrame frame) {
    _vaildConnected();

    var contentData = _serializerUtil.serializer(frame);

    var sendData = buildPakcet(contentData, frame.getPacketType(),
        frame.seriesId, _serializerUtil.getSerializeType());

    _channel!.add(sendData.takeBytes());
  }

  void send(ClientFrame frame) async {
    await _connectState.future;

    _send(frame);
  }

  ByteBuf buildPakcet(Uint8List contentData, PacketType packetType,
      int seriesId, SerializeType serializeType) {
    ByteBuf sendData = ByteBuf();
    sendData.writeInt(Packet.MAGIC_NUMBER);
    sendData.writeByte(OriginVersionPacket.VERSION.index);
    sendData.writeShort(packetType.index);
    sendData.writeInt(contentData.length);
    sendData.writeByte(_serializerUtil.getSerializeType().index);
    sendData.writeInt(seriesId);

    sendData.writeBytes(contentData);
    return sendData;
  }

//TODO socket对象连接情况也要检查
  get isConnected {
    return _channel != null;
  }

  void _vaildConnected() {
    if (!isConnected) {
      throw const SocketException('连接未打开');
    }
  }

  Future<dynamic> shutdown() async {
    _vaildConnected();

    return _channel?.close();
  }
}
