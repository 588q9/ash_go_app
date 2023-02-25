


import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/message.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/vo/user_vo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/po/contact_message.dart';
import '../../models/vo/contact_message_vo.dart';
import '../../routes/routes_container.dart';
import '../chat_page.dart';

  class UserChatInfo extends ChatTitleInfo{
  String onlineTime;

  UserChatInfo({required this.onlineTime,required super.headUrl
    ,required super.name,super.status,required super.id});
}

class UserMessageDigram extends MessageDiagram{
 ContactMessageVO contactMessage;

 UserMessageDigram({required this.contactMessage,super.isMySent}) : super(message: contactMessage);

}



class UserChatPageState extends State<UserChatPage>{
  UserChatInfo userChatInfo;
List<ContactMessageVO> messages=[];

  UserChatPageState(this.userChatInfo);

Future<List<ContactMessageVO>> loadUserMessage()async{

return (await UtilContainer.getMapper(context).then((db) async{

var mapList=(await  db.rawQuery('select * from contact_message a inner join message b on a.messageClientId=b.clientId where userId=? or (a.receiveUserId=? and b.userId=?) order by createTime asc',
         [userChatInfo.id,userChatInfo.id,await UtilContainer.getLoginUserId(context) ]));
var user=UserVO.fromJson( (await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [userChatInfo.id]))[0]);

var myUser=UserVO.fromJson((await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [await UtilContainer.getLoginUserId(context)]))[0]);

var contactMessages=mapList.map((e){
  var temp=ContactMessageVO.fromJson(e);
if(temp.userId==user.id){
  temp.sendUserVO=user;

}  else{
  temp.sendUserVO=myUser;
}


return temp;
});
return contactMessages.toList();
  }));


}


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  loadUserMessage().then((value) {
    setState(() {
      messages=value;

    });
  });


  }

  @override
  Widget build(BuildContext context) {
    return
      ChatPage(chatTitleInfo: userChatInfo, bottomBarSpan: [
        TextSpan(text: userChatInfo.status??userChatInfo.onlineTime),



      ],


          popupMenuButton: PopupMenuButton(onSelected: (value) {
            if (value == 1) {

              Navigator.push(context, UserInfoPageRoute());
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('用户信息'),
                value: 1,
              ),
              PopupMenuItem(child: Text('视频聊天'))
            ];
          }), messageDigrams: messages.map((e) => UserMessageDigram(contactMessage: e,isMySent: e.receiveUserId==
            userChatInfo.id
            ,)).
          toList()


      );

  }
}

class UserChatPage extends StatefulWidget{

  UserChatInfo userChatInfo;

  UserChatPage(this.userChatInfo);

  @override
  State createState() {
    return UserChatPageState(userChatInfo);
  }
}