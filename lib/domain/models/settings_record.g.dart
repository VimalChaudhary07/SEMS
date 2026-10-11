// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsRecord _$SettingsRecordFromJson(Map<String, dynamic> json) =>
    _SettingsRecord(
      id: json['id'] as String,
      themeMode: json['themeMode'] as String? ?? 'system',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '07:00',
      telemetryRetentionDays:
          (json['telemetryRetentionDays'] as num?)?.toInt() ?? 90,
    );

Map<String, dynamic> _$SettingsRecordToJson(_SettingsRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'themeMode': instance.themeMode,
      'notificationsEnabled': instance.notificationsEnabled,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'telemetryRetentionDays': instance.telemetryRetentionDays,
    };
