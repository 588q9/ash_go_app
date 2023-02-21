// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import 'package:ash_go/models/po/user.dart';

part 'user_contacts.g.dart';

@JsonSerializable(explicitToJson: true)
class UserContacts {
  static final USER_CONTACTS_TABLE="user_contacts";

String? userId;
int? createTime;
UserContacts([this.userId,this.createTime]);

  factory UserContacts.fromJson(Map<String, dynamic> json) => _$UserContactsFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$UserContactsToJson(this);

  @override
  String toString() => 'UserContacts(userId: $userId, createTime: $createTime)';
}
