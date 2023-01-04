import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ping_client_frame.g.dart';

@JsonSerializable()

class PingClientFrame extends ClientFrame{
String? message;
static const PACKET_TYPE=PacketType.PING;
PingClientFrame({this.message='ping'});

factory PingClientFrame.fromJson(Map<String, dynamic> json) => _$PingClientFrameFromJson(json);
@override
  Map<String, dynamic> toJson() => _$PingClientFrameToJson(this);
  
  @override
  PacketType getPacketType() {
  return PACKET_TYPE;
  }

  
}