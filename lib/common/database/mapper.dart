import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Mapper{


final Completer<Database> _openDB= Completer();
Mapper(String userId) {

_init(userId);


}
Future<Database> get  mapper{
  return _openDB.future;
}

 _init (userId)async{
String databasePath=join(await getDatabasesPath(),"user_${userId}_database.db");
print(databasePath);
  if(!await databaseExists(databasePath)){
var dbAssets=await rootBundle.load("assets/database/ash_go_app.db");
List<int> bytes = dbAssets.buffer.asUint8List(dbAssets.offsetInBytes, dbAssets.lengthInBytes);
var dbFile=File(databasePath);
await dbFile.create(recursive: true);
(await  dbFile.writeAsBytes(bytes, flush: true));
  }


final database =await openDatabase(
databasePath
);
_openDB.complete(database);


}

}