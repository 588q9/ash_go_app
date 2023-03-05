import 'dart:async';

import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/database/mapper.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_login_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/push/push_contact_message_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/push/push_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/server_push_handler.dart';
import 'package:ash_go/models/po/login_token.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yaml/yaml.dart';

import '../protocol/enums/packet_type.dart';
import '../protocol/frame/server/user/user_login_server_frame.dart';
typedef serverPushHandlerCallback=void Function(PushServerFrame);

class AppUtil{
  ConnectClient? client;
  Future<Database>?   mapper;
  Mapper? mapperMetaInfo;
  final Completer configuration=Completer();
final Completer<String> userIdCompleter=Completer();
  AppUtil({this.client, this.mapper, this.mapperMetaInfo}){
    rootBundle.loadString("assets/configuration/application.yml").then((value) {
      var doc = loadYaml(value)['server'];
      configuration.complete(doc);

    });

  }

}

class UtilContainer extends InheritedWidget {
  UtilContainer({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);


AppUtil? _util;
 final EventBus eventBus = EventBus();

 static EventBus getEventBus(BuildContext context){
   return UtilContainer.of(context)!.eventBus;

 }
static ConnectClient getClient(BuildContext context){
  return UtilContainer.of(context)!.client;

}
  static Future<Database> getMapper(BuildContext context){
    return UtilContainer.of(context)!.mapper;

  }
  static Future<String> getLoginUserId(BuildContext context) {
  return  UtilContainer.of(context)!.userId;
  }

  initServerPushHandler(){
   if(_serverPushHandler.length>0){
     return;
   }

   _serverPushHandler[PacketType.PUSH_OTHER_USER_CONTACT_MESSAGE]=(PushServerFrame serverFrame){
      serverFrame as PushContactMessageServerFrame;

      receiveContactMessage(serverFrame, this);
    };

  }


connect(){
  _util??=AppUtil();
  _util!.client ??= ConnectClient(_util!.configuration.future,reconnected: reAuthentication

  );

}
reAuthentication(){
  _util?.mapper?.then((db)async{
    var tokens= await db.query(LoginToken.LOGIN_TOKEN_TABLE);

    if(tokens.length>0){

      print('user reAuthentication ');

      _util!.client!.send(UserLoginClientFrame(token: LoginToken.fromJson(tokens.first).token)).then((value) {
        if(value is UserLoginServerFrame){
          _util!.mapper!.then((db) async{
            db.insert(LoginToken.LOGIN_TOKEN_TABLE, LoginToken(value.token,await userId).toJson()
                ,conflictAlgorithm: ConflictAlgorithm.replace
            );

          }).onError((error, stackTrace) {
            print(error);
            print('reauth error');

          });
        }

      });

    }

  });

}

successAuthentication(String userId){
  _util!.mapperMetaInfo??=Mapper(userId);
   _util!.mapper??= _util!.mapperMetaInfo!.mapper;
  _util!.userIdCompleter.complete(userId);


}
 Future<Database> get mapper{
  return _util!.mapper!;
}
Future<String> get userId{
  return _util!.userIdCompleter.future;
}

ConnectClient get client{
  return _util!.client!;
}
  Mapper get mapperMetaInfo{
  return _util!.mapperMetaInfo!;
  }
  //定义一个便捷方法，方便子树中的widget获取共享数据
  static UtilContainer? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UtilContainer>();
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify( UtilContainer oldWidget) {

  if(oldWidget._util!=null){
    _util=oldWidget._util;
  }
    return false;
  }
}
final Map<PacketType,serverPushHandlerCallback> _serverPushHandler={};


class ConnectClient {
  final Completer<IsolateClient> _clientCompleter = Completer();
VoidCallback? reconnected;





  ConnectClient(Future config,{this.reconnected}) {

    _init(config);
  }
  _init(Future config) async {
    var map=await config;
    var client = IsolateClient(map['host'], map['port'],reconnected: reconnected);
    //TODO 服务端主动推送处理方法
    client.serverPushContainer.stream.listen((event) {
      if(event is  PushContactMessageServerFrame){

        _serverPushHandler[event.getPacketType()]?.call(event);

      }

    });


    _clientCompleter.complete(client);
  }

  Future<ServerFrame> send(ClientFrame clientFrame) async {
    IsolateClient client = await _clientCompleter.future;
    return client.send(clientFrame);
  }
}
