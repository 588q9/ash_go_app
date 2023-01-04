import 'dart:typed_data';

import 'package:ash_go/common/util/byte_buf.dart';

//注意线程不安全
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

  OriginVersionLengthFieldDecoder(this.maxPacketLength, this.preLengthField,
      {this.lengthField = 4, required this.postLengthField}) {
    headerLength = preLengthField + lengthField + postLengthField;
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
          headerByteArray = _bytesContainer[_headerReaderIndex];
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
    for (; _currentDecodePacketLength > 0;) {
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
        headerByteArray = _bytesContainer[_headerReaderIndex];
      }
    }
    _currentContainerLength = _currentContainerLength - packetLength;
    _currentDecodePacketLength = 0;
    print(resultPackets.last);
    resultPackets.add(ByteBuf());
  }
}
