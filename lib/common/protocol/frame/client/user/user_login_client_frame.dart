import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/user/user_client_frame.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_login_client_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class UserLoginClientFrame extends UserClientFrame {
  static const PACKET_TYPE = PacketType.USER_LOGIN;
UserLoginClientFrame({
this.userIdenity,this.token,
this.password

});
String? userIdenity;
    String? password;


    String? token;
  @override
  PacketType getPacketType() {
return PACKET_TYPE;
  }
       factory UserLoginClientFrame.fromJson(Map<String, dynamic> json) =>
      _$UserLoginClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserLoginClientFrameToJson(this);

}

