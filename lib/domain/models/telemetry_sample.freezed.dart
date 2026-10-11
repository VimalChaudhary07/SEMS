// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telemetry_sample.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TelemetrySample {

 String get id;@JsonKey(name: 'device_id') String get deviceId; DateTime get timestamp; int get sequence; bool get relay;@JsonKey(name: 'voltage_v') double get voltageV;@JsonKey(name: 'current_a') double get currentA;@JsonKey(name: 'power_w') double get powerW;@JsonKey(name: 'energy_kwh') double get energyKwh;@JsonKey(name: 'frequency_hz') double get frequencyHz;@JsonKey(name: 'power_factor') double get powerFactor; String get quality;
/// Create a copy of TelemetrySample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelemetrySampleCopyWith<TelemetrySample> get copyWith => _$TelemetrySampleCopyWithImpl<TelemetrySample>(this as TelemetrySample, _$identity);

  /// Serializes this TelemetrySample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TelemetrySample;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelemetrySample&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.timestamp, _this.timestamp) || other.timestamp == _this.timestamp)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.relay, _this.relay) || other.relay == _this.relay)&&(identical(other.voltageV, _this.voltageV) || other.voltageV == _this.voltageV)&&(identical(other.currentA, _this.currentA) || other.currentA == _this.currentA)&&(identical(other.powerW, _this.powerW) || other.powerW == _this.powerW)&&(identical(other.energyKwh, _this.energyKwh) || other.energyKwh == _this.energyKwh)&&(identical(other.frequencyHz, _this.frequencyHz) || other.frequencyHz == _this.frequencyHz)&&(identical(other.powerFactor, _this.powerFactor) || other.powerFactor == _this.powerFactor)&&(identical(other.quality, _this.quality) || other.quality == _this.quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TelemetrySample;
  return Object.hash(runtimeType,_this.id,_this.deviceId,_this.timestamp,_this.sequence,_this.relay,_this.voltageV,_this.currentA,_this.powerW,_this.energyKwh,_this.frequencyHz,_this.powerFactor,_this.quality);
}

@override
String toString() {
  final _this = this as TelemetrySample;
  return 'TelemetrySample(id: ${_this.id}, deviceId: ${_this.deviceId}, timestamp: ${_this.timestamp}, sequence: ${_this.sequence}, relay: ${_this.relay}, voltageV: ${_this.voltageV}, currentA: ${_this.currentA}, powerW: ${_this.powerW}, energyKwh: ${_this.energyKwh}, frequencyHz: ${_this.frequencyHz}, powerFactor: ${_this.powerFactor}, quality: ${_this.quality})';
}


}

