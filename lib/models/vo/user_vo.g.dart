// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      json['id'] as String?,
      json['username'] as String?,
      json['userNumber'] as int?,
      json['headUrl'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userNumber': instance.userNumber,
      'headUrl': instance.headUrl,
    };
