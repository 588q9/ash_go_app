import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_client_frame.dart';
import 'package:json_annotation/json_annotation.dart';


part 'user_info_client_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class UserInfoClientFrame extends  UserClientFrame{

  static const PACKET_TYPE = PacketType.USER_INFO;

UserInfoClientFrame();

  @override
  PacketType getPacketType() {
  return PACKET_TYPE;
  }

   factory UserInfoClientFrame.fromJson(Map<String, dynamic> json) =>
      _$UserInfoClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserInfoClientFrameToJson(this);



}