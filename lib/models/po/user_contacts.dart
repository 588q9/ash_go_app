// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import 'package:ash_go/models/po/user.dart';

part 'user_contacts.g.dart';

@JsonSerializable(explicitToJson: true)
class UserContacts {

String? userId;
int? createTime;
UserContacts([this.userId,this.createTime]);


  @override
  String toString() => 'UserContacts(userId: $userId, createTime: $createTime)';
}
