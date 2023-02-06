


import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_server_frame.dart';
import 'package:ash_go/models/vo/user_vo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_info_server_frame.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfoServerFrame extends UserServerFrame{
  static const PACKET_TYPE = PacketType.USER_INFO;
UserInfoServerFrame(this.user);
UserVO user;

  @override
  PacketType getPacketType() {
return PACKET_TYPE;  }

     factory UserInfoServerFrame.fromJson(Map<String, dynamic> json) =>
      _$UserInfoServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserInfoServerFrameToJson(this);


}