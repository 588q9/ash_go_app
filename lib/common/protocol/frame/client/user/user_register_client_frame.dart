import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_client_frame.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_register_client_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class UserRegisterClientFrame extends UserClientFrame{
  static const PACKET_TYPE = PacketType.USER_REGISTER;
     String username;
     String? email;

     String password;

UserRegisterClientFrame(this.username,this.password);
  @override
  PacketType getPacketType() {
    return PACKET_TYPE;
  }

    factory UserRegisterClientFrame.fromJson(Map<String, dynamic> json) =>
      _$UserRegisterClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserRegisterClientFrameToJson(this);


  
}