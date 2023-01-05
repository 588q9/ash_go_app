import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/protocol_version.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/pong_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/client/channel/origin_version_length_field_decoder.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';

typedef Connected = void Function(ChannelManager channelManager);

class ChannelManager {
  Socket? _channel;
  String host = "192.168.1.104";
  final _serializerUtil = const JsonSerializerUtil();
  final seriesIds = SeriesIdInteger(0);
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

  final responseMap = <int, Future<ServerFrame>>{};
final serverPushMap=<ServerFrame>[];

ServerFrame buildServerFrame(ByteBuf buf){
var magicNumber=buf.readInt();
var version=ProtocolVersion.values[buf.readBtye()];

var type=PacketType.values[buf.readShort()];
var length=buf.readInt();
var serializeType=SerializeType.values[buf.readBtye()];
var seriesId=buf.readInt();

var jsonBytes=Uint8List.sublistView(buf.getContent(),_lengthFieldDecoder.headerLength);
var serverFrame =_serializerUtil.deserializer(jsonBytes, type);

serverFrame.seriesId=seriesId;
return serverFrame;
}

  ChannelManager([Connected? connected]) {
_lengthFieldDecoder.packetProcess=(ByteBuf buf){
var serverFrame=buildServerFrame(buf);

};

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
  

//TODO 应当把Packet封装加上，此处作为简化直接从frame写入byte数组
  Future<ServerFrame>  send  (ClientFrame frame,
      [int seriesId = SeriesIdInteger.ALONE_PACKET_SERIES_ID]) async{
    var contentData = _serializerUtil.serializer(frame);

    var sendData = buildPakcet(contentData, frame.getPacketType(), seriesId,
        _serializerUtil.getSerializeType());


  
    _channel!.add(sendData.takeBytes());
if(seriesId==SeriesIdInteger.ALONE_PACKET_SERIES_ID){
  //TODO 寻找正确的处理器
return Future<ServerFrame>((){return PongServerFrame(); });
}


responseMap[seriesId]=Future.value();
return responseMap[seriesId];

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

  get isConnected {
    return _channel != null;
  }
}
//每个channelManager对象应当只有一个seriesid生成器
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
