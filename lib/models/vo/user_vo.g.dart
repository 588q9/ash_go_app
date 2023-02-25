// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVO _$UserVOFromJson(Map<String, dynamic> json) => UserVO(
      id: json['id'] as String?,
      username: json['username'] as String?,
      userNumber: json['userNumber'] as int?,
      headUrl: json['headUrl'] as String?,
    );

Map<String, dynamic> _$UserVOToJson(UserVO instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'userNumber': instance.userNumber,
      'headUrl': instance.headUrl,
    };
