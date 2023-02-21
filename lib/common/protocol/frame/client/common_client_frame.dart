import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/client_frame.dart';
import 'package:json_annotation/json_annotation.dart';
part 'common_client_frame.g.dart';


@JsonSerializable(explicitToJson: true)
class CommonClientFrame extends ClientFrame{
  
  Map<String,dynamic>? data;
  
@JsonKey(includeFromJson: false,includeToJson: false)
  PacketType? packetType;

CommonClientFrame({ this.packetType, this.data});


    @override
  PacketType getPacketType() {
   return packetType!;
  }

  

   factory CommonClientFrame.fromJson(Map<String, dynamic> json) =>
      _$CommonClientFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CommonClientFrameToJson(this);




}