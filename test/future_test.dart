import 'dart:async';

void main(){
  async_test();
timer_test();

}
future_test(){
var completer=Completer();
var future=completer.future.then((value) {print('dxjaoxdjapoxdka');

return value;});
future.then((value) {
print('$value weww');


});

print("999");

// completer.complete('wwb');

}
async_test () async{
print('async');
}
timer_test(){
  print('sss');
 int num = 0;
  // 实例化Duration类 设置定时器持续时间 毫秒
  var timeout = new Duration(milliseconds: 1000);


  // 持续调用多次 每次1秒后执行
var  myTimer = Timer.periodic(timeout, (timer) {
    num++;
    print(num); // 会每隔一秒打印一次 自增的数
    if (num == 10) {
      // 清除定时器
      timer.cancel();
      // 初始化
      
    }
  });

}