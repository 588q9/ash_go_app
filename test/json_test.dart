

import 'dart:convert';

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';

void main(){
  test1_convert();
// var serializer=JsonSerializerUtil();
// var testFrame=PingClientFrame(message: '就kid飞机偶家小');
// var bytes=serializer.serializer(testFrame);
// print(serializer.deserializer(bytes, PacketType.PING));

}
void test1_convert(){

var map=jsonDecode('{"timestamp":1672989867092,"message":"serverfd扣到四年v哦倒是颇克萨除评委评出可破 frame"}');
print(map);
}