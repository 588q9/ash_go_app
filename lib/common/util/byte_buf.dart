import 'dart:typed_data';

class ByteBuf {
  int _initCapacity = 128;
  late Uint8List _content;

  late ByteData _wrap;
  int _readerIndex = 0;
  int _writerIndex = 0;
  int extendFactor = 2;
  get readerIndex {
    return _readerIndex;
  }

  get writerIndex {
    return _writerIndex;
  }

  factory ByteBuf.wrap(Uint8List data) {
    var temp = ByteBuf();
    temp._initContent(data);
    temp._writerIndex = data.length;

    return temp;
  }
  factory ByteBuf.build() {
    return ByteBuf();
  }

  ByteBuf() {
    var temp = Uint8List(this._initCapacity);

    this._initContent(temp);
  }

  ByteBuf writeBytes(Uint8List data) {
    _extendCapacity(data.length);

    List.copyRange(this._content, this.writerIndex, data);
    this._writerIndex = this.writerIndex + data.length;

    return this;
  }

  get capacity {
    return this._content.length;
  }

  void _extendCapacity(int extendLen) {
    if (extendLen <= 0) {
      return;
    } else if (extendLen < this.capacity - this.writerIndex) {
      return;
    }
    var destLen = this.writerIndex + extendLen;

    var targetLen = capacity;
    while (destLen >= targetLen) {
      targetLen = targetLen * extendFactor;
    }

    var tempData = ByteData(targetLen);
    tempData.buffer.asInt8List();

    for (int i = 0; i < this.writerIndex; i++) {
      tempData.setUint8(i, this._wrap.getUint8(i));
    }

    this._content = tempData.buffer.asUint8List();
    this._wrap = tempData;
  }

  ByteBuf writeShort(int short) {
    _extendCapacity(2);
    this._wrap.setUint16(this.writerIndex, short);
    this._writerIndex = this.writerIndex + 2;
    return this;
  }

  ByteBuf writeInt(int integer) {
    _extendCapacity(4);
    this._wrap.setUint32(this.writerIndex, integer);
    this._writerIndex = this.writerIndex + 4;
    return this;
  }

  ByteBuf writeLong(int integer) {
    _extendCapacity(8);
    this._wrap.setUint64(this.writerIndex, integer);
    this._writerIndex = this.writerIndex + 8;
    return this;
  }

  ByteBuf writeByte(int byte) {
    _extendCapacity(1);

    this._wrap.setUint8(this._writerIndex++, byte);
    return this;
  }

  void clear() {
    this._initContent(Uint8List(this._initCapacity));
    this._readerIndex = 0;
    this._writerIndex = 0;
  }

  get readableByteLength {
    return this.writerIndex - this.readerIndex;
  }

  ByteBuf compact() {
    if (readerIndex == 0) {
      return this;
    }
    int leaveByteCount = this.capacity - this.readerIndex;
    int targetLen = _initCapacity;
    while (leaveByteCount >= targetLen) {
      targetLen = targetLen * 2;
    }

    var temp = Uint8List(targetLen);
    List.copyRange(temp, 0, this._content, this.readerIndex, this.writerIndex);

    this._initContent(temp);

    this._writerIndex = this.writerIndex - this.readerIndex;
    this._readerIndex = 0;
    return this;
  }

  void _initContent(newContent) {
    this._content = newContent;
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
      dest[i] = this._content[this._readerIndex++];
    }

    return dest;
  }

  bool isReadableReading(int byteCount) {
    return this.readerIndex + byteCount <= this.writerIndex;
  }

  void _vaildReadableRead(int byteCount) {
    if (!isReadableReading(byteCount)) {
      throw RangeError('超出读取容量');
    }
  }

  int readBtye() {
    _vaildReadableRead(1);
    return this._wrap.getUint8(this._readerIndex++);
  }

  int readShort() {
    _vaildReadableRead(2);

    var res = this._wrap.getUint16(this.readerIndex);
    this._readerIndex = readerIndex + 2;
    return res;
  }

  int readLong() {
    _vaildReadableRead(8);

    var res = this._wrap.getUint32(this.readerIndex);
    this._readerIndex = readerIndex + 8;
    return res;
  }

  int readInt() {
    _vaildReadableRead(4);

    var res = this._wrap.getUint32(this.readerIndex);
    this._readerIndex = readerIndex + 4;
    return res;
  }

  Uint8List getContent() {
    return this._content;
  }

  int seekInt(int offset) {
    if (offset + 3 >= this.writerIndex) {
      throw RangeError('超出读取容量');
    }

    return _wrap.getUint32(offset);
  }
}
