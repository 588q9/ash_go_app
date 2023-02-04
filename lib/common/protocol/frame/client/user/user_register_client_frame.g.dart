// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_register_client_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRegisterClientFrame _$UserRegisterClientFrameFromJson(
        Map<String, dynamic> json) =>
    UserRegisterClientFrame(
      json['username'] as String,
      json['password'] as String,
    )..email = json['email'] as String?;

Map<String, dynamic> _$UserRegisterClientFrameToJson(
        UserRegisterClientFrame instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
    };
