// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';

part 'exception_server_frame.g.dart';

@JsonSerializable(explicitToJson: true)
class ExceptionServerFrame extends ServerFrame {
  static const PACKET_TYPE = PacketType.EXCEPTION;
 String errorMessage;

 int exceptionCode;

ExceptionServerFrame(this.errorMessage,this.exceptionCode);

  @override
  PacketType getPacketType() {
return PACKET_TYPE;
  }



  factory ExceptionServerFrame.fromJson(Map<String, dynamic> json) =>
      _$ExceptionServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ExceptionServerFrameToJson(this);

  

  @override
  String toString() => 'ExceptionServerFrame(errorMessage: $errorMessage, exceptionCode: $exceptionCode)';
}
