// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pull_session_server_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPullSessionServerFrame _$UserPullSessionServerFrameFromJson(
        Map<String, dynamic> json) =>
    UserPullSessionServerFrame(
      SessionVO.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserPullSessionServerFrameToJson(
        UserPullSessionServerFrame instance) =>
    <String, dynamic>{
      'session': instance.session.toJson(),
    };
