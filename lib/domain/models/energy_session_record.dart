// Defines an immutable appliance session with meter-derived energy use.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'energy_session_record.freezed.dart';
part 'energy_session_record.g.dart';

@freezed
abstract class EnergySessionRecord with _$EnergySessionRecord {
  const EnergySessionRecord._();

  const factory EnergySessionRecord({
    required String id,
    required String applianceId,
    required String socketId,
    required DateTime startedAt,
    required double startMeterKwh,
    required double currentMeterKwh,
    DateTime? endedAt,
  }) = _EnergySessionRecord;

  double get sessionKwh => currentMeterKwh - startMeterKwh;

  factory EnergySessionRecord.fromJson(Map<String, dynamic> json) =>
      _$EnergySessionRecordFromJson(json);
}
