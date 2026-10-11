// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocketDevice {

 String get id; String get name; String get room; String? get applianceId; String get status; bool get relay; int get powerW; int get usualPowerW; double get todayKwh; double get meterKwh; int? get signalDbm; int get lastSeenMinutes; bool get safetyTrip; String? get tripReason; int? get tripSecondsRemaining; String? get claimCode;
/// Create a copy of SocketDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketDeviceCopyWith<SocketDevice> get copyWith => _$SocketDeviceCopyWithImpl<SocketDevice>(this as SocketDevice, _$identity);

  /// Serializes this SocketDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SocketDevice;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketDevice&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.applianceId, _this.applianceId) || other.applianceId == _this.applianceId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.relay, _this.relay) || other.relay == _this.relay)&&(identical(other.powerW, _this.powerW) || other.powerW == _this.powerW)&&(identical(other.usualPowerW, _this.usualPowerW) || other.usualPowerW == _this.usualPowerW)&&(identical(other.todayKwh, _this.todayKwh) || other.todayKwh == _this.todayKwh)&&(identical(other.meterKwh, _this.meterKwh) || other.meterKwh == _this.meterKwh)&&(identical(other.signalDbm, _this.signalDbm) || other.signalDbm == _this.signalDbm)&&(identical(other.lastSeenMinutes, _this.lastSeenMinutes) || other.lastSeenMinutes == _this.lastSeenMinutes)&&(identical(other.safetyTrip, _this.safetyTrip) || other.safetyTrip == _this.safetyTrip)&&(identical(other.tripReason, _this.tripReason) || other.tripReason == _this.tripReason)&&(identical(other.tripSecondsRemaining, _this.tripSecondsRemaining) || other.tripSecondsRemaining == _this.tripSecondsRemaining)&&(identical(other.claimCode, _this.claimCode) || other.claimCode == _this.claimCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SocketDevice;
  return Object.hash(runtimeType,_this.id,_this.name,_this.room,_this.applianceId,_this.status,_this.relay,_this.powerW,_this.usualPowerW,_this.todayKwh,_this.meterKwh,_this.signalDbm,_this.lastSeenMinutes,_this.safetyTrip,_this.tripReason,_this.tripSecondsRemaining,_this.claimCode);
}

@override
String toString() {
  final _this = this as SocketDevice;
  return 'SocketDevice(id: ${_this.id}, name: ${_this.name}, room: ${_this.room}, applianceId: ${_this.applianceId}, status: ${_this.status}, relay: ${_this.relay}, powerW: ${_this.powerW}, usualPowerW: ${_this.usualPowerW}, todayKwh: ${_this.todayKwh}, meterKwh: ${_this.meterKwh}, signalDbm: ${_this.signalDbm}, lastSeenMinutes: ${_this.lastSeenMinutes}, safetyTrip: ${_this.safetyTrip}, tripReason: ${_this.tripReason}, tripSecondsRemaining: ${_this.tripSecondsRemaining}, claimCode: ${_this.claimCode})';
}


}

