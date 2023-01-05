import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pong_server_frame.g.dart';

@JsonSerializable(explicitToJson: true)
class PongServerFrame extends ServerFrame {
  String message;
  static const PACKET_TYPE = PacketType.PING;

  PongServerFrame({this.message = 'pong'});

  factory PongServerFrame.fromJson(Map<String, dynamic> json) =>
      _$PongServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PongServerFrameToJson(this);

  @override
  PacketType getPacketType() {
    return PACKET_TYPE;
  }

  @override
  String toString() {
    return message;
  }
}
