// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SocketDevice _$SocketDeviceFromJson(Map<String, dynamic> json) =>
    _SocketDevice(
      id: json['id'] as String,
      name: json['name'] as String,
      room: json['room'] as String? ?? '',
      applianceId: json['applianceId'] as String?,
      status: json['status'] as String? ?? 'online',
      relay: json['relay'] as bool? ?? false,
      powerW: (json['powerW'] as num?)?.toInt() ?? 0,
      usualPowerW: (json['usualPowerW'] as num?)?.toInt() ?? 0,
      todayKwh: (json['todayKwh'] as num?)?.toDouble() ?? 0,
      meterKwh: (json['meterKwh'] as num?)?.toDouble() ?? 0,
      signalDbm: (json['signalDbm'] as num?)?.toInt(),
      lastSeenMinutes: (json['lastSeenMinutes'] as num?)?.toInt() ?? 0,
      safetyTrip: json['safetyTrip'] as bool? ?? false,
      tripReason: json['tripReason'] as String?,
      tripSecondsRemaining: (json['tripSecondsRemaining'] as num?)?.toInt(),
      claimCode: json['claimCode'] as String?,
    );

Map<String, dynamic> _$SocketDeviceToJson(_SocketDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'room': instance.room,
      'applianceId': instance.applianceId,
      'status': instance.status,
      'relay': instance.relay,
      'powerW': instance.powerW,
      'usualPowerW': instance.usualPowerW,
      'todayKwh': instance.todayKwh,
      'meterKwh': instance.meterKwh,
      'signalDbm': instance.signalDbm,
      'lastSeenMinutes': instance.lastSeenMinutes,
      'safetyTrip': instance.safetyTrip,
      'tripReason': instance.tripReason,
      'tripSecondsRemaining': instance.tripSecondsRemaining,
      'claimCode': instance.claimCode,
    };
