// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pong_server_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PongServerFrame _$PongServerFrameFromJson(Map<String, dynamic> json) =>
    PongServerFrame(
      message: json['message'] as String? ?? 'pong',
    );

Map<String, dynamic> _$PongServerFrameToJson(PongServerFrame instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
