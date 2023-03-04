import 'dart:convert';
import 'dart:typed_data';

import 'package:ash_go/common/util/byte_buf.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';

typedef PacketCallback = void Function(ByteBuf packet);

//注意线程不安全
//TODO 将Packet和Frame的封装行为抽取出来
class OriginVersionLengthFieldDecoder {
  final List<ByteBuf> _bytesContainer = [];
  int _currentContainerLength = 0;
  final int maxPacketLength;
  final int preLengthField;
  final int lengthField;
  final int postLengthField;
  int _headerReaderIndex = 0;
  int _headerReaderArrayIndex = 0;
  int _currentDecodePacketLength = 0;
  List<ByteBuf> resultPackets = [ByteBuf()];

  late final int headerLength;
  late PacketCallback _packetProcess;
  OriginVersionLengthFieldDecoder(this.maxPacketLength, this.preLengthField,
      {this.lengthField = 4, required this.postLengthField}) {
    headerLength = preLengthField + lengthField + postLengthField;
    packetProcess = (packet) {
      var tempBytes = packet.takeBytes();

      tempBytes = Uint8List.sublistView(tempBytes, headerLength);
      // print(tempBytes);

      String jsonStr = utf8.decode(tempBytes);
      // print(jsonStr);
    };
  }

  set packetProcess(PacketCallback packetCallback) {
    _packetProcess = packetCallback;
  }

  void collecting(Uint8List data) {
    _bytesContainer.add(ByteBuf.wrap(data));
    _currentContainerLength = _currentContainerLength + data.length;
    this._decode();
  }

  void _decode() {
    var headerByteArray = _bytesContainer[_headerReaderIndex];
    var packetByteBuf = resultPackets[resultPackets.length - 1];
    if (_currentDecodePacketLength == 0) {
      if (_currentContainerLength < headerLength) {
        return;
      }

      var packetLength = 0;
      var tempHeaderIndex = 0;
      while (tempHeaderIndex < headerLength) {
        packetByteBuf.writeByte(headerByteArray.readBtye());
        if (!headerByteArray.isReadableReading(1)) {
          _bytesContainer.removeAt(0);
          if (_bytesContainer.isNotEmpty) {
            headerByteArray = _bytesContainer[_headerReaderIndex];
          }
        }

        tempHeaderIndex++;
      }
      _currentContainerLength = _currentContainerLength - headerLength;
      packetLength = packetByteBuf.seekInt(preLengthField);
      _currentDecodePacketLength = packetLength;
    }

    if (_currentContainerLength < _currentDecodePacketLength) {
      return;
    }

    var packetLength = _currentDecodePacketLength;
    var has8Byte = (_currentDecodePacketLength / 8).floor() > 0 &&
        headerByteArray.isReadableReading(8);
    for (; packetLength > 0;) {
      if (has8Byte) {
        packetByteBuf.writeLong(headerByteArray.readLong());
        packetLength = packetLength - 8;

        has8Byte = ((packetLength) / 8).floor() > 0 &&
            headerByteArray.isReadableReading(8);
      } else {
        packetByteBuf.writeByte(headerByteArray.readBtye());
        packetLength = packetLength - 1;
      }

      if (!headerByteArray.isReadableReading(1)) {
        _bytesContainer.removeAt(0);
        if (_bytesContainer.isNotEmpty) {
          headerByteArray = _bytesContainer[_headerReaderIndex];
        }
      }
    }
    _currentContainerLength =
        _currentContainerLength - _currentDecodePacketLength;

    _currentDecodePacketLength = 0;

    _buildedPacket(resultPackets[resultPackets.length - 1]);
    resultPackets.removeAt(0);
    resultPackets.add(ByteBuf());

    if (_currentContainerLength >= headerLength) {
      _decode();
    }
  }

  void _buildedPacket(ByteBuf res) {
    _packetProcess.call(res);
  }
}
