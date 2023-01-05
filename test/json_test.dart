

import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/client/ping_client_frame.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';

void main(){
var serializer=JsonSerializerUtil();
var testFrame=PingClientFrame(message: '就kid飞机偶家小');
var bytes=serializer.serializer(testFrame);
print(serializer.deserializer(bytes, PacketType.PING));

}