/// @nodoc
abstract mixin class $TelemetrySampleCopyWith<$Res>  {
  factory $TelemetrySampleCopyWith(TelemetrySample value, $Res Function(TelemetrySample) _then) = _$TelemetrySampleCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId, DateTime timestamp, int sequence, bool relay,@JsonKey(name: 'voltage_v') double voltageV,@JsonKey(name: 'current_a') double currentA,@JsonKey(name: 'power_w') double powerW,@JsonKey(name: 'energy_kwh') double energyKwh,@JsonKey(name: 'frequency_hz') double frequencyHz,@JsonKey(name: 'power_factor') double powerFactor, String quality
});




}
/// @nodoc
class _$TelemetrySampleCopyWithImpl<$Res>
    implements $TelemetrySampleCopyWith<$Res> {
  _$TelemetrySampleCopyWithImpl(this._self, this._then);

  final TelemetrySample _self;
  final $Res Function(TelemetrySample) _then;

/// Create a copy of TelemetrySample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deviceId = null,Object? timestamp = null,Object? sequence = null,Object? relay = null,Object? voltageV = null,Object? currentA = null,Object? powerW = null,Object? energyKwh = null,Object? frequencyHz = null,Object? powerFactor = null,Object? quality = null,}) {
  return _then(TelemetrySample(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,relay: null == relay ? _self.relay : relay // ignore: cast_nullable_to_non_nullable
as bool,voltageV: null == voltageV ? _self.voltageV : voltageV // ignore: cast_nullable_to_non_nullable
as double,currentA: null == currentA ? _self.currentA : currentA // ignore: cast_nullable_to_non_nullable
as double,powerW: null == powerW ? _self.powerW : powerW // ignore: cast_nullable_to_non_nullable
as double,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,frequencyHz: null == frequencyHz ? _self.frequencyHz : frequencyHz // ignore: cast_nullable_to_non_nullable
as double,powerFactor: null == powerFactor ? _self.powerFactor : powerFactor // ignore: cast_nullable_to_non_nullable
as double,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TelemetrySample].
extension TelemetrySamplePatterns on TelemetrySample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelemetrySample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelemetrySample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelemetrySample value)  $default,){
final _that = this;
switch (_that) {
case _TelemetrySample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelemetrySample value)?  $default,){
final _that = this;
switch (_that) {
case _TelemetrySample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId,  DateTime timestamp,  int sequence,  bool relay, @JsonKey(name: 'voltage_v')  double voltageV, @JsonKey(name: 'current_a')  double currentA, @JsonKey(name: 'power_w')  double powerW, @JsonKey(name: 'energy_kwh')  double energyKwh, @JsonKey(name: 'frequency_hz')  double frequencyHz, @JsonKey(name: 'power_factor')  double powerFactor,  String quality)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelemetrySample() when $default != null:
return $default(_that.id,_that.deviceId,_that.timestamp,_that.sequence,_that.relay,_that.voltageV,_that.currentA,_that.powerW,_that.energyKwh,_that.frequencyHz,_that.powerFactor,_that.quality);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'device_id')  String deviceId,  DateTime timestamp,  int sequence,  bool relay, @JsonKey(name: 'voltage_v')  double voltageV, @JsonKey(name: 'current_a')  double currentA, @JsonKey(name: 'power_w')  double powerW, @JsonKey(name: 'energy_kwh')  double energyKwh, @JsonKey(name: 'frequency_hz')  double frequencyHz, @JsonKey(name: 'power_factor')  double powerFactor,  String quality)  $default,) {final _that = this;
switch (_that) {
case _TelemetrySample():
return $default(_that.id,_that.deviceId,_that.timestamp,_that.sequence,_that.relay,_that.voltageV,_that.currentA,_that.powerW,_that.energyKwh,_that.frequencyHz,_that.powerFactor,_that.quality);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'device_id')  String deviceId,  DateTime timestamp,  int sequence,  bool relay, @JsonKey(name: 'voltage_v')  double voltageV, @JsonKey(name: 'current_a')  double currentA, @JsonKey(name: 'power_w')  double powerW, @JsonKey(name: 'energy_kwh')  double energyKwh, @JsonKey(name: 'frequency_hz')  double frequencyHz, @JsonKey(name: 'power_factor')  double powerFactor,  String quality)?  $default,) {final _that = this;
switch (_that) {
case _TelemetrySample() when $default != null:
return $default(_that.id,_that.deviceId,_that.timestamp,_that.sequence,_that.relay,_that.voltageV,_that.currentA,_that.powerW,_that.energyKwh,_that.frequencyHz,_that.powerFactor,_that.quality);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TelemetrySample implements TelemetrySample {
  const _TelemetrySample({required this.id, @JsonKey(name: 'device_id') required this.deviceId, required this.timestamp, required this.sequence, required this.relay, @JsonKey(name: 'voltage_v') required this.voltageV, @JsonKey(name: 'current_a') required this.currentA, @JsonKey(name: 'power_w') required this.powerW, @JsonKey(name: 'energy_kwh') required this.energyKwh, @JsonKey(name: 'frequency_hz') required this.frequencyHz, @JsonKey(name: 'power_factor') required this.powerFactor, required this.quality});
  factory _TelemetrySample.fromJson(Map<String, dynamic> json) => _$TelemetrySampleFromJson(json);

@override final  String id;
@override@JsonKey(name: 'device_id') final  String deviceId;
@override final  DateTime timestamp;
@override final  int sequence;
@override final  bool relay;
@override@JsonKey(name: 'voltage_v') final  double voltageV;
@override@JsonKey(name: 'current_a') final  double currentA;
@override@JsonKey(name: 'power_w') final  double powerW;
@override@JsonKey(name: 'energy_kwh') final  double energyKwh;
@override@JsonKey(name: 'frequency_hz') final  double frequencyHz;
@override@JsonKey(name: 'power_factor') final  double powerFactor;
@override final  String quality;

/// Create a copy of TelemetrySample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelemetrySampleCopyWith<_TelemetrySample> get copyWith => __$TelemetrySampleCopyWithImpl<_TelemetrySample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TelemetrySampleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelemetrySample&&(identical(other.id, id) || other.id == id)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.relay, relay) || other.relay == relay)&&(identical(other.voltageV, voltageV) || other.voltageV == voltageV)&&(identical(other.currentA, currentA) || other.currentA == currentA)&&(identical(other.powerW, powerW) || other.powerW == powerW)&&(identical(other.energyKwh, energyKwh) || other.energyKwh == energyKwh)&&(identical(other.frequencyHz, frequencyHz) || other.frequencyHz == frequencyHz)&&(identical(other.powerFactor, powerFactor) || other.powerFactor == powerFactor)&&(identical(other.quality, quality) || other.quality == quality));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,deviceId,timestamp,sequence,relay,voltageV,currentA,powerW,energyKwh,frequencyHz,powerFactor,quality);
}

@override
String toString() {
    return 'TelemetrySample(id: $id, deviceId: $deviceId, timestamp: $timestamp, sequence: $sequence, relay: $relay, voltageV: $voltageV, currentA: $currentA, powerW: $powerW, energyKwh: $energyKwh, frequencyHz: $frequencyHz, powerFactor: $powerFactor, quality: $quality)';
}


}

/// @nodoc
abstract mixin class _$TelemetrySampleCopyWith<$Res> implements $TelemetrySampleCopyWith<$Res> {
  factory _$TelemetrySampleCopyWith(_TelemetrySample value, $Res Function(_TelemetrySample) _then) = __$TelemetrySampleCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'device_id') String deviceId, DateTime timestamp, int sequence, bool relay,@JsonKey(name: 'voltage_v') double voltageV,@JsonKey(name: 'current_a') double currentA,@JsonKey(name: 'power_w') double powerW,@JsonKey(name: 'energy_kwh') double energyKwh,@JsonKey(name: 'frequency_hz') double frequencyHz,@JsonKey(name: 'power_factor') double powerFactor, String quality
});




}
/// @nodoc
class __$TelemetrySampleCopyWithImpl<$Res>
    implements _$TelemetrySampleCopyWith<$Res> {
  __$TelemetrySampleCopyWithImpl(this._self, this._then);

  final _TelemetrySample _self;
  final $Res Function(_TelemetrySample) _then;

/// Create a copy of TelemetrySample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deviceId = null,Object? timestamp = null,Object? sequence = null,Object? relay = null,Object? voltageV = null,Object? currentA = null,Object? powerW = null,Object? energyKwh = null,Object? frequencyHz = null,Object? powerFactor = null,Object? quality = null,}) {
  return _then(_TelemetrySample(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,relay: null == relay ? _self.relay : relay // ignore: cast_nullable_to_non_nullable
as bool,voltageV: null == voltageV ? _self.voltageV : voltageV // ignore: cast_nullable_to_non_nullable
as double,currentA: null == currentA ? _self.currentA : currentA // ignore: cast_nullable_to_non_nullable
as double,powerW: null == powerW ? _self.powerW : powerW // ignore: cast_nullable_to_non_nullable
as double,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,frequencyHz: null == frequencyHz ? _self.frequencyHz : frequencyHz // ignore: cast_nullable_to_non_nullable
as double,powerFactor: null == powerFactor ? _self.powerFactor : powerFactor // ignore: cast_nullable_to_non_nullable
as double,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
