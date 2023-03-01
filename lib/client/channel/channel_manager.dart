import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';


import 'package:ash_go/client/channel/origin_version_length_field_decoder.dart';
import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/protocol_version.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';
import 'package:async/async.dart';

typedef Connected = void Function(ChannelManager channelManager);
//内部用途，外部不应使用
class ReconnectedServerFrame extends ServerFrame{
  @override
  PacketType getPacketType() {
    // TODO: implement getPacketType
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}
class DisconnectServerFrame extends ServerFrame{
  @override
  PacketType getPacketType() {
    // TODO: implement getPacketType
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

}

class ChannelManager {
  Socket? _channel;

  late String host;
bool isClose=false;
bool _needReconnect=false;
  late int port;

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
   Completer<bool> _connectState = Completer();

  final serverFrameController = StreamController<ServerFrame>();

  // late final StreamQueue<ServerFrame> serverFrameQueue;

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

  ChannelManager(this.host, this.port, [Connected? connected]) {
    // serverFrameQueue = StreamQueue<ServerFrame>(serverFrameController.stream);

    _lengthFieldDecoder.packetProcess = (ByteBuf buf) {
      var serverFrame = buildServerFrame(buf);
      serverFrameController.add(serverFrame);
    };
_connect(connected);

  }
void _reconnect(){

if(_channel!=null||_connectState.isCompleted&&_channel==null){
  serverFrameController.add(DisconnectServerFrame());
}
    _channel=null;
if(isClose){
  return;
}


Timer(Duration(seconds: 12), () {

  _connect(null);
});




}


  void _connect(Connected? connected){


    Socket.connect(host, port,timeout: Duration(seconds: 25)).then((value) {
      _needReconnect=false;
      _channel = value;

if(!_connectState.isCompleted){
  _connectState.complete(true);

}else{

  serverFrameController.add(ReconnectedServerFrame());



}
      connected?.call(this);

      return value;
    }).then((sc) {

sc.listen((event) {
        _lengthFieldDecoder.collecting(event);
      },

          onDone: (){
            _needReconnect=true;

_reconnect();

        print('socket down');

          },
      );
    }
    ).onError((error, stackTrace) {
      _needReconnect=true;

      _reconnect();
      print(stackTrace);
      print('socket connect error');




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
    _channel!.flush();
  }

  Future<void> send(ClientFrame frame) async {
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
    return _channel != null||!_needReconnect;
  }

  void _vaildConnected() {
    if (!isConnected) {
      throw const SocketException('连接未打开');
    }
  }

  Future<dynamic> shutdown() async {
    isClose=true;
    _vaildConnected();

    return _channel?.close();
  }
}
