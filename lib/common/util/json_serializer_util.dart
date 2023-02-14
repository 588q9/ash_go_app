import 'dart:convert';
import 'dart:typed_data';

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/enums/serialize_type.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/exception_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/pong_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_info_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_login_server_frame.dart';
import 'package:ash_go/common/protocol/frame/server/user/user_pull_session_server_frame.dart';
import 'package:ash_go/common/util/serializer_util.dart';

typedef DeserializerHandler = Function(Map<String, dynamic> data);

class JsonSerializerUtil extends SerializerUtil<JsonSerializer> {
  static  const Map<PacketType, DeserializerHandler>
      _packetTypeDeserializerMapping ={
    PongServerFrame.PACKET_TYPE: PongServerFrame.fromJson,
    ExceptionServerFrame.PACKET_TYPE:ExceptionServerFrame.fromJson,
    UserLoginServerFrame.PACKET_TYPE:UserLoginServerFrame.fromJson,
    UserInfoServerFrame.PACKET_TYPE:UserInfoServerFrame.fromJson,
    UserPullSessionServerFrame.PACKET_TYPE:UserPullSessionServerFrame.fromJson
  };

const JsonSerializerUtil();

  @override
  ServerFrame deserializer(Uint8List data, PacketType type) {
    var jsonStr=utf8.decode(data);


    Map<String, dynamic> obj = jsonDecode(jsonStr);

    return _packetTypeDeserializerMapping[type]!.call(obj);
  }

  @override
  Uint8List serializer(JsonSerializer src) {
    var json = src.toJson();
    var jsonStr = jsonEncode(json);
    var bytes = utf8.encoder.convert(jsonStr);

    return bytes;
  }

  @override
  SerializeType getSerializeType() {
   return SerializeType.JSON_SERIAL;
  }
}

abstract class JsonSerializer {
  Map<String, dynamic> toJson();
}
