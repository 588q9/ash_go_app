// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_contact_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserContactVO _$UserContactVOFromJson(Map<String, dynamic> json) =>
    UserContactVO(
      (json['sendToUserMessages'] as List<dynamic>)
          .map((e) => ContactMessageVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['headUrl'] as String,
      json['userNumber'] as int,
      json['username'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$UserContactVOToJson(UserContactVO instance) =>
    <String, dynamic>{
      'username': instance.username,
      'userNumber': instance.userNumber,
      'headUrl': instance.headUrl,
      'id': instance.id,
      'sendToUserMessages':
          instance.sendToUserMessages.map((e) => e.toJson()).toList(),
    };
