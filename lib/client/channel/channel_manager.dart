import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ash_go/common/protocol/frame/client_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
void main(){
ByteData data= ByteData(128);
var byteList=data.buffer.asUint8List();
data.setInt8(0, 12);
for(int a=0;a<128;a++){
data.setInt8(a, Random().nextInt(127));

}
print(byteList);
var tempData=ByteBuf();

tempData.writeBytes(byteList);
tempData.writeBytes(byteList);
tempData.writeBytes(byteList);
var a=Uint8List(125);
tempData.takeBytesToDestArray(a,125);
print(a);
tempData.takeBytesToDestArray(a,125);
print(a);
print(tempData.takeBytes());

}

class ChannelManager {


 Socket? channel;
String host="192.168.1.104";
int port=8896;
ChannelManager(){
Socket.connect(host, port).then((value) {
this.channel=value;

});


}




void send(ClientFrame frame){


  

}


}