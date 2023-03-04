


import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/push/push_server_frame.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../models/vo/contact_message_vo.dart';
part 'push_contact_message_server_frame.g.dart';

@JsonSerializable(explicitToJson: true)

class PushContactMessageServerFrame extends PushServerFrame{
  static const PACKET_TYPE = PacketType.PUSH_OTHER_USER_CONTACT_MESSAGE;
   ContactMessageVO contactMessage;

  PushContactMessageServerFrame({required this.contactMessage,required super.pushSeriesId});

  @override
  PacketType getPacketType() {

    return PACKET_TYPE;
  }

  factory PushContactMessageServerFrame.fromJson(Map<String, dynamic> json) =>
      _$PushContactMessageServerFrameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PushContactMessageServerFrameToJson(this);

}