/// @nodoc
abstract mixin class $SocketDeviceCopyWith<$Res>  {
  factory $SocketDeviceCopyWith(SocketDevice value, $Res Function(SocketDevice) _then) = _$SocketDeviceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String room, String? applianceId, String status, bool relay, int powerW, int usualPowerW, double todayKwh, double meterKwh, int? signalDbm, int lastSeenMinutes, bool safetyTrip, String? tripReason, int? tripSecondsRemaining, String? claimCode
});




}
/// @nodoc
class _$SocketDeviceCopyWithImpl<$Res>
    implements $SocketDeviceCopyWith<$Res> {
  _$SocketDeviceCopyWithImpl(this._self, this._then);

  final SocketDevice _self;
  final $Res Function(SocketDevice) _then;

/// Create a copy of SocketDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? room = null,Object? applianceId = freezed,Object? status = null,Object? relay = null,Object? powerW = null,Object? usualPowerW = null,Object? todayKwh = null,Object? meterKwh = null,Object? signalDbm = freezed,Object? lastSeenMinutes = null,Object? safetyTrip = null,Object? tripReason = freezed,Object? tripSecondsRemaining = freezed,Object? claimCode = freezed,}) {
  return _then(SocketDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,applianceId: freezed == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,relay: null == relay ? _self.relay : relay // ignore: cast_nullable_to_non_nullable
as bool,powerW: null == powerW ? _self.powerW : powerW // ignore: cast_nullable_to_non_nullable
as int,usualPowerW: null == usualPowerW ? _self.usualPowerW : usualPowerW // ignore: cast_nullable_to_non_nullable
as int,todayKwh: null == todayKwh ? _self.todayKwh : todayKwh // ignore: cast_nullable_to_non_nullable
as double,meterKwh: null == meterKwh ? _self.meterKwh : meterKwh // ignore: cast_nullable_to_non_nullable
as double,signalDbm: freezed == signalDbm ? _self.signalDbm : signalDbm // ignore: cast_nullable_to_non_nullable
as int?,lastSeenMinutes: null == lastSeenMinutes ? _self.lastSeenMinutes : lastSeenMinutes // ignore: cast_nullable_to_non_nullable
as int,safetyTrip: null == safetyTrip ? _self.safetyTrip : safetyTrip // ignore: cast_nullable_to_non_nullable
as bool,tripReason: freezed == tripReason ? _self.tripReason : tripReason // ignore: cast_nullable_to_non_nullable
as String?,tripSecondsRemaining: freezed == tripSecondsRemaining ? _self.tripSecondsRemaining : tripSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,claimCode: freezed == claimCode ? _self.claimCode : claimCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SocketDevice].
extension SocketDevicePatterns on SocketDevice {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketDevice() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketDevice value)  $default,){
final _that = this;
switch (_that) {
case _SocketDevice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketDevice value)?  $default,){
final _that = this;
switch (_that) {
case _SocketDevice() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String room,  String? applianceId,  String status,  bool relay,  int powerW,  int usualPowerW,  double todayKwh,  double meterKwh,  int? signalDbm,  int lastSeenMinutes,  bool safetyTrip,  String? tripReason,  int? tripSecondsRemaining,  String? claimCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketDevice() when $default != null:
return $default(_that.id,_that.name,_that.room,_that.applianceId,_that.status,_that.relay,_that.powerW,_that.usualPowerW,_that.todayKwh,_that.meterKwh,_that.signalDbm,_that.lastSeenMinutes,_that.safetyTrip,_that.tripReason,_that.tripSecondsRemaining,_that.claimCode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String room,  String? applianceId,  String status,  bool relay,  int powerW,  int usualPowerW,  double todayKwh,  double meterKwh,  int? signalDbm,  int lastSeenMinutes,  bool safetyTrip,  String? tripReason,  int? tripSecondsRemaining,  String? claimCode)  $default,) {final _that = this;
switch (_that) {
case _SocketDevice():
return $default(_that.id,_that.name,_that.room,_that.applianceId,_that.status,_that.relay,_that.powerW,_that.usualPowerW,_that.todayKwh,_that.meterKwh,_that.signalDbm,_that.lastSeenMinutes,_that.safetyTrip,_that.tripReason,_that.tripSecondsRemaining,_that.claimCode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String room,  String? applianceId,  String status,  bool relay,  int powerW,  int usualPowerW,  double todayKwh,  double meterKwh,  int? signalDbm,  int lastSeenMinutes,  bool safetyTrip,  String? tripReason,  int? tripSecondsRemaining,  String? claimCode)?  $default,) {final _that = this;
switch (_that) {
case _SocketDevice() when $default != null:
return $default(_that.id,_that.name,_that.room,_that.applianceId,_that.status,_that.relay,_that.powerW,_that.usualPowerW,_that.todayKwh,_that.meterKwh,_that.signalDbm,_that.lastSeenMinutes,_that.safetyTrip,_that.tripReason,_that.tripSecondsRemaining,_that.claimCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketDevice implements SocketDevice {
  const _SocketDevice({required this.id, required this.name, this.room = '', this.applianceId, this.status = 'online', this.relay = false, this.powerW = 0, this.usualPowerW = 0, this.todayKwh = 0, this.meterKwh = 0, this.signalDbm, this.lastSeenMinutes = 0, this.safetyTrip = false, this.tripReason, this.tripSecondsRemaining, this.claimCode});
  factory _SocketDevice.fromJson(Map<String, dynamic> json) => _$SocketDeviceFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String room;
@override final  String? applianceId;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool relay;
@override@JsonKey() final  int powerW;
@override@JsonKey() final  int usualPowerW;
@override@JsonKey() final  double todayKwh;
@override@JsonKey() final  double meterKwh;
@override final  int? signalDbm;
@override@JsonKey() final  int lastSeenMinutes;
@override@JsonKey() final  bool safetyTrip;
@override final  String? tripReason;
@override final  int? tripSecondsRemaining;
@override final  String? claimCode;

/// Create a copy of SocketDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketDeviceCopyWith<_SocketDevice> get copyWith => __$SocketDeviceCopyWithImpl<_SocketDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.room, room) || other.room == room)&&(identical(other.applianceId, applianceId) || other.applianceId == applianceId)&&(identical(other.status, status) || other.status == status)&&(identical(other.relay, relay) || other.relay == relay)&&(identical(other.powerW, powerW) || other.powerW == powerW)&&(identical(other.usualPowerW, usualPowerW) || other.usualPowerW == usualPowerW)&&(identical(other.todayKwh, todayKwh) || other.todayKwh == todayKwh)&&(identical(other.meterKwh, meterKwh) || other.meterKwh == meterKwh)&&(identical(other.signalDbm, signalDbm) || other.signalDbm == signalDbm)&&(identical(other.lastSeenMinutes, lastSeenMinutes) || other.lastSeenMinutes == lastSeenMinutes)&&(identical(other.safetyTrip, safetyTrip) || other.safetyTrip == safetyTrip)&&(identical(other.tripReason, tripReason) || other.tripReason == tripReason)&&(identical(other.tripSecondsRemaining, tripSecondsRemaining) || other.tripSecondsRemaining == tripSecondsRemaining)&&(identical(other.claimCode, claimCode) || other.claimCode == claimCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,room,applianceId,status,relay,powerW,usualPowerW,todayKwh,meterKwh,signalDbm,lastSeenMinutes,safetyTrip,tripReason,tripSecondsRemaining,claimCode);
}

@override
String toString() {
    return 'SocketDevice(id: $id, name: $name, room: $room, applianceId: $applianceId, status: $status, relay: $relay, powerW: $powerW, usualPowerW: $usualPowerW, todayKwh: $todayKwh, meterKwh: $meterKwh, signalDbm: $signalDbm, lastSeenMinutes: $lastSeenMinutes, safetyTrip: $safetyTrip, tripReason: $tripReason, tripSecondsRemaining: $tripSecondsRemaining, claimCode: $claimCode)';
}


}

/// @nodoc
abstract mixin class _$SocketDeviceCopyWith<$Res> implements $SocketDeviceCopyWith<$Res> {
  factory _$SocketDeviceCopyWith(_SocketDevice value, $Res Function(_SocketDevice) _then) = __$SocketDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String room, String? applianceId, String status, bool relay, int powerW, int usualPowerW, double todayKwh, double meterKwh, int? signalDbm, int lastSeenMinutes, bool safetyTrip, String? tripReason, int? tripSecondsRemaining, String? claimCode
});




}
/// @nodoc
class __$SocketDeviceCopyWithImpl<$Res>
    implements _$SocketDeviceCopyWith<$Res> {
  __$SocketDeviceCopyWithImpl(this._self, this._then);

  final _SocketDevice _self;
  final $Res Function(_SocketDevice) _then;

/// Create a copy of SocketDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? room = null,Object? applianceId = freezed,Object? status = null,Object? relay = null,Object? powerW = null,Object? usualPowerW = null,Object? todayKwh = null,Object? meterKwh = null,Object? signalDbm = freezed,Object? lastSeenMinutes = null,Object? safetyTrip = null,Object? tripReason = freezed,Object? tripSecondsRemaining = freezed,Object? claimCode = freezed,}) {
  return _then(_SocketDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,applianceId: freezed == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,relay: null == relay ? _self.relay : relay // ignore: cast_nullable_to_non_nullable
as bool,powerW: null == powerW ? _self.powerW : powerW // ignore: cast_nullable_to_non_nullable
as int,usualPowerW: null == usualPowerW ? _self.usualPowerW : usualPowerW // ignore: cast_nullable_to_non_nullable
as int,todayKwh: null == todayKwh ? _self.todayKwh : todayKwh // ignore: cast_nullable_to_non_nullable
as double,meterKwh: null == meterKwh ? _self.meterKwh : meterKwh // ignore: cast_nullable_to_non_nullable
as double,signalDbm: freezed == signalDbm ? _self.signalDbm : signalDbm // ignore: cast_nullable_to_non_nullable
as int?,lastSeenMinutes: null == lastSeenMinutes ? _self.lastSeenMinutes : lastSeenMinutes // ignore: cast_nullable_to_non_nullable
as int,safetyTrip: null == safetyTrip ? _self.safetyTrip : safetyTrip // ignore: cast_nullable_to_non_nullable
as bool,tripReason: freezed == tripReason ? _self.tripReason : tripReason // ignore: cast_nullable_to_non_nullable
as String?,tripSecondsRemaining: freezed == tripSecondsRemaining ? _self.tripSecondsRemaining : tripSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,claimCode: freezed == claimCode ? _self.claimCode : claimCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
