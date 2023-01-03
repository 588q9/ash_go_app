// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ping_client_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PingClientFrame _$PingClientFrameFromJson(Map<String, dynamic> json) =>
    PingClientFrame(
      message: json['message'] as String? ?? 'ping',
    );

Map<String, dynamic> _$PingClientFrameToJson(PingClientFrame instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
