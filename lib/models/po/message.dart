// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)

class Message {
  static final MESSAGE_TABLE="message";
String? id;
int messageType;
int createTime;

int? clientId;
int? isSend;
int userId;
 String? textContent;
 String? extensionContent;
Message(this.userId,this.messageType,

this.createTime,[this.id,this.isSend,this.clientId,this.textContent,this.extensionContent]);



  @override
  String toString() {
    return 'Message(id: $id, messageType: $messageType, createTime: $createTime, clientId: $clientId, isSend: $isSend, userId: $userId, textContent: $textContent, extensionContent: $extensionContent)';
  }
}
