
import 'package:ash_go/client/isolate_client.dart';
import 'package:ash_go/common/protocol/enums/packet_type.dart';
import 'package:ash_go/common/util/json_serializer_util.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class Frame extends JsonSerializer{
 
PacketType getPacketType();
@JsonKey(ignore: true)
int seriesId=SeriesIdInteger.ALONE_PACKET_SERIES_ID;
}