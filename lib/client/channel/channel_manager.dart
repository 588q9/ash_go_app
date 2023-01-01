import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ash_go/common/protocol/frame/client_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';


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