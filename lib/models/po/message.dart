// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import '../vo/user_vo.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)

class Message {
  static final MESSAGE_TABLE="message";
String? id;
int messageType;
int createTime;

int? clientId;
int? messageStatus;
  String userId;
 String? textContent;
 String? extensionContent;

  @JsonKey(includeToJson: false,includeFromJson: false)
  UserVO? sendUserVO;

Message(this.userId,this.messageType,

this.createTime,[this.id,this.messageStatus,this.clientId,this.textContent,this.extensionContent]);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  String toString() {
    return 'Message{id: $id, messageType: $messageType, createTime: $createTime, clientId: $clientId, messageStatus: $messageStatus, userId: $userId, textContent: $textContent, extensionContent: $extensionContent}';
  }
}
