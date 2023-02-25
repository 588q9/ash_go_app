

import 'package:intl/intl.dart';

String datestampToFormat(String format,int datestamp){
var dateTime=DateTime.fromMillisecondsSinceEpoch(datestamp);
String formattedTime =DateFormat(format).format(dateTime);
  return formattedTime;
}

