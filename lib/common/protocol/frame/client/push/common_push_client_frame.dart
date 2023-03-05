import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/push/push_client_frame.dart';
import 'package:json_annotation/json_annotation.dart';
part 'common_push_client_frame.g.dart';

@JsonSerializable(explicitToJson: true)
class CommonPushClientFrame extends PushClientFrame{

  static const PACKET_TYPE = PacketType.PUSH_OK;

Map<String,dynamic?>? data;

  CommonPushClientFrame({this.data});

  @override
  PacketType getPacketType() {
    return PACKET_TYPE;
  }
  factory CommonPushClientFrame.fromJson(Map<String, dynamic> json) =>
      _$CommonPushClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CommonPushClientFrameToJson(this);



}