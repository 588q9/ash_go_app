import 'dart:async';
import 'dart:isolate';

import 'package:ash_go/client/channel/channel_manager.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:async/async.dart';

//TODO 对服务端主动推送的frame处理
class IsolateClient {
  late Isolate _running;
  final _receiveMain = ReceivePort();
  late SendPort _sendMain;

  final Completer<SendPort> _sendRunningFuture = Completer();
  // late StreamQueue<dynamic> _events;
  final seriesIds = SeriesIdInteger(0);

  //TODO 超时丢弃，并且报超时错误给future
  final _serverFrameMap = <int, Completer<dynamic>>{};
  //TODO 需要寻找正确的服务端推送消息处理器
  final serverPush = <ServerFrame>[];
  late Timer _sendPingtimer;
  IsolateClient() {
    _sendMain = _receiveMain.sendPort;
    // _events = StreamQueue(_receiveMain);

    _init();
    _sendPingtimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      var pingClientFrame = PingClientFrame();

      send(pingClientFrame).then((value) {
        //TODO Pong处理
        // print(value);
      });
    });
  }

  void _init() async {
    ReceivePort receivePort = ReceivePort();
    _running = await Isolate.spawn(_run, [receivePort.sendPort, _sendMain]);

    // var sendRunning = await _events.next;
    SendPort sendRunning = await receivePort.first;
    receivePort.close();
    _sendRunningFuture.complete(sendRunning);

    _receiveMain.listen((serverFrame) {
      if (serverFrame.seriesId == SeriesIdInteger.ALONE_PACKET_SERIES_ID) {
        //TODO 需要寻找正确的服务端推送消息处理器,考虑使用StreamTransformer或StreamController
        print('server push,store to list');

        serverPush.add(serverFrame);
        print(serverPush);
        return;
      }

      _serverFrameMap[serverFrame.seriesId]!.complete(serverFrame);
      _serverFrameMap.remove(serverFrame.seriesId);
    });
  }

  void sendSingleSide(ClientFrame frame) async {
    var sendRunning = await _sendRunningFuture.future;

    sendRunning.send(frame);
  }

  Future<dynamic> send(ClientFrame clientFrame) async {
    clientFrame.seriesId = seriesIds.getAndIncrement();
    var sendRunning = await _sendRunningFuture.future;

    sendRunning.send(clientFrame);
    var completer = Completer();

    _serverFrameMap[clientFrame.seriesId] = completer;

    return completer.future;
  }
}
//TODO 考虑将_run方法做成reactor模型，轮流对channelmanager进行发送

void _run(List<SendPort> sendMain) async {
  ChannelManager manager = ChannelManager();
  ReceivePort receiveRunning = ReceivePort();
  sendMain[0].send(receiveRunning.sendPort);
  var runningEvents = StreamQueue(receiveRunning);

  while (true) {
    var clientFrame = await runningEvents.next;

    manager.send(clientFrame);
    var serverFrameFuture = manager.serverFrameQueue.next;

    serverFrameFuture.then((value) {
      sendMain[1].send(value);
    });
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
