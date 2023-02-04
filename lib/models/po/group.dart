import 'package:json_annotation/json_annotation.dart';
part 'group.g.dart';

@JsonSerializable(explicitToJson: true)

class Group {
  int id;
  String groupName;
  int groupNumber;
  int createTime;
  String? descriptions;
String? notice;
  String headUrl;
  int updateTime;
  Group(this.id, this.groupName, this.groupNumber,this.headUrl,this.createTime,
  this.updateTime,
      [ this.descriptions, this.notice]);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);  

}
