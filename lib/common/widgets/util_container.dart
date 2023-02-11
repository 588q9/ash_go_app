import 'dart:async';

import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/database/mapper.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yaml/yaml.dart';

class UtilContainer extends InheritedWidget {
  UtilContainer({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child){
 
         rootBundle.loadString("assets/configuration/application.yml").then((value) {
    var doc = loadYaml(value)['server'];
configuration.complete(doc);

         });

  }

   ConnectClient? _client;
  Future<Database>?   _mapper;
   final Completer configuration=Completer();
connect(){
  _client ??= ConnectClient(configuration.future);

}
successAuthentication(String userId){
   _mapper= Mapper(userId).mapper;
}
 Future<Database> get mapper{
  return _mapper!;
}
ConnectClient get client{
  return _client!;
}

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static UtilContainer? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UtilContainer>();
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(UtilContainer old) {
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
