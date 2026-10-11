// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleRecord {

 String get id; String get name; String get applianceId; String get startTime; String get endTime; String? get socketId; String? get scheduledDate; int? get countdownMinutes; String? get countdownEndsAt; String get countdownState; List<String> get days;@JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals) List<ScheduleInterval> get intervals; bool get enabled; String get kind; bool get overnight; String get manualOverride;
/// Create a copy of ScheduleRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleRecordCopyWith<ScheduleRecord> get copyWith => _$ScheduleRecordCopyWithImpl<ScheduleRecord>(this as ScheduleRecord, _$identity);

  /// Serializes this ScheduleRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.applianceId, _this.applianceId) || other.applianceId == _this.applianceId)&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime)&&(identical(other.socketId, _this.socketId) || other.socketId == _this.socketId)&&(identical(other.scheduledDate, _this.scheduledDate) || other.scheduledDate == _this.scheduledDate)&&(identical(other.countdownMinutes, _this.countdownMinutes) || other.countdownMinutes == _this.countdownMinutes)&&(identical(other.countdownEndsAt, _this.countdownEndsAt) || other.countdownEndsAt == _this.countdownEndsAt)&&(identical(other.countdownState, _this.countdownState) || other.countdownState == _this.countdownState)&&const DeepCollectionEquality().equals(other.days, _this.days)&&const DeepCollectionEquality().equals(other.intervals, _this.intervals)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.overnight, _this.overnight) || other.overnight == _this.overnight)&&(identical(other.manualOverride, _this.manualOverride) || other.manualOverride == _this.manualOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleRecord;
  return Object.hash(runtimeType,_this.id,_this.name,_this.applianceId,_this.startTime,_this.endTime,_this.socketId,_this.scheduledDate,_this.countdownMinutes,_this.countdownEndsAt,_this.countdownState,const DeepCollectionEquality().hash(_this.days),const DeepCollectionEquality().hash(_this.intervals),_this.enabled,_this.kind,_this.overnight,_this.manualOverride);
}

@override
String toString() {
  final _this = this as ScheduleRecord;
  return 'ScheduleRecord(id: ${_this.id}, name: ${_this.name}, applianceId: ${_this.applianceId}, startTime: ${_this.startTime}, endTime: ${_this.endTime}, socketId: ${_this.socketId}, scheduledDate: ${_this.scheduledDate}, countdownMinutes: ${_this.countdownMinutes}, countdownEndsAt: ${_this.countdownEndsAt}, countdownState: ${_this.countdownState}, days: ${_this.days}, intervals: ${_this.intervals}, enabled: ${_this.enabled}, kind: ${_this.kind}, overnight: ${_this.overnight}, manualOverride: ${_this.manualOverride})';
}


}

