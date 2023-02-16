import 'package:ash_go/models/vo/contact_message_vo.dart';
import 'package:ash_go/models/vo/simple_user_info_vo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_contact_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class UserContactVO extends SimpleUserInfoVO{
  UserContactVO(this.sendToUserMessages,super.headUrl, super.userNumber, super.username, super.id);
List<ContactMessageVO> sendToUserMessages;

   factory UserContactVO.fromJson(Map<String, dynamic> json) => _$UserContactVOFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserContactVOToJson(this);  

}