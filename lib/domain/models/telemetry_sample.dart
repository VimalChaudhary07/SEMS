// Represents an immutable sample emitted by the local telemetry simulator.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'telemetry_sample.freezed.dart';
part 'telemetry_sample.g.dart';

@freezed
abstract class TelemetrySample with _$TelemetrySample {
  const factory TelemetrySample({
    required String id,
    @JsonKey(name: 'device_id') required String deviceId,
    required DateTime timestamp,
    required int sequence,
    required bool relay,
    @JsonKey(name: 'voltage_v') required double voltageV,
    @JsonKey(name: 'current_a') required double currentA,
    @JsonKey(name: 'power_w') required double powerW,
    @JsonKey(name: 'energy_kwh') required double energyKwh,
    @JsonKey(name: 'frequency_hz') required double frequencyHz,
    @JsonKey(name: 'power_factor') required double powerFactor,
    required String quality,
  }) = _TelemetrySample;

  factory TelemetrySample.fromJson(Map<String, dynamic> json) =>
      _$TelemetrySampleFromJson(json);
}
