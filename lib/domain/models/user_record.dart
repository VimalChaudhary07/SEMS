// Defines the immutable local user model used by auth and role simulation.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_record.freezed.dart';
part 'user_record.g.dart';

@freezed
abstract class UserRecord with _$UserRecord {
  const factory UserRecord({
    required String id,
    required String name,
    required String email,
    @Default('owner') String role,
    @Default(true) bool verified,
  }) = _UserRecord;

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      _$UserRecordFromJson(json);
}
