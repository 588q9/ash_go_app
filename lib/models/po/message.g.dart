// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['userId'] as String,
      json['messageType'] as int,
      json['createTime'] as int,
      json['id'] as String?,
      json['messageStatus'] as int?,
      json['clientId'] as int?,
      json['textContent'] as String?,
      json['extensionContent'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'messageType': instance.messageType,
      'createTime': instance.createTime,
      'clientId': instance.clientId,
      'messageStatus': instance.messageStatus,
      'userId': instance.userId,
      'textContent': instance.textContent,
      'extensionContent': instance.extensionContent,
    };
