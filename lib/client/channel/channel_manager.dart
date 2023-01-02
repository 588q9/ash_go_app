import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ash_go/common/protocol/frame/client_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';

class ChannelManager {
  Socket? channel;
  String host = "192.168.1.104";

  int port = 8896;



  ChannelManager(void connected()) {
    Socket.connect(host, port).then((value) {
      channel = value;
      connected();

      return value;
    }).then((value) {
      value.listen((event) {
        _currentContainerLength = _currentContainerLength + event.length;

        _bytesContainer.add(event);


      });
    });
  }

  void send(ClientFrame frame) {}
  get isConnected {
    channel != null;
  }
}
