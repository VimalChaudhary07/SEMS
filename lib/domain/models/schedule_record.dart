// Defines an immutable local schedule, including recurring and overnight data.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_record.freezed.dart';
part 'schedule_record.g.dart';

@freezed
abstract class ScheduleRecord with _$ScheduleRecord {
  const factory ScheduleRecord({
    required String id,
    required String name,
    required String applianceId,
    required String startTime,
    required String endTime,
    String? socketId,
    String? scheduledDate,
    int? countdownMinutes,
    String? countdownEndsAt,
    @Default('idle') String countdownState,
    @Default(<String>[]) List<String> days,
    @JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals)
    @Default(<ScheduleInterval>[])
    List<ScheduleInterval> intervals,
    @Default(true) bool enabled,
    @Default('weekly') String kind,
    @Default(false) bool overnight,
    @Default('resumeAtNextInterval') String manualOverride,
  }) = _ScheduleRecord;

  factory ScheduleRecord.fromJson(Map<String, dynamic> json) =>
      _$ScheduleRecordFromJson(json);
}

List<ScheduleInterval> _decodeIntervals(List<dynamic>? values) => [
  for (final value in values ?? const [])
    ScheduleInterval.fromJson((value as Map).cast<String, dynamic>()),
];

List<Map<String, dynamic>> _encodeIntervals(List<ScheduleInterval> intervals) =>
    [for (final interval in intervals) interval.toJson()];

@freezed
abstract class ScheduleInterval with _$ScheduleInterval {
  const factory ScheduleInterval({
    required String startTime,
    required String endTime,
  }) = _ScheduleInterval;

  factory ScheduleInterval.fromJson(Map<String, dynamic> json) =>
      _$ScheduleIntervalFromJson(json);
}
