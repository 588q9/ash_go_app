// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_server_frame.dart';

part 'user_login_server_frame.g.dart';

@JsonSerializable(explicitToJson: true)
class UserLoginServerFrame extends UserServerFrame {

 String token;
 String userId;
UserLoginServerFrame(this.token,this.userId);

  static const PACKET_TYPE = PacketType.USER_LOGIN;

  @override
  PacketType getPacketType() {
return PACKET_TYPE;
  }


   factory UserLoginServerFrame.fromJson(Map<String, dynamic> json) =>
      _$UserLoginServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserLoginServerFrameToJson(this);



  @override
  String toString() => 'UserLoginServerFrame(token: $token)';
}
