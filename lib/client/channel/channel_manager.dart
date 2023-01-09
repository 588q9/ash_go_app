import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'dart:typed_data';

import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/protocol_version.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/client/channel/origin_version_length_field_decoder.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';

typedef Connected = void Function(ChannelManager channelManager);

class ChannelManager {
  Socket? _channel;
  Timer? _sendPingtimer;
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
  final Completer _connectState = Completer();
  //TODO 超时丢弃，并且报超时错误给future
  final serverMap = <int, Completer<ServerFrame>>{};
  //TODO 需要寻找正确的服务端推送消息处理器
  final serverPush = <ServerFrame>[];

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
    _lengthFieldDecoder.packetProcess = (ByteBuf buf) {
      var serverFrame = buildServerFrame(buf);
      if (serverFrame.seriesId == SeriesIdInteger.ALONE_PACKET_SERIES_ID) {
        //TODO 需要寻找正确的服务端推送消息处理器考虑使用StreamTransformer或StreamController
        print('server push,store to list');

        serverPush.add(serverFrame);
        print(serverPush);
        return;
      }

      serverMap[serverFrame.seriesId]!.complete(serverFrame);
      serverMap.remove(serverFrame.seriesId);
    };

    Socket.connect(host, port).then((value) {
      _channel = value;
      _connectState.complete();
      connected?.call(this);
      _sendPingtimer = Timer.periodic(const Duration(seconds: 60), (timer) {
        send(PingClientFrame()).then((value) {
          //TODO PongServerFrame处理
          print(value);
        });
      });
      return value;
    }).then((value) {
      value.listen((event) {

        _lengthFieldDecoder.collecting(event);
      });
    }).onError((error, stackTrace) {
      _connectState.completeError(error!);
    });
  }

  void sendSingleSide(ClientFrame frame) async {
    await _connectState.future;

    print('client push...');
    _send(frame);
  }
//TODO 应当把Packet封装加上，此处作为简化直接从frame写入byte数组

  int _send(ClientFrame frame,
      [int seriesId = SeriesIdInteger.ALONE_PACKET_SERIES_ID]) {
    _vaildConnected();

    var contentData = _serializerUtil.serializer(frame);

    var sendData = buildPakcet(contentData, frame.getPacketType(), seriesId,
        _serializerUtil.getSerializeType());

    _channel!.add(sendData.takeBytes());
    return seriesId;
  }

  Future<ServerFrame> send(ClientFrame frame) async {
    await _connectState.future;

    var seriesId = _send(frame, seriesIds.getAndIncrement());
frame.seriesId=seriesId;
    var serverFrameCompleter = Completer<ServerFrame>();
    serverMap[seriesId] = serverFrameCompleter;

    return serverFrameCompleter.future;
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

  void _vaildConnected() {
    if (!isConnected) {
      throw const SocketException('连接未打开');
    }
  }

  Future<dynamic> shutdown() async {
    _vaildConnected();
    _sendPingtimer?.cancel();

    return _channel?.close();
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
