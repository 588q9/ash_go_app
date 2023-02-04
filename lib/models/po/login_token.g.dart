// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginToken _$LoginTokenFromJson(Map<String, dynamic> json) => LoginToken(
      json['token'] as String,
      json['id'] as String?,
    );

Map<String, dynamic> _$LoginTokenToJson(LoginToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
    };
