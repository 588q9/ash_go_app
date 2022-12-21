import 'package:ash_go/pages/login_page.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:flutter/material.dart';

import '../pages/chat_page.dart';
import '../pages/index_page.dart';




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

class ChatPageRoute extends MaterialPageRoute{
  ChatPageRoute():super(builder:(context){
return ChatPage();
  });
  
}