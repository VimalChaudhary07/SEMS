// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TelemetrySample _$TelemetrySampleFromJson(Map<String, dynamic> json) =>
    _TelemetrySample(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sequence: (json['sequence'] as num).toInt(),
      relay: json['relay'] as bool,
      voltageV: (json['voltage_v'] as num).toDouble(),
      currentA: (json['current_a'] as num).toDouble(),
      powerW: (json['power_w'] as num).toDouble(),
      energyKwh: (json['energy_kwh'] as num).toDouble(),
      frequencyHz: (json['frequency_hz'] as num).toDouble(),
      powerFactor: (json['power_factor'] as num).toDouble(),
      quality: json['quality'] as String,
    );

Map<String, dynamic> _$TelemetrySampleToJson(_TelemetrySample instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'timestamp': instance.timestamp.toIso8601String(),
      'sequence': instance.sequence,
      'relay': instance.relay,
      'voltage_v': instance.voltageV,
      'current_a': instance.currentA,
      'power_w': instance.powerW,
      'energy_kwh': instance.energyKwh,
      'frequency_hz': instance.frequencyHz,
      'power_factor': instance.powerFactor,
      'quality': instance.quality,
    };
