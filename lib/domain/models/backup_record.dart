// Defines immutable local backup and restore status.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'backup_record.freezed.dart';
part 'backup_record.g.dart';

@freezed
abstract class BackupRecord with _$BackupRecord {
  const factory BackupRecord({
    required String id,
    @Default(false) bool connected,
    @Default('notConnected') String state,
    @Default(0) int pendingCount,
    String? error,
    DateTime? lastSyncAt,
  }) = _BackupRecord;

  factory BackupRecord.fromJson(Map<String, dynamic> json) =>
      _$BackupRecordFromJson(json);
}
