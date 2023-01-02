import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:ash_go/client/packet/origin_version_packet.dart';
import 'package:ash_go/client/packet/packet.dart';
import 'package:ash_go/common/protocol/frame/client_frame.dart';
import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/common/util/origin_version_length_field_decoder.dart';

class ChannelManager {
  Socket? channel;
  String host = "192.168.1.104";
  OriginVersionLengthFieldDecoder lengthFieldDecoder =
      OriginVersionLengthFieldDecoder(
          0x7fffffff,
          Packet.MAGIC_NUMBER +
              Packet.VERSION_FIELD_LENGTH +
              OriginVersionPacket.TYPE_FIELD_LENGTH,
          lengthField: OriginVersionPacket.LENGTH_FIELD_LENGTH,
          postLengthField: OriginVersionPacket.SERIES_ID_FIELD_LENGTH +
              OriginVersionPacket.SERIALIZE_TYPE_FIELD_LENGTH);
  int port = 8896;

  ChannelManager(void connected()) {
    Socket.connect(host, port).then((value) {
      channel = value;
      connected();

      return value;
    }).then((value) {
      value.listen((event) {
      lengthFieldDecoder.collecting(event);
      
      });
    });
  }

  void send(ClientFrame frame) {}
  get isConnected {
    channel != null;
  }
}
