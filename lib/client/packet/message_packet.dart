import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';

import 'package:flutter/foundation.dart';

class MessagePacket extends OriginVersionPacket {
  PacketType type;
  int length;
  SerializeType serializeType;
  int seriesId;
  ByteData content;

  MessagePacket(
      {required this.type,
      required this.length,
      required this.serializeType,
      required this.seriesId,
      required this.content});



}
