

import 'package:ash_go/common/enums/message_status.dart';
import 'package:ash_go/common/protocol/frame/server/push/push_contact_message_server_frame.dart';
import 'package:ash_go/common/widgets/util_container.dart';
import 'package:ash_go/models/po/contact_message.dart';
import 'package:ash_go/models/po/message.dart';
import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/vo/contact_message_vo.dart';
import 'package:ash_go/pages/chat/user_chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/vo/user_vo.dart';

Future receiveContactMessage(PushContactMessageServerFrame serverFrame
 ,UtilContainer utilContainer
    )async{

 ContactMessageVO contactMessage=serverFrame.contactMessage;
Database db= await utilContainer.mapper;
Message message=Message.fromJson(contactMessage.toJson());
message.messageStatus=MessageStatus.SENT.index;

int clientId=await db.insert(Message.MESSAGE_TABLE, message.toJson());
ContactMessage contactMessageDb=ContactMessage.fromJson(contactMessage.toJson());
contactMessageDb.messageClientId=clientId;
await db.insert(ContactMessage.CONTACT_MESSAGE_TABLE, contactMessageDb.toJson());
 var user=UserVO.fromJson( (await db.query(User.USER_TABLE,where: 'id=?',whereArgs: [contactMessage.userId]))[0]);
 user.username='';
contactMessage.sendUserVO=user;

utilContainer.eventBus.streamController.add(SendContactMessageEvent(contactMessage));


}