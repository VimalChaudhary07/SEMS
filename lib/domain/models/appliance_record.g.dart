// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appliance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplianceRecord _$ApplianceRecordFromJson(Map<String, dynamic> json) =>
    _ApplianceRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      socketId: json['socketId'] as String?,
      room: json['room'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      lifetimeKwh: (json['lifetimeKwh'] as num?)?.toDouble() ?? 0,
      todayKwh: (json['todayKwh'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ApplianceRecordToJson(_ApplianceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'socketId': instance.socketId,
      'room': instance.room,
      'status': instance.status,
      'lifetimeKwh': instance.lifetimeKwh,
      'todayKwh': instance.todayKwh,
    };
