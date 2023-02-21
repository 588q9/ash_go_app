
import 'package:ash_go/models/vo/contact_message_vo.dart';
import 'package:ash_go/models/vo/user_contact_vo.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class SessionVO{
 List<UserContactVO> userContacts;


 @override
  String toString() {
    return 'SessionVO{userContacts: $userContacts, mySendContactsMessages: $mySendContactsMessages}';
 }

  List<ContactMessageVO> mySendContactsMessages;
SessionVO(this.userContacts,this.mySendContactsMessages);
   factory SessionVO.fromJson(Map<String, dynamic> json) => _$SessionVOFromJson(json);
  Map<String, dynamic> toJson() => _$SessionVOToJson(this);  


}