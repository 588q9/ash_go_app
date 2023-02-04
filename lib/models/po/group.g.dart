// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as int,
      json['groupName'] as String,
      json['groupNumber'] as int,
      json['headUrl'] as String,
      json['createTime'] as int,
      json['updateTime'] as int,
      json['descriptions'] as String?,
      json['notice'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'groupName': instance.groupName,
      'groupNumber': instance.groupNumber,
      'createTime': instance.createTime,
      'descriptions': instance.descriptions,
      'notice': instance.notice,
      'headUrl': instance.headUrl,
      'updateTime': instance.updateTime,
    };
