


import 'package:ash_go/common/enums/message_status.dart';
import 'package:ash_go/common/enums/message_type.dart';
import 'package:ash_go/common/protocol/frame/client/common_client_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/vo/user_vo.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/protocol/enums/packet_type.dart';
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

class UserChatPage extends StatefulWidget{

  final  UserChatInfo initUserChatInfo;

  const UserChatPage(this.initUserChatInfo, {super.key});

  @override
  State createState() {
    return UserChatPageState();
  }
}

class UserChatPageState extends State<UserChatPage>{
  UserChatInfo userChatInfo=UserChatInfo(onlineTime: '', headUrl: DEFAULT_HEAD_URL, name: '', id: '');
List<ContactMessageVO> messages=[];

  @override
  void initState() {
    super.initState();
  userChatInfo=widget.initUserChatInfo;

  }



Future<List<ContactMessageVO>> loadUserMessage()async{

return (await UtilContainer.getMapper(context).then((db) async{

var mapList=(await  db.rawQuery('select * from contact_message a inner join message b on a.messageClientId=b.clientId where userId=? or (a.receiveUserId=? and b.userId=?) order by createTime asc',
         [userChatInfo.id,userChatInfo.id,await UtilContainer.getLoginUserId(context) ]));
var user=UserVO.fromJson( (await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [userChatInfo.id]))[0]);

var myUser=UserVO.fromJson((await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [await UtilContainer.getLoginUserId(context)]))[0]);
user.username='';
myUser.username='';
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
          toList(), chatBottomBar:UserChatBottomBar(
            rightOtherButton: [Expanded(child: Icon(Icons.attach_file), flex: 1),

              Expanded(child: Icon(Icons.phone), flex: 1)], initUserChatInfo: userChatInfo,

        )

        ,


      );

  }
}

class UserChatBottomBarState extends ChatBottomBarState<UserChatBottomBar>{

@override
  initState(){
    super.initState();
  super.rightOtherButton=widget.rightOtherButton;
    super.sendMessageCallback=(){
      String textContent=super.textMessageController.text;
      UtilContainer.getMapper(context).then((value) async{
        var message=ContactMessageVO(widget.initUserChatInfo.id,
           await UtilContainer.getLoginUserId(context)
            ,MessageType.TEXT.index,DateTime.now().millisecondsSinceEpoch
            ,null,MessageStatus.SENDING.index,null,textContent,null
        );

        UtilContainer.getClient(context).send(CommonClientFrame(packetType :PacketType.SEND_MESSAGE_TO_CONTACT,data:{
          'contactMessage':
          message.toJson()})).then((value){});

      });


    };

}

}

class UserChatBottomBar extends ChatBottomBar{
final  List<Widget> rightOtherButton;

final UserChatInfo initUserChatInfo;

const UserChatBottomBar({super.key, required this.rightOtherButton,required this.initUserChatInfo});

  @override
  State<StatefulWidget> createState() {
    return UserChatBottomBarState();
  }


}


