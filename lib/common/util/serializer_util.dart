import 'dart:typed_data';

import 'package:ash_go/common/protocol/enums/packet_type.dart';


abstract class  SerializerUtil<T>{

Uint8List serializer(T src);

  dynamic deserializer(Uint8List data,PacketType type);


}

