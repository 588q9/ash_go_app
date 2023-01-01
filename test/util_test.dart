import 'dart:math';
import 'dart:typed_data';

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
tempData.writeBytes(byteList);
tempData.writeBytes(byteList);

var a=Uint8List(125);
tempData.takeBytesToDestArray(a,64);
print(tempData.writerIndex);
print(tempData.readerIndex);
print(a);
print('==============');



print(tempData.writerIndex);
print(tempData.readerIndex);
print('==============');
print(tempData.readInt());

print(tempData.readerIndex);



}