/// @nodoc
abstract mixin class $ScheduleRecordCopyWith<$Res>  {
  factory $ScheduleRecordCopyWith(ScheduleRecord value, $Res Function(ScheduleRecord) _then) = _$ScheduleRecordCopyWithImpl;
@useResult
$Res call({
 String id, String name, String applianceId, String startTime, String endTime, String? socketId, String? scheduledDate, int? countdownMinutes, String? countdownEndsAt, String countdownState, List<String> days,@JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals) List<ScheduleInterval> intervals, bool enabled, String kind, bool overnight, String manualOverride
});




}
/// @nodoc
class _$ScheduleRecordCopyWithImpl<$Res>
    implements $ScheduleRecordCopyWith<$Res> {
  _$ScheduleRecordCopyWithImpl(this._self, this._then);

  final ScheduleRecord _self;
  final $Res Function(ScheduleRecord) _then;

/// Create a copy of ScheduleRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? applianceId = null,Object? startTime = null,Object? endTime = null,Object? socketId = freezed,Object? scheduledDate = freezed,Object? countdownMinutes = freezed,Object? countdownEndsAt = freezed,Object? countdownState = null,Object? days = null,Object? intervals = null,Object? enabled = null,Object? kind = null,Object? overnight = null,Object? manualOverride = null,}) {
  return _then(ScheduleRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,applianceId: null == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,socketId: freezed == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,countdownMinutes: freezed == countdownMinutes ? _self.countdownMinutes : countdownMinutes // ignore: cast_nullable_to_non_nullable
as int?,countdownEndsAt: freezed == countdownEndsAt ? _self.countdownEndsAt : countdownEndsAt // ignore: cast_nullable_to_non_nullable
as String?,countdownState: null == countdownState ? _self.countdownState : countdownState // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<String>,intervals: null == intervals ? _self.intervals : intervals // ignore: cast_nullable_to_non_nullable
as List<ScheduleInterval>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,overnight: null == overnight ? _self.overnight : overnight // ignore: cast_nullable_to_non_nullable
as bool,manualOverride: null == manualOverride ? _self.manualOverride : manualOverride // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleRecord].
extension ScheduleRecordPatterns on ScheduleRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleRecord value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String applianceId,  String startTime,  String endTime,  String? socketId,  String? scheduledDate,  int? countdownMinutes,  String? countdownEndsAt,  String countdownState,  List<String> days, @JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals)  List<ScheduleInterval> intervals,  bool enabled,  String kind,  bool overnight,  String manualOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleRecord() when $default != null:
return $default(_that.id,_that.name,_that.applianceId,_that.startTime,_that.endTime,_that.socketId,_that.scheduledDate,_that.countdownMinutes,_that.countdownEndsAt,_that.countdownState,_that.days,_that.intervals,_that.enabled,_that.kind,_that.overnight,_that.manualOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String applianceId,  String startTime,  String endTime,  String? socketId,  String? scheduledDate,  int? countdownMinutes,  String? countdownEndsAt,  String countdownState,  List<String> days, @JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals)  List<ScheduleInterval> intervals,  bool enabled,  String kind,  bool overnight,  String manualOverride)  $default,) {final _that = this;
switch (_that) {
case _ScheduleRecord():
return $default(_that.id,_that.name,_that.applianceId,_that.startTime,_that.endTime,_that.socketId,_that.scheduledDate,_that.countdownMinutes,_that.countdownEndsAt,_that.countdownState,_that.days,_that.intervals,_that.enabled,_that.kind,_that.overnight,_that.manualOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String applianceId,  String startTime,  String endTime,  String? socketId,  String? scheduledDate,  int? countdownMinutes,  String? countdownEndsAt,  String countdownState,  List<String> days, @JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals)  List<ScheduleInterval> intervals,  bool enabled,  String kind,  bool overnight,  String manualOverride)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleRecord() when $default != null:
return $default(_that.id,_that.name,_that.applianceId,_that.startTime,_that.endTime,_that.socketId,_that.scheduledDate,_that.countdownMinutes,_that.countdownEndsAt,_that.countdownState,_that.days,_that.intervals,_that.enabled,_that.kind,_that.overnight,_that.manualOverride);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleRecord implements ScheduleRecord {
  const _ScheduleRecord({required this.id, required this.name, required this.applianceId, required this.startTime, required this.endTime, this.socketId, this.scheduledDate, this.countdownMinutes, this.countdownEndsAt, this.countdownState = 'idle',  List<String> days = const <String>[], @JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals)  List<ScheduleInterval> intervals = const <ScheduleInterval>[], this.enabled = true, this.kind = 'weekly', this.overnight = false, this.manualOverride = 'resumeAtNextInterval'}): _days = days,_intervals = intervals;
  factory _ScheduleRecord.fromJson(Map<String, dynamic> json) => _$ScheduleRecordFromJson(json);

@override final  String id;
@override final  String name;
@override final  String applianceId;
@override final  String startTime;
@override final  String endTime;
@override final  String? socketId;
@override final  String? scheduledDate;
@override final  int? countdownMinutes;
@override final  String? countdownEndsAt;
@override@JsonKey() final  String countdownState;
 final  List<String> _days;
@override@JsonKey() List<String> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}

 final  List<ScheduleInterval> _intervals;
