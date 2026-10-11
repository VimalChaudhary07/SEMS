// Defines an immutable tariff record and progressive rate slabs from seed data.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tariff_record.freezed.dart';
part 'tariff_record.g.dart';

@freezed
abstract class TariffSlabRecord with _$TariffSlabRecord {
  const factory TariffSlabRecord({
    required double fromKwh,
    double? toKwh,
    required double rate,
  }) = _TariffSlabRecord;

  factory TariffSlabRecord.fromJson(Map<String, dynamic> json) =>
      _$TariffSlabRecordFromJson(json);
}

@freezed
abstract class TariffRecord with _$TariffRecord {
  const factory TariffRecord({
    required String id,
    @Default('INR') String currency,
    @Default(<TariffSlabRecord>[]) List<TariffSlabRecord> slabs,
    @Default(0) double fixedCharge,
    @Default(0) double dutyPercent,
    @Default(0) double budget,
    @Default(1) int billingDay,
  }) = _TariffRecord;

  factory TariffRecord.fromJson(Map<String, dynamic> json) =>
      _$TariffRecordFromJson(json);
}
