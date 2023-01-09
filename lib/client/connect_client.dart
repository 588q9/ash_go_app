import 'dart:async';
import 'dart:isolate';

import 'package:ash_go/client/channel/channel_manager.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:async/async.dart';

//TODO 对服务端主动推送的frame处理
//TODO 考虑将_run方法做成reactor模型，轮流对channelmanager进行发送
class ConnectClient {
  late Isolate _running;
  final _receiveMain = ReceivePort();
  late SendPort _sendMain;
  final _serverFrameMap = <int, Completer<dynamic>>{};
  final Completer<SendPort> _sendRunningFuture = Completer();
  late StreamQueue<dynamic> _events;
  ConnectClient() {
    _sendMain = _receiveMain.sendPort;
    _events = StreamQueue(_receiveMain);

    _init();
  }

  void _init() async {
    _running = await Isolate.spawn(_run, _sendMain);

    var sendRunning = await _events.next;

    _sendRunningFuture.complete(sendRunning);
  }

  Future<dynamic> send(ClientFrame clientFrame) async {
    var sendRunning = await _sendRunningFuture.future;

    sendRunning.send(clientFrame);
    var completer = Completer();


    _serverFrameMap[clientFrame.seriesId] = completer;
    var resFuture = _events.next;
    resFuture.then((value) {

      print(value.seriesId);
      print(clientFrame.seriesId);

      _serverFrameMap[value.seriesId]!.complete(value);
      _serverFrameMap.remove(value.seriesId);
    });

    return completer.future;
  }
}

void _run(SendPort sendMain) async {
  ChannelManager manager = ChannelManager();
  ReceivePort receiveRunning = ReceivePort();
  sendMain.send(receiveRunning.sendPort);
  var runningEvents = StreamQueue(receiveRunning);

  while (true) {
    var clientFrame = await runningEvents.next;

    var serverFrameFuture = manager.send(clientFrame);

    serverFrameFuture.then((value) {
      sendMain.send(value);
    });
  }
}
