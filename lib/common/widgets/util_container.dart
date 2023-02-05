import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/database/mapper.dart';
import 'package:flutter/material.dart';

class UtilContainer extends InheritedWidget {
  UtilContainer({
    Key? key,
    
    required Widget child,
  }) : super(key: key, child: child);

final client=IsolateClient();
final  mapper =Mapper().mapper;
  //定义一个便捷方法，方便子树中的widget获取共享数据
  static UtilContainer? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UtilContainer>();
  }

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget重新build
  @override
  bool updateShouldNotify(UtilContainer old) {
    return old.client!=client||old.mapper!=mapper;
  }
}
