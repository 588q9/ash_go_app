
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class RolePermission {


int id;
String permissionName;

RolePermission(this.id,this.permissionName);

}