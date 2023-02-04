// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) => TextMessage(
      json['userId'] as int,
      json['id'] as String?,
      json['messageType'] as int,
      json['createTime'] as int,
      json['content'] as String,
      json['messageId'] as String?,
      json['clientId'] as int?,
      json['messageClientId'] as int?,
    )..isSend = json['isSend'] as int?;

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messageType': instance.messageType,
      'createTime': instance.createTime,
      'clientId': instance.clientId,
      'isSend': instance.isSend,
      'userId': instance.userId,
      'messageId': instance.messageId,
      'content': instance.content,
      'messageClientId': instance.messageClientId,
    };
