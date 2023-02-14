import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_server_frame.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_pull_session_server_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class UserPullSessionServerFrame extends UserServerFrame{
  static const PACKET_TYPE = PacketType.PULL_SESSION;


UserPullSessionServerFrame();

  @override
  PacketType getPacketType() {
   return PACKET_TYPE;
  }

       factory UserPullSessionServerFrame.fromJson(Map<String, dynamic> json) =>
      _$UserPullSessionServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserPullSessionServerFrameToJson(this);
    
}