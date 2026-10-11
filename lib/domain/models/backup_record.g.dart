// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupRecord _$BackupRecordFromJson(Map<String, dynamic> json) =>
    _BackupRecord(
      id: json['id'] as String,
      connected: json['connected'] as bool? ?? false,
      state: json['state'] as String? ?? 'notConnected',
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
    );

Map<String, dynamic> _$BackupRecordToJson(_BackupRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'connected': instance.connected,
      'state': instance.state,
      'pendingCount': instance.pendingCount,
      'error': instance.error,
      'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
    };
