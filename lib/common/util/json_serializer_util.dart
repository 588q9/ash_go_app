import 'dart:convert';
import 'dart:typed_data';

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/util/serializer_util.dart';

typedef DeserializerHandler = Function(Map<String, dynamic> data);

class JsonSerializerUtil extends SerializerUtil<JsonSerializable> {
  static final Map<PacketType, DeserializerHandler>
      _packetTypeDeserializerMapping = {
    PacketType.PING: PingClientFrame.fromJson
  };

  @override
  dynamic deserializer(Uint8List data, PacketType type) {
    Map<String, dynamic> obj = jsonDecode(utf8.decode(data));

    return _packetTypeDeserializerMapping[type]!.call(obj);
  }

  @override
  Uint8List serializer(JsonSerializable src) {
    var json = src.toJson();
    var jsonStr = jsonEncode(json);
    var bytes = utf8.encoder.convert(jsonStr);

    return bytes;
  }
}

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}
