// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_server_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExceptionServerFrame _$ExceptionServerFrameFromJson(
        Map<String, dynamic> json) =>
    ExceptionServerFrame(
      json['errorMessage'] as String,
      json['exceptionCode'] as int,
    );

Map<String, dynamic> _$ExceptionServerFrameToJson(
        ExceptionServerFrame instance) =>
    <String, dynamic>{
      'errorMessage': instance.errorMessage,
      'exceptionCode': instance.exceptionCode,
    };
