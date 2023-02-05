// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_server_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoServerFrame _$UserInfoServerFrameFromJson(Map<String, dynamic> json) =>
    UserInfoServerFrame(
      UserVO.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInfoServerFrameToJson(
        UserInfoServerFrame instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };
