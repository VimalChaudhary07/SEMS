// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRecord _$UserRecordFromJson(Map<String, dynamic> json) => _UserRecord(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String? ?? 'owner',
  verified: json['verified'] as bool? ?? true,
);

Map<String, dynamic> _$UserRecordToJson(_UserRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'verified': instance.verified,
    };
