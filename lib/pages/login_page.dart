import 'package:ash_go/common/enums/message_status.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_login_client_frame.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_pull_session_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_login_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_pull_session_server_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/contact_message.dart';
import 'package:ash_go/models/po/login_token.dart';
import 'package:ash_go/models/po/message.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/po/user_contacts.dart';
import 'package:ash_go/models/vo/session_vo.dart';
import 'package:ash_go/routes/routes_container.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/vo/user_contact_vo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Text(
                  '立刻登录以进行使用！',
                  textScaleFactor: 2,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 30),
                  child: Text(
                    style: TextStyle(color: Colors.grey),
                    '很高兴你能使用AshGO!',
                    textScaleFactor: 1.3,
                  ),
                ),
                Column(
                  children: [
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        hintText: '电子邮箱地址或账号或电话号码',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: '密码',
                          )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Text(
                        '忘记密码',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('敬请期待')));
                      },
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          var frame = UserLoginClientFrame(
                              userIdenity: _idController.text,
                              password: _passwordController.text);

                          loginOrRegisterLogic(frame, context);
                        },
                        child: Text('登录'),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> pullSessionDataToDB(SessionVO session, Database database) async {
 return await database.transaction((txn) async {

    for (UserContactVO userContact in session.userContacts) {
      txn.insert(
          User.USER_TABLE,
          User(
                  userContact.username,
                  userContact.headUrl,
                  userContact.userNumber,
                  userContact.id,
                  userContact.updateTime)
              .toJson());
      txn.insert(UserContacts.USER_CONTACTS_TABLE,
          UserContacts(userContact.id, userContact.contactCreateTime).toJson());

      for (var message in userContact.sendToUserMessages) {
        int clientId = await txn.insert(
            Message.MESSAGE_TABLE,
            Message(
                    message.userId,
                    message.messageType,
                    message.createTime,
                    message.id,
                    MessageStatus.SENT.index,
                    null,
                    message.textContent,
                    message.extensionContent)
                .toJson());
        txn.insert(
            ContactMessage.CONTACT_MESSAGE_TABLE,
            ContactMessage(
                    messageId: message.id,
                    messageClientId: clientId,
                    receiveUserId: message.receiveUserId)
                .toJson());
      }
    }
    for (var myContactMessage in session.mySendContactsMessages) {
      int clientId = await txn.insert(
          ContactMessage.CONTACT_MESSAGE_TABLE,
          ContactMessage(
                  messageId: myContactMessage.id,
                  receiveUserId: myContactMessage.receiveUserId)
              .toJson());
      txn.insert(
          Message.MESSAGE_TABLE,
          Message(
                  myContactMessage.userId,
                  myContactMessage.messageType,
                  myContactMessage.createTime,
                  myContactMessage.id,
                  MessageStatus.SENT.index,
                  clientId,
                  myContactMessage.textContent,
                  myContactMessage.extensionContent)
              .toJson());
    }
    return;
  });
}

void loginOrRegisterLogic(ClientFrame frame, BuildContext context) {
  var utilContainer = UtilContainer.of(context);
  utilContainer!.connect();
  utilContainer.client.send(frame).then((value) async {
    if (value is UserLoginServerFrame) {
      utilContainer.successAuthentication(value.userId);
      var mapper = await utilContainer.mapper;
      utilContainer.initServerPushHandler();

 await utilContainer.mapperMetaInfo.isFirstCreateDb.future.then((value)async {
   if(!value){
     return;
   }
   var sessionFrame=await utilContainer.client.send(UserPullSessionClientFrame());
   if(sessionFrame is UserPullSessionServerFrame){

   await  pullSessionDataToDB(sessionFrame.session, mapper);

   }
 });


      await mapper.insert(LoginToken.LOGIN_TOKEN_TABLE, value.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);

      return true;
    }
    return false;
  }).then((value) {
    if (value) {
      Navigator.pushAndRemoveUntil(context, OverviewRoute(), (route) => false);
    }
  });
}
