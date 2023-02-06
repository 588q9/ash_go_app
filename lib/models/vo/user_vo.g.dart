// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      json['email'] as String?,
      json['id'] as String?,
      json['username'] as String?,
      json['userNumber'] as int?,
      json['headUrl'] as String?,
    )..phone = json['phone'] as String?;

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'id': instance.id,
      'username': instance.username,
      'userNumber': instance.userNumber,
      'headUrl': instance.headUrl,
    };
