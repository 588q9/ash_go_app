
import 'package:ash_go/models/po/group_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/vo/group_message_vo.dart';
import '../../routes/routes_container.dart';
import '../chat_page.dart';

class GroupChatInfo extends ChatTitleInfo{
  int onlineNums;
  int memeberNums;

  GroupChatInfo({required this.onlineNums,required this.memeberNums,required super.headUrl
    ,required super.name,super.status,required super.id
  }) ;

}




class GroupMessageDigram extends MessageDiagram{
  GroupMessageVO groupMessage;

  GroupMessageDigram({required this.groupMessage}) : super(message: groupMessage);
}


class GroupChatPageState extends State<GroupChatPage>{
GroupChatInfo groupChatInfo;

GroupChatPageState({required this.groupChatInfo});

  @override
  Widget build(BuildContext context) {
return ChatPage(chatTitleInfo: groupChatInfo, bottomBarSpan: [
  TextSpan(text: '11'),
  const TextSpan(text: '个成员，'),
  TextSpan(text: '11'),
  const TextSpan(text: '人在线'),

], popupMenuButton:  PopupMenuButton(onSelected: (value) {
  if (value == 1) {

    Navigator.push(context, GroupInfoPageRoute());
  }
}, itemBuilder: (context) {
  return [
    PopupMenuItem(
      child: Text('群聊信息'),
      value: 1,
    ),
    PopupMenuItem(child: Text('离开群聊'))
  ];
})
    , messageDigrams: [], chatBottomBar: GroupChatBottomBar(),);
  }
}

class GroupChatBottomBarState extends ChatBottomBarState<GroupChatBottomBar>{


}

class GroupChatBottomBar extends ChatBottomBar{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}


class GroupChatPage extends StatefulWidget{
GroupChatInfo initGroupChatInfo;


GroupChatPage(this.initGroupChatInfo);

  @override
  State createState() {
    return GroupChatPageState(groupChatInfo: initGroupChatInfo);
  }
}