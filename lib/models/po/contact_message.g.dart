// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactMessage _$ContactMessageFromJson(Map<String, dynamic> json) =>
    ContactMessage(
      messageId: json['messageId'] as String?,
      receiveUserId: json['receiveUserId'] as String?,
      messageClientId: json['messageClientId'] as int?,
    );

Map<String, dynamic> _$ContactMessageToJson(ContactMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'receiveUserId': instance.receiveUserId,
      'messageClientId': instance.messageClientId,
    };
