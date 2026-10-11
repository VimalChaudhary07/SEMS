// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'developer_identity_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeveloperIdentityRecord _$DeveloperIdentityRecordFromJson(
  Map<String, dynamic> json,
) => _DeveloperIdentityRecord(
  id: json['id'] as String,
  socketId: json['socketId'] as String,
  claimCode: json['claimCode'] as String,
  publicKey: json['publicKey'] as String,
  status: json['status'] as String? ?? 'active',
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$DeveloperIdentityRecordToJson(
  _DeveloperIdentityRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'socketId': instance.socketId,
  'claimCode': instance.claimCode,
  'publicKey': instance.publicKey,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};
