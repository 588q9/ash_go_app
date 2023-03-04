import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:ash_go/client/channel/channel_manager.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/exception_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/push/push_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:async/async.dart';
typedef VoidCallback = void Function();

//TODO 对服务端主动推送的frame处理
class IsolateClient {
    late String host;
late int port;
  late Isolate _running;
  final _receiveMain = ReceivePort();
  late SendPort _sendMain;

  final Completer<SendPort> _sendRunningFuture = Completer();

  final seriesIds = SeriesIdInteger(0);
VoidCallback? reconnected;

  //TODO 超时丢弃，并且报超时错误给future,或者进行重传，多次失败后报错
  final _serverFrameMap = <int, Completer<ServerFrame>>{};
  //TODO 需要寻找正确的服务端推送消息处理器，并且要发送确认frame
  final serverPush = <ServerFrame>[];
final StreamController<PushServerFrame> serverPushContainer=StreamController();
     Timer? _sendPingtimer;

  IsolateClient(this.host,this.port,{this.reconnected}) {
    _sendMain = _receiveMain.sendPort;
    // _events = StreamQueue(_receiveMain);

    _init();
    _keepAlive();
  }
void _stopKeepAlive(){


    _sendPingtimer?.cancel();

}
  void _keepAlive(){

_sendPingtimer?.cancel();
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
    //TODO "Software caused connection abort: socket write error"问题，目前只能重启整个isolate解决
//     var errorPort=ReceivePort();
//     errorPort.listen((message) {
//      print((message[0] as SocketException));
//     });
// _running.addErrorListener(errorPort.sendPort);
    SendPort sendRunning = await receivePort.first;
    receivePort.close();
    sendRunning.send([host,port]);
    _sendRunningFuture.complete(sendRunning);

    _receiveMain.listen((serverFrame) {

       if(serverFrame is ReconnectedServerFrame){
      reconnected?.call();
      _keepAlive();
      return;
      }else if(serverFrame is DisconnectServerFrame){
         _stopKeepAlive();
         return;
       }


      if (serverFrame.seriesId == SeriesIdInteger.ALONE_PACKET_SERIES_ID) {


        print('server push,store to list');
        //TODO 需要寻找正确的服务端推送消息处理器,考虑使用StreamTransformer或StreamController

        serverPush.add(serverFrame);
serverPushContainer.add(serverFrame);
        print(serverPush);
        return;
      }
if(serverFrame is ExceptionServerFrame){
  _serverFrameMap[serverFrame.seriesId]?.completeError(Exception(serverFrame.errorMessage));


}
else{
  _serverFrameMap[serverFrame.seriesId]?.complete(serverFrame);

}


      _serverFrameMap.remove(serverFrame.seriesId);
    });
  }
@Deprecated("客户端推送的消息也应该有确认响应")
  void sendSingleSide(ClientFrame frame) async {
    var sendRunning = await _sendRunningFuture.future;

    sendRunning.send(frame);
  }

  Future<ServerFrame> send(ClientFrame clientFrame) async {
    clientFrame.seriesId = seriesIds.getAndIncrement();
    var sendRunning = await _sendRunningFuture.future;

    sendRunning.send(clientFrame);
    var completer = Completer<ServerFrame>();

    _serverFrameMap[clientFrame.seriesId] = completer;

    return completer.future;
  }
static String CLOSE='close';

void close()async{
  
    var sendRunning = await _sendRunningFuture.future;
sendRunning.send(CLOSE);


}


}
//TODO 考虑将_run方法做成多isolate多channelmanager轮流使用或者的模型，切换isolate轮流对channelmanager进行发送

void _run(List<SendPort> sendMain) async {


  ReceivePort receiveRunning = ReceivePort();
  sendMain[0].send(receiveRunning.sendPort);

  var runningEvents = StreamQueue(receiveRunning);
  List socketInfo =await runningEvents.next;

  ChannelManager manager = ChannelManager(socketInfo[0],socketInfo[1]);

  sendMain.removeAt(0);
  manager.serverFrameController.stream.listen((event) {

    Timer(Duration(microseconds: 200),(){
      sendMain[0].send(event);

    });
  });
  while (true) {

    //TODO 处理异常情况
    //TODO 断线了应该暂停放入队列
    var clientFrame = await runningEvents.next;

if(clientFrame==IsolateClient.CLOSE){
  manager.shutdown();
break;
}


  manager.send(clientFrame).onError((error, stackTrace) {

print('occur exception!');
    print(stackTrace);
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
