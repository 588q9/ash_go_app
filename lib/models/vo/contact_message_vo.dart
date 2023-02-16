// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:ash_go/models/po/message.dart';
import 'package:json_annotation/json_annotation.dart';
part 'contact_message_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactMessageVO extends Message {
 
String receiveUserId;

  ContactMessageVO(
    this.receiveUserId,super.userId,super.messageType,

super.createTime,[super.id,super.isSend,super.clientId,super.textContent,super.extensionContent]
  );
   factory ContactMessageVO.fromJson(Map<String, dynamic> json) => _$ContactMessageVOFromJson(json);
  Map<String, dynamic> toJson() => _$ContactMessageVOToJson(this);  

}
