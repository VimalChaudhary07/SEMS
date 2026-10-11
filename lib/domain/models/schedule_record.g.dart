// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleRecord _$ScheduleRecordFromJson(Map<String, dynamic> json) =>
    _ScheduleRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      applianceId: json['applianceId'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      socketId: json['socketId'] as String?,
      scheduledDate: json['scheduledDate'] as String?,
      countdownMinutes: (json['countdownMinutes'] as num?)?.toInt(),
      countdownEndsAt: json['countdownEndsAt'] as String?,
      countdownState: json['countdownState'] as String? ?? 'idle',
      days:
          (json['days'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      intervals: json['intervals'] == null
          ? const <ScheduleInterval>[]
          : _decodeIntervals(json['intervals'] as List?),
      enabled: json['enabled'] as bool? ?? true,
      kind: json['kind'] as String? ?? 'weekly',
      overnight: json['overnight'] as bool? ?? false,
      manualOverride:
          json['manualOverride'] as String? ?? 'resumeAtNextInterval',
    );

Map<String, dynamic> _$ScheduleRecordToJson(_ScheduleRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'applianceId': instance.applianceId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'socketId': instance.socketId,
      'scheduledDate': instance.scheduledDate,
      'countdownMinutes': instance.countdownMinutes,
      'countdownEndsAt': instance.countdownEndsAt,
      'countdownState': instance.countdownState,
      'days': instance.days,
      'intervals': _encodeIntervals(instance.intervals),
      'enabled': instance.enabled,
      'kind': instance.kind,
      'overnight': instance.overnight,
      'manualOverride': instance.manualOverride,
    };

_ScheduleInterval _$ScheduleIntervalFromJson(Map<String, dynamic> json) =>
    _ScheduleInterval(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$ScheduleIntervalToJson(_ScheduleInterval instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
