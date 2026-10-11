// Defines the immutable mock appliance and its separated energy counters.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appliance_record.freezed.dart';
part 'appliance_record.g.dart';

@freezed
abstract class ApplianceRecord with _$ApplianceRecord {
  const factory ApplianceRecord({
    required String id,
    required String name,
    String? socketId,
    @Default('') String room,
    @Default('active') String status,
    @Default(0) double lifetimeKwh,
    @Default(0) double todayKwh,
  }) = _ApplianceRecord;

  factory ApplianceRecord.fromJson(Map<String, dynamic> json) =>
      _$ApplianceRecordFromJson(json);
}
