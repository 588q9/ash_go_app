import 'dart:typed_data';

import 'package:ash_go/common/util/byte_buf.dart';

class OriginVersionLengthFieldDecoder {
  final List<ByteBuf> _bytesContainer = [];
  int _currentContainerLength = 0;
  int maxFrameLength;
  int preLengthField;
  int lengthField;
  int postLengthField;
  int _headerReaderIndex = 0;
  int _headerReaderArrayIndex = 0;
  late final int headerLength;

  OriginVersionLengthFieldDecoder(this.maxFrameLength, this.preLengthField,
      {this.lengthField = 4, required this.postLengthField}) {
    headerLength = preLengthField + lengthField + postLengthField;
  }

  void collecting(Uint8List data) {
    _bytesContainer.add(ByteBuf.wrap(data));
    _currentContainerLength = _currentContainerLength + data.length;
  }

  ByteBuf decode() {
    var headerByteArray = _bytesContainer[_headerReaderIndex];
    var packetLength = 0;
    var packetByteBuf = ByteBuf.build();
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

    var has64Byte = packetLength % 64 > 0;
    for (int i = 0; i < packetLength; i++) {
      if (has64Byte) {
        packetByteBuf.writeLong(headerByteArray.readLong());

        has64Byte = (packetLength - i - 1 - 64) % 64 > 0;
      } else {
        packetByteBuf.writeByte(headerByteArray.readBtye());
      }

      if (!headerByteArray.isReadableReading(1)) {
        _bytesContainer.removeAt(0);
        headerByteArray = _bytesContainer[_headerReaderIndex];
      }
    }

    return packetByteBuf;
  }
}
