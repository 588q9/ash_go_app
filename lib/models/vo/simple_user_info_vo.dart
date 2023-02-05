
import 'package:json_annotation/json_annotation.dart';

part 'simple_user_info_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class SimpleUserInfoVO{

     String username;
     int userNumber;
     String headUrl;
String id;
     SimpleUserInfoVO(this.headUrl,this.userNumber,this.username,this.id);
   factory SimpleUserInfoVO.fromJson(Map<String, dynamic> json) => _$SimpleUserInfoVOFromJson(json);
  Map<String, dynamic> toJson() => _$SimpleUserInfoVOToJson(this);  
}