import 'dart:async';

import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/database/mapper.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yaml/yaml.dart';

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
static ConnectClient getClient(BuildContext context){
  return UtilContainer.of(context)!.client;

}
  static Future<Database> getMapper(BuildContext context){
    return UtilContainer.of(context)!.mapper;

  }
  static Future<String> getLoginUserId(BuildContext context) {
  return  UtilContainer.of(context)!.userId;
  }

connect(){
  _util??=AppUtil();
  _util!.client ??= ConnectClient(_util!.configuration.future);

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
  bool updateShouldNotify( UtilContainer old) {

  if(old._util!=null){
    _util=old._util;
  }
    return false;
  }
}

class ConnectClient {
  final Completer<IsolateClient> _clientCompleter = Completer();

  ConnectClient(Future config) {
    _init(config);
  }
  _init(Future config) async {
    var map=await config;
    var client = IsolateClient(map['host'], map['port']);
    _clientCompleter.complete(client);
  }

  Future<dynamic> send(ClientFrame clientFrame) async {
    IsolateClient client = await _clientCompleter.future;
    return client.send(clientFrame);
  }
}
