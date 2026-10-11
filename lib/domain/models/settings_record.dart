// Defines immutable local app and notification preferences.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_record.freezed.dart';
part 'settings_record.g.dart';

@freezed
abstract class SettingsRecord with _$SettingsRecord {
  const factory SettingsRecord({
    required String id,
    @Default('system') String themeMode,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool quietHoursEnabled,
    @Default('22:00') String quietHoursStart,
    @Default('07:00') String quietHoursEnd,
    @Default(90) int telemetryRetentionDays,
  }) = _SettingsRecord;

  factory SettingsRecord.fromJson(Map<String, dynamic> json) =>
      _$SettingsRecordFromJson(json);
}
