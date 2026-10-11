// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_member_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FamilyMemberRecord _$FamilyMemberRecordFromJson(Map<String, dynamic> json) =>
    _FamilyMemberRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String? ?? 'family',
      status: json['status'] as String? ?? 'active',
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$FamilyMemberRecordToJson(_FamilyMemberRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'permissions': instance.permissions,
    };
