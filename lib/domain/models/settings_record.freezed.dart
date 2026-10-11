// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsRecord {

 String get id; String get themeMode; bool get notificationsEnabled; bool get quietHoursEnabled; String get quietHoursStart; String get quietHoursEnd; int get telemetryRetentionDays;
/// Create a copy of SettingsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsRecordCopyWith<SettingsRecord> get copyWith => _$SettingsRecordCopyWithImpl<SettingsRecord>(this as SettingsRecord, _$identity);

  /// Serializes this SettingsRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SettingsRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.themeMode, _this.themeMode) || other.themeMode == _this.themeMode)&&(identical(other.notificationsEnabled, _this.notificationsEnabled) || other.notificationsEnabled == _this.notificationsEnabled)&&(identical(other.quietHoursEnabled, _this.quietHoursEnabled) || other.quietHoursEnabled == _this.quietHoursEnabled)&&(identical(other.quietHoursStart, _this.quietHoursStart) || other.quietHoursStart == _this.quietHoursStart)&&(identical(other.quietHoursEnd, _this.quietHoursEnd) || other.quietHoursEnd == _this.quietHoursEnd)&&(identical(other.telemetryRetentionDays, _this.telemetryRetentionDays) || other.telemetryRetentionDays == _this.telemetryRetentionDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SettingsRecord;
  return Object.hash(runtimeType,_this.id,_this.themeMode,_this.notificationsEnabled,_this.quietHoursEnabled,_this.quietHoursStart,_this.quietHoursEnd,_this.telemetryRetentionDays);
}

@override
String toString() {
  final _this = this as SettingsRecord;
  return 'SettingsRecord(id: ${_this.id}, themeMode: ${_this.themeMode}, notificationsEnabled: ${_this.notificationsEnabled}, quietHoursEnabled: ${_this.quietHoursEnabled}, quietHoursStart: ${_this.quietHoursStart}, quietHoursEnd: ${_this.quietHoursEnd}, telemetryRetentionDays: ${_this.telemetryRetentionDays})';
}


}

/// @nodoc
abstract mixin class $SettingsRecordCopyWith<$Res>  {
  factory $SettingsRecordCopyWith(SettingsRecord value, $Res Function(SettingsRecord) _then) = _$SettingsRecordCopyWithImpl;
@useResult
$Res call({
 String id, String themeMode, bool notificationsEnabled, bool quietHoursEnabled, String quietHoursStart, String quietHoursEnd, int telemetryRetentionDays
});




}
/// @nodoc
class _$SettingsRecordCopyWithImpl<$Res>
    implements $SettingsRecordCopyWith<$Res> {
  _$SettingsRecordCopyWithImpl(this._self, this._then);

  final SettingsRecord _self;
  final $Res Function(SettingsRecord) _then;

/// Create a copy of SettingsRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? themeMode = null,Object? notificationsEnabled = null,Object? quietHoursEnabled = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? telemetryRetentionDays = null,}) {
  return _then(SettingsRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,telemetryRetentionDays: null == telemetryRetentionDays ? _self.telemetryRetentionDays : telemetryRetentionDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsRecord].
extension SettingsRecordPatterns on SettingsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsRecord value)  $default,){
final _that = this;
switch (_that) {
case _SettingsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String themeMode,  bool notificationsEnabled,  bool quietHoursEnabled,  String quietHoursStart,  String quietHoursEnd,  int telemetryRetentionDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsRecord() when $default != null:
return $default(_that.id,_that.themeMode,_that.notificationsEnabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.telemetryRetentionDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String themeMode,  bool notificationsEnabled,  bool quietHoursEnabled,  String quietHoursStart,  String quietHoursEnd,  int telemetryRetentionDays)  $default,) {final _that = this;
switch (_that) {
case _SettingsRecord():
return $default(_that.id,_that.themeMode,_that.notificationsEnabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.telemetryRetentionDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String themeMode,  bool notificationsEnabled,  bool quietHoursEnabled,  String quietHoursStart,  String quietHoursEnd,  int telemetryRetentionDays)?  $default,) {final _that = this;
switch (_that) {
case _SettingsRecord() when $default != null:
return $default(_that.id,_that.themeMode,_that.notificationsEnabled,_that.quietHoursEnabled,_that.quietHoursStart,_that.quietHoursEnd,_that.telemetryRetentionDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsRecord implements SettingsRecord {
  const _SettingsRecord({required this.id, this.themeMode = 'system', this.notificationsEnabled = true, this.quietHoursEnabled = false, this.quietHoursStart = '22:00', this.quietHoursEnd = '07:00', this.telemetryRetentionDays = 90});
  factory _SettingsRecord.fromJson(Map<String, dynamic> json) => _$SettingsRecordFromJson(json);

@override final  String id;
@override@JsonKey() final  String themeMode;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool quietHoursEnabled;
@override@JsonKey() final  String quietHoursStart;
@override@JsonKey() final  String quietHoursEnd;
@override@JsonKey() final  int telemetryRetentionDays;

/// Create a copy of SettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsRecordCopyWith<_SettingsRecord> get copyWith => __$SettingsRecordCopyWithImpl<_SettingsRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.quietHoursStart, quietHoursStart) || other.quietHoursStart == quietHoursStart)&&(identical(other.quietHoursEnd, quietHoursEnd) || other.quietHoursEnd == quietHoursEnd)&&(identical(other.telemetryRetentionDays, telemetryRetentionDays) || other.telemetryRetentionDays == telemetryRetentionDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,themeMode,notificationsEnabled,quietHoursEnabled,quietHoursStart,quietHoursEnd,telemetryRetentionDays);
}

@override
String toString() {
    return 'SettingsRecord(id: $id, themeMode: $themeMode, notificationsEnabled: $notificationsEnabled, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, telemetryRetentionDays: $telemetryRetentionDays)';
}


}

/// @nodoc
abstract mixin class _$SettingsRecordCopyWith<$Res> implements $SettingsRecordCopyWith<$Res> {
  factory _$SettingsRecordCopyWith(_SettingsRecord value, $Res Function(_SettingsRecord) _then) = __$SettingsRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String themeMode, bool notificationsEnabled, bool quietHoursEnabled, String quietHoursStart, String quietHoursEnd, int telemetryRetentionDays
});




}
/// @nodoc
class __$SettingsRecordCopyWithImpl<$Res>
    implements _$SettingsRecordCopyWith<$Res> {
  __$SettingsRecordCopyWithImpl(this._self, this._then);

  final _SettingsRecord _self;
  final $Res Function(_SettingsRecord) _then;

/// Create a copy of SettingsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? themeMode = null,Object? notificationsEnabled = null,Object? quietHoursEnabled = null,Object? quietHoursStart = null,Object? quietHoursEnd = null,Object? telemetryRetentionDays = null,}) {
  return _then(_SettingsRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,quietHoursStart: null == quietHoursStart ? _self.quietHoursStart : quietHoursStart // ignore: cast_nullable_to_non_nullable
as String,quietHoursEnd: null == quietHoursEnd ? _self.quietHoursEnd : quietHoursEnd // ignore: cast_nullable_to_non_nullable
as String,telemetryRetentionDays: null == telemetryRetentionDays ? _self.telemetryRetentionDays : telemetryRetentionDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
