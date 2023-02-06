// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_server_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginServerFrame _$UserLoginServerFrameFromJson(
        Map<String, dynamic> json) =>
    UserLoginServerFrame(
      json['token'] as String,
      json['userId'] as String,
    );

Map<String, dynamic> _$UserLoginServerFrameToJson(
        UserLoginServerFrame instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
    };
