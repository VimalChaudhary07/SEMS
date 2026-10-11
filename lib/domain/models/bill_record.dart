// Defines an immutable billed or estimated energy-period record.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_record.freezed.dart';
part 'bill_record.g.dart';

@freezed
abstract class BillRecord with _$BillRecord {
  const factory BillRecord({
    required String id,
    required String period,
    required double energyKwh,
    required double amount,
    double? effectiveRate,
    @Default('billed') String status,
  }) = _BillRecord;

  factory BillRecord.fromJson(Map<String, dynamic> json) =>
      _$BillRecordFromJson(json);
}
