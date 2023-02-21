import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Mapper{


final Completer<Database> _openDB= Completer();
final Completer<bool> isFirstCreateDb=Completer();
Mapper(String userId) {

 _init(userId).then((value) {
 this.isFirstCreateDb.complete(value);
 });


}
Future<Database> get  mapper{
  return _openDB.future;
}

Future<bool> _init (userId)async{
  bool flag=false;
String databasePath=join(await getDatabasesPath(),"user_${userId}_database.db");

  if(!await databaseExists(databasePath)){
var dbAssets=await rootBundle.load("assets/database/ash_go_app.db");
List<int> bytes = dbAssets.buffer.asUint8List(dbAssets.offsetInBytes, dbAssets.lengthInBytes);
var dbFile=File(databasePath);
await dbFile.create(recursive: true);
(await  dbFile.writeAsBytes(bytes, flush: true));
flag=true;
  }


final database =await openDatabase(
databasePath
);
_openDB.complete(database);

return flag;
}

}