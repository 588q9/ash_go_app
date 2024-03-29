// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:ash_go/models/po/user.dart';
import 'package:ash_go/models/vo/simple_user_info_vo.dart';

part 'user_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class UserVO {


    String? id;
  String? username;
   int? userNumber;
String ?headUrl;


UserVO( {this.id,this.username,this.userNumber,this.headUrl});
   factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);
  Map<String, dynamic> toJson() => _$UserVOToJson(this);

    @override
  String toString() {
    return 'UserVO{id: $id, username: $username, userNumber: $userNumber, headUrl: $headUrl}';
  }
}
