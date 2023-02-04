
import 'dart:io';

import 'package:ash_go/models/po/group_role.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  const Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

first_sqlite()async{

var dbAssets=await rootBundle.load("assets/database/ash_go_app.db");
String databasePath=join(await getDatabasesPath(),"inner_database.db");
List<int> bytes = dbAssets.buffer.asUint8List(dbAssets.offsetInBytes, dbAssets.lengthInBytes);
(await  File(databasePath).writeAsBytes(bytes, flush: true));

final database =await openDatabase(
databasePath
);

 
var groupRole=GroupRole('111', 'admin', '管理');
await database.insert('group_role', groupRole.toJson());
var list=await database.query('group_role',where: 'id=111');
print(list);

}