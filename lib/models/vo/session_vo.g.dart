// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionVO _$SessionVOFromJson(Map<String, dynamic> json) => SessionVO(
      (json['userContacts'] as List<dynamic>)
          .map((e) => UserContactVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['mySendContactsMessages'] as List<dynamic>)
          .map((e) => ContactMessageVO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SessionVOToJson(SessionVO instance) => <String, dynamic>{
      'userContacts': instance.userContacts.map((e) => e.toJson()).toList(),
      'mySendContactsMessages':
          instance.mySendContactsMessages.map((e) => e.toJson()).toList(),
    };
