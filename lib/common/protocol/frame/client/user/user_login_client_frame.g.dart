// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_client_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginClientFrame _$UserLoginClientFrameFromJson(
        Map<String, dynamic> json) =>
    UserLoginClientFrame(
      userIdenity: json['userIdenity'] as String?,
      token: json['token'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$UserLoginClientFrameToJson(
        UserLoginClientFrame instance) =>
    <String, dynamic>{
      'userIdenity': instance.userIdenity,
      'password': instance.password,
      'token': instance.token,
    };
