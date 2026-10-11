// Defines an immutable local alert and its acknowledgement state.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_record.freezed.dart';
part 'alert_record.g.dart';

@freezed
abstract class AlertRecord with _$AlertRecord {
  const factory AlertRecord({
    required String id,
    required String title,
    required String message,
    required String time,
    @Default('info') String severity,
    @Default('energy') String category,
    @Default('') String device,
    @Default(false) bool acknowledged,
  }) = _AlertRecord;

  factory AlertRecord.fromJson(Map<String, dynamic> json) =>
      _$AlertRecordFromJson(json);
}
