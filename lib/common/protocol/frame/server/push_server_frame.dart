import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/protocol/frame/server/server_frame.dart';

abstract class PushServerFrame extends ServerFrame{
    //默认为ALONE_PACKET_SERIES_ID，代表客户端请求。否则就是服务端推送给客户端的数据,客户端回应该数据也要设置此字段

     int pushSeriesId=  SeriesIdInteger.ALONE_PACKET_SERIES_ID;

  

}