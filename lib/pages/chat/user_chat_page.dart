


import 'dart:async';

import 'package:ash_go/common/enums/message_status.dart';
import 'package:ash_go/common/enums/message_type.dart';
import 'package:ash_go/common/protocol/frame/client/common_client_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/contact_message.dart';
import 'package:ash_go/models/po/message.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/vo/user_vo.dart';
import 'package:ash_go/pages/overview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/protocol/enums/packet_type.dart';
import '../../common/protocol/frame/server/common_server_frame.dart';
import '../../models/vo/contact_message_vo.dart';
import '../../routes/routes_container.dart';
import '../chat_page.dart';

class SendContactMessageEvent{
  ContactMessageVO contactMessageVO;

  SendContactMessageEvent(this.contactMessageVO);
}
class MessageStatusUpdateEvent{


}

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
  StreamSubscription<SendContactMessageEvent>? _sendMessageEventController;
  StreamSubscription<MessageStatusUpdateEvent>? _messageStatusUpdateEventController;
  @override
  void initState() {
    super.initState();
  userChatInfo=widget.initUserChatInfo;



  }


  @override
  void dispose() {
    super.dispose();
_sendMessageEventController?.cancel();

  }

  Future<List<ContactMessageVO>> loadUserMessage()async{


return (await UtilContainer.getMapper(context).then((db) async{

var mapList=(await  db.rawQuery('select * from contact_message a inner join message b on a.messageClientId=b.clientId where userId=? or (a.receiveUserId=? and b.userId=?) order by createTime desc',
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
  }).then((value) {
    _messageStatusUpdateEventController=UtilContainer.getEventBus(context).on<MessageStatusUpdateEvent>().listen((event) {
      setState(() {

      });
    });
   _sendMessageEventController=UtilContainer.getEventBus(context).on<SendContactMessageEvent>().listen((event) {
     setState(() {
        messages.insert(0,event.contactMessageVO);

      });
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
void sendMessage(){
  String textContent=super.textMessageController.text;

  UtilContainer.getMapper(context).then((db) async{
    var message=ContactMessageVO(widget.initUserChatInfo.id,
        await UtilContainer.getLoginUserId(context)
        ,MessageType.TEXT.index,DateTime.now().millisecondsSinceEpoch
        ,null,MessageStatus.SENDING.index,null,textContent,null
    );
    int messageClientId=(await db.insert(ContactMessage.CONTACT_MESSAGE_TABLE,ContactMessage.fromJson(message.toJson()).toJson()));
    message.clientId=messageClientId;

    await db.insert(Message.MESSAGE_TABLE,Message.fromJson(message.toJson()).toJson() );

    ContactMessageVO contactMessageVO=ContactMessageVO.fromJson(message.toJson());

    contactMessageVO.sendUserVO=UserVO.fromJson((await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [await UtilContainer.getLoginUserId(context)]))[0]);

    UtilContainer.getEventBus(context).fire(SendContactMessageEvent(contactMessageVO));
super.textMessageController.text='';
    UtilContainer.getClient(context).send(CommonClientFrame(packetType :PacketType.SEND_MESSAGE_TO_CONTACT,data:{
      'contactMessage':
      message.toJson()})).then((value){
        value as CommonServerFrame;
        ContactMessageVO contactMessageVOHaveId=ContactMessageVO.fromJson(value.data!['message']) ;
        contactMessageVOHaveId.clientId=messageClientId;
        Message message=Message.fromJson(contactMessageVOHaveId.toJson());
        message.messageStatus=MessageStatus.SENT.index;
        contactMessageVO.messageStatus=MessageStatus.SENT.index;
        UtilContainer.getMapper(context).then((db)async {
          ContactMessage contactMessage=ContactMessage();
          contactMessage.messageClientId=messageClientId;
          contactMessage.receiveUserId=contactMessageVOHaveId.receiveUserId;
          contactMessage.messageId=contactMessageVOHaveId.id;
         db.transaction((txn) {
            txn.update(ContactMessage.CONTACT_MESSAGE_TABLE, contactMessage.toJson(),where: 'messageClientId=?',
                whereArgs: [messageClientId]
            );

            txn.update(Message.MESSAGE_TABLE,message.toJson(), where: 'clientId=?',whereArgs: [messageClientId])
                .then((value) {
              UtilContainer.getEventBus(context).fire(MessageStatusUpdateEvent());

            });

return Future(() => null);
          });


        });

    });

  });


}


@override
  initState(){
    super.initState();
  super.rightOtherButton=widget.rightOtherButton;
    super.sendMessageCallback=sendMessage;

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


