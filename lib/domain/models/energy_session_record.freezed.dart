// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'energy_session_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnergySessionRecord {

 String get id; String get applianceId; String get socketId; DateTime get startedAt; double get startMeterKwh; double get currentMeterKwh; DateTime? get endedAt;
/// Create a copy of EnergySessionRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnergySessionRecordCopyWith<EnergySessionRecord> get copyWith => _$EnergySessionRecordCopyWithImpl<EnergySessionRecord>(this as EnergySessionRecord, _$identity);

  /// Serializes this EnergySessionRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnergySessionRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnergySessionRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.applianceId, _this.applianceId) || other.applianceId == _this.applianceId)&&(identical(other.socketId, _this.socketId) || other.socketId == _this.socketId)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.startMeterKwh, _this.startMeterKwh) || other.startMeterKwh == _this.startMeterKwh)&&(identical(other.currentMeterKwh, _this.currentMeterKwh) || other.currentMeterKwh == _this.currentMeterKwh)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnergySessionRecord;
  return Object.hash(runtimeType,_this.id,_this.applianceId,_this.socketId,_this.startedAt,_this.startMeterKwh,_this.currentMeterKwh,_this.endedAt);
}

@override
String toString() {
  final _this = this as EnergySessionRecord;
  return 'EnergySessionRecord(id: ${_this.id}, applianceId: ${_this.applianceId}, socketId: ${_this.socketId}, startedAt: ${_this.startedAt}, startMeterKwh: ${_this.startMeterKwh}, currentMeterKwh: ${_this.currentMeterKwh}, endedAt: ${_this.endedAt})';
}


}

/// @nodoc
abstract mixin class $EnergySessionRecordCopyWith<$Res>  {
  factory $EnergySessionRecordCopyWith(EnergySessionRecord value, $Res Function(EnergySessionRecord) _then) = _$EnergySessionRecordCopyWithImpl;
@useResult
$Res call({
 String id, String applianceId, String socketId, DateTime startedAt, double startMeterKwh, double currentMeterKwh, DateTime? endedAt
});




}
/// @nodoc
class _$EnergySessionRecordCopyWithImpl<$Res>
    implements $EnergySessionRecordCopyWith<$Res> {
  _$EnergySessionRecordCopyWithImpl(this._self, this._then);

  final EnergySessionRecord _self;
  final $Res Function(EnergySessionRecord) _then;

/// Create a copy of EnergySessionRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? applianceId = null,Object? socketId = null,Object? startedAt = null,Object? startMeterKwh = null,Object? currentMeterKwh = null,Object? endedAt = freezed,}) {
  return _then(EnergySessionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applianceId: null == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String,socketId: null == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startMeterKwh: null == startMeterKwh ? _self.startMeterKwh : startMeterKwh // ignore: cast_nullable_to_non_nullable
as double,currentMeterKwh: null == currentMeterKwh ? _self.currentMeterKwh : currentMeterKwh // ignore: cast_nullable_to_non_nullable
as double,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnergySessionRecord].
extension EnergySessionRecordPatterns on EnergySessionRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnergySessionRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnergySessionRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnergySessionRecord value)  $default,){
final _that = this;
switch (_that) {
case _EnergySessionRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnergySessionRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EnergySessionRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String applianceId,  String socketId,  DateTime startedAt,  double startMeterKwh,  double currentMeterKwh,  DateTime? endedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnergySessionRecord() when $default != null:
return $default(_that.id,_that.applianceId,_that.socketId,_that.startedAt,_that.startMeterKwh,_that.currentMeterKwh,_that.endedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String applianceId,  String socketId,  DateTime startedAt,  double startMeterKwh,  double currentMeterKwh,  DateTime? endedAt)  $default,) {final _that = this;
switch (_that) {
case _EnergySessionRecord():
return $default(_that.id,_that.applianceId,_that.socketId,_that.startedAt,_that.startMeterKwh,_that.currentMeterKwh,_that.endedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String applianceId,  String socketId,  DateTime startedAt,  double startMeterKwh,  double currentMeterKwh,  DateTime? endedAt)?  $default,) {final _that = this;
switch (_that) {
case _EnergySessionRecord() when $default != null:
return $default(_that.id,_that.applianceId,_that.socketId,_that.startedAt,_that.startMeterKwh,_that.currentMeterKwh,_that.endedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnergySessionRecord extends EnergySessionRecord {
  const _EnergySessionRecord({required this.id, required this.applianceId, required this.socketId, required this.startedAt, required this.startMeterKwh, required this.currentMeterKwh, this.endedAt}): super._();
  factory _EnergySessionRecord.fromJson(Map<String, dynamic> json) => _$EnergySessionRecordFromJson(json);

@override final  String id;
@override final  String applianceId;
@override final  String socketId;
@override final  DateTime startedAt;
@override final  double startMeterKwh;
@override final  double currentMeterKwh;
@override final  DateTime? endedAt;

/// Create a copy of EnergySessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnergySessionRecordCopyWith<_EnergySessionRecord> get copyWith => __$EnergySessionRecordCopyWithImpl<_EnergySessionRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnergySessionRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnergySessionRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.applianceId, applianceId) || other.applianceId == applianceId)&&(identical(other.socketId, socketId) || other.socketId == socketId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.startMeterKwh, startMeterKwh) || other.startMeterKwh == startMeterKwh)&&(identical(other.currentMeterKwh, currentMeterKwh) || other.currentMeterKwh == currentMeterKwh)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,applianceId,socketId,startedAt,startMeterKwh,currentMeterKwh,endedAt);
}

@override
String toString() {
    return 'EnergySessionRecord(id: $id, applianceId: $applianceId, socketId: $socketId, startedAt: $startedAt, startMeterKwh: $startMeterKwh, currentMeterKwh: $currentMeterKwh, endedAt: $endedAt)';
}


}

/// @nodoc
abstract mixin class _$EnergySessionRecordCopyWith<$Res> implements $EnergySessionRecordCopyWith<$Res> {
  factory _$EnergySessionRecordCopyWith(_EnergySessionRecord value, $Res Function(_EnergySessionRecord) _then) = __$EnergySessionRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String applianceId, String socketId, DateTime startedAt, double startMeterKwh, double currentMeterKwh, DateTime? endedAt
});




}
/// @nodoc
class __$EnergySessionRecordCopyWithImpl<$Res>
    implements _$EnergySessionRecordCopyWith<$Res> {
  __$EnergySessionRecordCopyWithImpl(this._self, this._then);

  final _EnergySessionRecord _self;
  final $Res Function(_EnergySessionRecord) _then;

/// Create a copy of EnergySessionRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? applianceId = null,Object? socketId = null,Object? startedAt = null,Object? startMeterKwh = null,Object? currentMeterKwh = null,Object? endedAt = freezed,}) {
  return _then(_EnergySessionRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,applianceId: null == applianceId ? _self.applianceId : applianceId // ignore: cast_nullable_to_non_nullable
as String,socketId: null == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startMeterKwh: null == startMeterKwh ? _self.startMeterKwh : startMeterKwh // ignore: cast_nullable_to_non_nullable
as double,currentMeterKwh: null == currentMeterKwh ? _self.currentMeterKwh : currentMeterKwh // ignore: cast_nullable_to_non_nullable
as double,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