@override@JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals) List<ScheduleInterval> get intervals {
  if (_intervals is EqualUnmodifiableListView) return _intervals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_intervals);
}

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  String kind;
@override@JsonKey() final  bool overnight;
@override@JsonKey() final  String manualOverride;

/// Create a copy of ScheduleRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleRecordCopyWith<_ScheduleRecord> get copyWith => __$ScheduleRecordCopyWithImpl<_ScheduleRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.applianceId, applianceId) || other.applianceId == applianceId)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.socketId, socketId) || other.socketId == socketId)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.countdownMinutes, countdownMinutes) || other.countdownMinutes == countdownMinutes)&&(identical(other.countdownEndsAt, countdownEndsAt) || other.countdownEndsAt == countdownEndsAt)&&(identical(other.countdownState, countdownState) || other.countdownState == countdownState)&&const DeepCollectionEquality().equals(other.days, _days)&&const DeepCollectionEquality().equals(other.intervals, _intervals)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.overnight, overnight) || other.overnight == overnight)&&(identical(other.manualOverride, manualOverride) || other.manualOverride == manualOverride));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,applianceId,startTime,endTime,socketId,scheduledDate,countdownMinutes,countdownEndsAt,countdownState,const DeepCollectionEquality().hash(_days),const DeepCollectionEquality().hash(_intervals),enabled,kind,overnight,manualOverride);
}

@override
String toString() {
    return 'ScheduleRecord(id: $id, name: $name, applianceId: $applianceId, startTime: $startTime, endTime: $endTime, socketId: $socketId, scheduledDate: $scheduledDate, countdownMinutes: $countdownMinutes, countdownEndsAt: $countdownEndsAt, countdownState: $countdownState, days: $days, intervals: $intervals, enabled: $enabled, kind: $kind, overnight: $overnight, manualOverride: $manualOverride)';
}


}

/// @nodoc
abstract mixin class _$ScheduleRecordCopyWith<$Res> implements $ScheduleRecordCopyWith<$Res> {
  factory _$ScheduleRecordCopyWith(_ScheduleRecord value, $Res Function(_ScheduleRecord) _then) = __$ScheduleRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String applianceId, String startTime, String endTime, String? socketId, String? scheduledDate, int? countdownMinutes, String? countdownEndsAt, String countdownState, List<String> days,@JsonKey(fromJson: _decodeIntervals, toJson: _encodeIntervals) List<ScheduleInterval> intervals, bool enabled, String kind, bool overnight, String manualOverride
});




}
/// @nodoc
class __$ScheduleRecordCopyWithImpl<$Res>
    implements _$ScheduleRecordCopyWith<$Res> {
  __$ScheduleRecordCopyWithImpl(this._self, this._then);

  final _ScheduleRecord _self;
  final $Res Function(_ScheduleRecord) _then;

/// Create a copy of ScheduleRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? applianceId = null,Object? startTime = null,Object? endTime = null,Object? socketId = freezed,Object? scheduledDate = freezed,Object? countdownMinutes = freezed,Object? countdownEndsAt = freezed,Object? countdownState = null,Object? days = null,Object? intervals = null,Object? enabled = null,Object? kind = null,Object? overnight = null,Object? manualOverride = null,}) {
  return _then(_ScheduleRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,applianceId: null == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,socketId: freezed == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String?,scheduledDate: freezed == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String?,countdownMinutes: freezed == countdownMinutes ? _self.countdownMinutes : countdownMinutes // ignore: cast_nullable_to_non_nullable
as int?,countdownEndsAt: freezed == countdownEndsAt ? _self.countdownEndsAt : countdownEndsAt // ignore: cast_nullable_to_non_nullable
as String?,countdownState: null == countdownState ? _self.countdownState : countdownState // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<String>,intervals: null == intervals ? _self._intervals : intervals // ignore: cast_nullable_to_non_nullable
as List<ScheduleInterval>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,overnight: null == overnight ? _self.overnight : overnight // ignore: cast_nullable_to_non_nullable
as bool,manualOverride: null == manualOverride ? _self.manualOverride : manualOverride // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ScheduleInterval {

 String get startTime; String get endTime;
/// Create a copy of ScheduleInterval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleIntervalCopyWith<ScheduleInterval> get copyWith => _$ScheduleIntervalCopyWithImpl<ScheduleInterval>(this as ScheduleInterval, _$identity);

  /// Serializes this ScheduleInterval to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScheduleInterval;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleInterval&&(identical(other.startTime, _this.startTime) || other.startTime == _this.startTime)&&(identical(other.endTime, _this.endTime) || other.endTime == _this.endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScheduleInterval;
  return Object.hash(runtimeType,_this.startTime,_this.endTime);
}

@override
String toString() {
  final _this = this as ScheduleInterval;
  return 'ScheduleInterval(startTime: ${_this.startTime}, endTime: ${_this.endTime})';
}


}

