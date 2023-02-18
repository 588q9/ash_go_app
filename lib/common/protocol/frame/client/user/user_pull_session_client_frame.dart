

 import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_client_frame.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_pull_session_client_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class UserPullSessionClientFrame extends UserClientFrame{
  static const PACKET_TYPE = PacketType.PULL_SESSION;


UserPullSessionClientFrame();

  @override
  PacketType getPacketType() {
   return PACKET_TYPE;
  }

       factory UserPullSessionClientFrame.fromJson(Map<String, dynamic> json) =>
      _$UserPullSessionClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserPullSessionClientFrameToJson(this);
    
}