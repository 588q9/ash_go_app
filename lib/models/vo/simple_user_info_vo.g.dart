// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_user_info_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleUserInfoVO _$SimpleUserInfoVOFromJson(Map<String, dynamic> json) =>
    SimpleUserInfoVO(
      json['headUrl'] as String,
      json['userNumber'] as int,
      json['username'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$SimpleUserInfoVOToJson(SimpleUserInfoVO instance) =>
    <String, dynamic>{
      'username': instance.username,
      'userNumber': instance.userNumber,
      'headUrl': instance.headUrl,
      'id': instance.id,
    };
