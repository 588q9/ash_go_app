import 'dart:typed_data';

class ByteBuf {
  int _initCapacity = 128;
  late Uint8List _content;

  late ByteData _wrap;
  int readerIndex = 0;
  int writerIndex = 0;
  int extendFactor = 2;
  ByteBuf() {
    var temp = Uint8List(_initCapacity);

    this._initContent(temp);
  }

  ByteBuf writeBytes(Uint8List data) {
    _extendCapacity(data.length);

    List.copyRange(this._content, this.writerIndex, data);
    this.writerIndex = this.writerIndex + data.length ;

    return this;
  }

  get capacity {
    return this._content.length;
  }

  void _extendCapacity(int extendLen) {
    if (extendLen <= 0) {
      return;
    } else if (extendLen < this.capacity - this.writerIndex - 1) {
      return;
    }
    var destLen = this.writerIndex + 1 + extendLen;

    var targetLen = capacity;
    while (destLen >= targetLen) {
      targetLen = targetLen * extendFactor;
    }

    var tempData = ByteData(targetLen);
    tempData.buffer.asInt8List();

    for (int i = 0; i < this.writerIndex + 1; i++) {
      tempData.setUint8(i, this._wrap.getUint8(i));
    }

    this._content = tempData.buffer.asUint8List();
    this._wrap = tempData;
  }

  ByteBuf writeShort(int short) {
    _extendCapacity(2);
    this._wrap.setUint16(this.writerIndex, short);
    this.writerIndex = this.writerIndex + 2;
    return this;
  }

  ByteBuf writeInt(int integer) {
    _extendCapacity(4);
    this._wrap.setUint32(this.writerIndex, integer);
    this.writerIndex = this.writerIndex + 4;
    return this;
  }

  ByteBuf writeByte(int byte) {
    _extendCapacity(1);

    this._wrap.setInt8(this.writerIndex++, byte);
    return this;
  }

  void clear() {
    this._initContent(Uint8List(this._initCapacity));
    this.readerIndex = 0;
    this.writerIndex = 0;
  }

  get readableByteLength {
    return this.writerIndex - this.readerIndex + 1;
  }

  ByteBuf compact() {
    if (readerIndex == 0) {
      return this;
    }

    var temp = Uint8List(this.capacity - this.readerIndex - 1);
    List.copyRange(temp, 0, this._content, this.readerIndex, this.writerIndex);

    this._initContent(temp);

    this.writerIndex = this.writerIndex - this.readerIndex;
    this.readerIndex = 0;
    return this;
  }

  void _initContent(_newContent) {
    this._content = _newContent;
    this._wrap = this._content.buffer.asByteData();
  }

  Uint8List takeBytes() {
    var byteCount = this.readableByteLength;

    return this.takeBytesToDestArray(
        Uint8List(
          byteCount,
        ),
        byteCount);
  }

  Uint8List takeBytesToDestArray(Uint8List dest, int length) {
    for (int i = 0; i < length; i++) {
      dest[i] = this._content[this.readerIndex++];
    }

    return dest;
  }
}
