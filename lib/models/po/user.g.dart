// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['username'] as String,
      json['headUrl'] as String,
      json['userNumber'] as int,
      json['id'] as String,
      json['updateTime'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'headUrl': instance.headUrl,
      'userNumber': instance.userNumber,
      'updateTime': instance.updateTime,
    };