/// @nodoc
abstract mixin class $ScheduleIntervalCopyWith<$Res>  {
  factory $ScheduleIntervalCopyWith(ScheduleInterval value, $Res Function(ScheduleInterval) _then) = _$ScheduleIntervalCopyWithImpl;
@useResult
$Res call({
 String startTime, String endTime
});




}
/// @nodoc
class _$ScheduleIntervalCopyWithImpl<$Res>
    implements $ScheduleIntervalCopyWith<$Res> {
  _$ScheduleIntervalCopyWithImpl(this._self, this._then);

  final ScheduleInterval _self;
  final $Res Function(ScheduleInterval) _then;

/// Create a copy of ScheduleInterval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? endTime = null,}) {
  return _then(ScheduleInterval(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleInterval].
extension ScheduleIntervalPatterns on ScheduleInterval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleInterval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleInterval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleInterval value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleInterval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleInterval value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleInterval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String startTime,  String endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleInterval() when $default != null:
return $default(_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String startTime,  String endTime)  $default,) {final _that = this;
switch (_that) {
case _ScheduleInterval():
return $default(_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String startTime,  String endTime)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleInterval() when $default != null:
return $default(_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleInterval implements ScheduleInterval {
  const _ScheduleInterval({required this.startTime, required this.endTime});
  factory _ScheduleInterval.fromJson(Map<String, dynamic> json) => _$ScheduleIntervalFromJson(json);

@override final  String startTime;
@override final  String endTime;

/// Create a copy of ScheduleInterval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleIntervalCopyWith<_ScheduleInterval> get copyWith => __$ScheduleIntervalCopyWithImpl<_ScheduleInterval>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleIntervalToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleInterval&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,startTime,endTime);
}

@override
String toString() {
    return 'ScheduleInterval(startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$ScheduleIntervalCopyWith<$Res> implements $ScheduleIntervalCopyWith<$Res> {
  factory _$ScheduleIntervalCopyWith(_ScheduleInterval value, $Res Function(_ScheduleInterval) _then) = __$ScheduleIntervalCopyWithImpl;
@override @useResult
$Res call({
 String startTime, String endTime
});




}
/// @nodoc
class __$ScheduleIntervalCopyWithImpl<$Res>
    implements _$ScheduleIntervalCopyWith<$Res> {
  __$ScheduleIntervalCopyWithImpl(this._self, this._then);

  final _ScheduleInterval _self;
  final $Res Function(_ScheduleInterval) _then;

/// Create a copy of ScheduleInterval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? endTime = null,}) {
  return _then(_ScheduleInterval(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
