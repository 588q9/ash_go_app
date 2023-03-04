import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:json_annotation/json_annotation.dart';
part 'common_server_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class CommonServerFrame extends ServerFrame{

Map<String,dynamic>? data;
  static const PACKET_TYPE = PacketType.COMMON;

CommonServerFrame({this.data});

  @override
  PacketType getPacketType() {
  return PACKET_TYPE;
  }
  
   factory CommonServerFrame.fromJson(Map<String, dynamic> json) =>
      _$CommonServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CommonServerFrameToJson(this);

@override
  String toString() {
    return 'CommonServerFrame{data: $data}';
  }
}