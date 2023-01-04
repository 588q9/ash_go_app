import 'dart:typed_data';

import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/enums/protocol_version.dart';

class OriginVersionPacket extends Packet {
 final int magicNumber = Packet.MAGIC_NUMBER;
  static final int TYPE_FIELD_LENGTH = 2;

  static final int LENGTH_FIELD_LENGTH = 4;

static final ProtocolVersion  VERSION=ProtocolVersion.VERSION_1;

  static final int SERIALIZE_TYPE_FIELD_LENGTH = 1;

  static final int SERIES_ID_FIELD_LENGTH = 4;

  static final int HEADER_LENGTH = Packet.MAGIC_NUMBER_FIELD_LENGTH +
      Packet.VERSION_FIELD_LENGTH +
      TYPE_FIELD_LENGTH +
      LENGTH_FIELD_LENGTH +
      SERIALIZE_TYPE_FIELD_LENGTH +
      SERIES_ID_FIELD_LENGTH;

}
