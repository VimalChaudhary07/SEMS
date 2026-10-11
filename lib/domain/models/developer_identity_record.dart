// Defines the immutable local identity used by the developer pairing tools.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'developer_identity_record.freezed.dart';
part 'developer_identity_record.g.dart';

@freezed
abstract class DeveloperIdentityRecord with _$DeveloperIdentityRecord {
  const factory DeveloperIdentityRecord({
    required String id,
    required String socketId,
    required String claimCode,
    required String publicKey,
    @Default('active') String status,
    required DateTime createdAt,
  }) = _DeveloperIdentityRecord;

  factory DeveloperIdentityRecord.fromJson(Map<String, dynamic> json) =>
      _$DeveloperIdentityRecordFromJson(json);
}
