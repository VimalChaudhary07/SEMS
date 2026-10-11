// Defines an immutable mock Family account and its assigned permissions.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_member_record.freezed.dart';
part 'family_member_record.g.dart';

@freezed
abstract class FamilyMemberRecord with _$FamilyMemberRecord {
  const factory FamilyMemberRecord({
    required String id,
    required String name,
    required String email,
    @Default('family') String role,
    @Default('active') String status,
    @Default(<String>[]) List<String> permissions,
  }) = _FamilyMemberRecord;

  factory FamilyMemberRecord.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberRecordFromJson(json);
}
