// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMessage _$GroupMessageFromJson(Map<String, dynamic> json) => GroupMessage(
      groupId: json['groupId'] as String?,
      messageId: json['messageId'] as String?,
      messageClientId: json['messageClientId'] as int?,
    );

Map<String, dynamic> _$GroupMessageToJson(GroupMessage instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'messageId': instance.messageId,
      'messageClientId': instance.messageClientId,
    };
