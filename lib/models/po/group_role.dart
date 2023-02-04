import 'package:json_annotation/json_annotation.dart';
part 'group_role.g.dart';

@JsonSerializable(explicitToJson: true)
class GroupRole{

String id;


String roleName;
String descriptions;
GroupRole(this.id,this.roleName,this.descriptions);
  factory GroupRole.fromJson(Map<String, dynamic> json) => _$GroupRoleFromJson(json);
  Map<String, dynamic> toJson() => _$GroupRoleToJson(this);  

}