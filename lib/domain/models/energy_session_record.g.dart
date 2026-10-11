// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_session_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnergySessionRecord _$EnergySessionRecordFromJson(Map<String, dynamic> json) =>
    _EnergySessionRecord(
      id: json['id'] as String,
      applianceId: json['applianceId'] as String,
      socketId: json['socketId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      startMeterKwh: (json['startMeterKwh'] as num).toDouble(),
      currentMeterKwh: (json['currentMeterKwh'] as num).toDouble(),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
    );

Map<String, dynamic> _$EnergySessionRecordToJson(
  _EnergySessionRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'applianceId': instance.applianceId,
  'socketId': instance.socketId,
  'startedAt': instance.startedAt.toIso8601String(),
  'startMeterKwh': instance.startMeterKwh,
  'currentMeterKwh': instance.currentMeterKwh,
  'endedAt': instance.endedAt?.toIso8601String(),
};
