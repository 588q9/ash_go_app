import 'package:ash_go/pages/chat/user_chat_page.dart';
import 'package:ash_go/pages/chat_page.dart';
import 'package:ash_go/pages/chat/group_chat_page.dart';
import 'package:ash_go/pages/group_info_page.dart';
import 'package:ash_go/pages/index_page.dart';
import 'package:ash_go/pages/login_page.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:ash_go/pages/register_page.dart';
import 'package:ash_go/pages/user_info_page.dart';
import 'package:flutter/material.dart';

class LoginRoute extends MaterialPageRoute {
  LoginRoute()
      : super(builder: (context) {
          return LoginPage();
        });
}

class IndexRoute extends MaterialPageRoute {
  IndexRoute()
      : super(builder: (context) {
          return IndexPage();
        });
}

class OverviewRoute extends MaterialPageRoute {
  OverviewRoute()
      : super(builder: (context) {
          return OverviewPage();
        });
}

class ChatPageRoute extends MaterialPageRoute {
  ChatItem chatItem;

  ChatPageRoute(this.chatItem)
      : super(builder: (context) {

          return chatItem.isGroup?GroupChatPage(
              GroupChatInfo(onlineNums: 0, memeberNums: 0, headUrl: chatItem.headUrl, name: chatItem.name, id: chatItem.id)
              )
          :UserChatPage(UserChatInfo(onlineTime: '', headUrl: chatItem.headUrl, name: chatItem.name, id: chatItem.id))
          ;
        });
}

class UserInfoPageRoute extends MaterialPageRoute {
  UserInfoPageRoute()
      : super(builder: (context) {
          return UserInfoPage();
        });
}

class GroupInfoPageRoute extends MaterialPageRoute {
  GroupInfoPageRoute()
      : super(builder: (context) {
          return GroupInfoPage();
        });
}
class RegisterPageRoute extends MaterialPageRoute {
  RegisterPageRoute()
      : super(builder: (context) {
          return RegisterPage();
        });
}