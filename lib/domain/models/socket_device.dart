// Defines the immutable mock socket identity, connectivity, and live state.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_device.freezed.dart';
part 'socket_device.g.dart';

@freezed
abstract class SocketDevice with _$SocketDevice {
  const factory SocketDevice({
    required String id,
    required String name,
    @Default('') String room,
    String? applianceId,
    @Default('online') String status,
    @Default(false) bool relay,
    @Default(0) int powerW,
    @Default(0) int usualPowerW,
    @Default(0) double todayKwh,
    @Default(0) double meterKwh,
    int? signalDbm,
    @Default(0) int lastSeenMinutes,
    @Default(false) bool safetyTrip,
    String? tripReason,
    int? tripSecondsRemaining,
    String? claimCode,
  }) = _SocketDevice;

  factory SocketDevice.fromJson(Map<String, dynamic> json) =>
      _$SocketDeviceFromJson(json);
}
