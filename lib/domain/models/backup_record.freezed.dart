// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BackupRecord {

 String get id; bool get connected; String get state; int get pendingCount; String? get error; DateTime? get lastSyncAt;
/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupRecordCopyWith<BackupRecord> get copyWith => _$BackupRecordCopyWithImpl<BackupRecord>(this as BackupRecord, _$identity);

  /// Serializes this BackupRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BackupRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.connected, _this.connected) || other.connected == _this.connected)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.pendingCount, _this.pendingCount) || other.pendingCount == _this.pendingCount)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.lastSyncAt, _this.lastSyncAt) || other.lastSyncAt == _this.lastSyncAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BackupRecord;
  return Object.hash(runtimeType,_this.id,_this.connected,_this.state,_this.pendingCount,_this.error,_this.lastSyncAt);
}

@override
String toString() {
  final _this = this as BackupRecord;
  return 'BackupRecord(id: ${_this.id}, connected: ${_this.connected}, state: ${_this.state}, pendingCount: ${_this.pendingCount}, error: ${_this.error}, lastSyncAt: ${_this.lastSyncAt})';
}


}

/// @nodoc
abstract mixin class $BackupRecordCopyWith<$Res>  {
  factory $BackupRecordCopyWith(BackupRecord value, $Res Function(BackupRecord) _then) = _$BackupRecordCopyWithImpl;
@useResult
$Res call({
 String id, bool connected, String state, int pendingCount, String? error, DateTime? lastSyncAt
});




}
/// @nodoc
class _$BackupRecordCopyWithImpl<$Res>
    implements $BackupRecordCopyWith<$Res> {
  _$BackupRecordCopyWithImpl(this._self, this._then);

  final BackupRecord _self;
  final $Res Function(BackupRecord) _then;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? connected = null,Object? state = null,Object? pendingCount = null,Object? error = freezed,Object? lastSyncAt = freezed,}) {
  return _then(BackupRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupRecord].
extension BackupRecordPatterns on BackupRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupRecord value)  $default,){
final _that = this;
switch (_that) {
case _BackupRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool connected,  String state,  int pendingCount,  String? error,  DateTime? lastSyncAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that.id,_that.connected,_that.state,_that.pendingCount,_that.error,_that.lastSyncAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool connected,  String state,  int pendingCount,  String? error,  DateTime? lastSyncAt)  $default,) {final _that = this;
switch (_that) {
case _BackupRecord():
return $default(_that.id,_that.connected,_that.state,_that.pendingCount,_that.error,_that.lastSyncAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool connected,  String state,  int pendingCount,  String? error,  DateTime? lastSyncAt)?  $default,) {final _that = this;
switch (_that) {
case _BackupRecord() when $default != null:
return $default(_that.id,_that.connected,_that.state,_that.pendingCount,_that.error,_that.lastSyncAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BackupRecord implements BackupRecord {
  const _BackupRecord({required this.id, this.connected = false, this.state = 'notConnected', this.pendingCount = 0, this.error, this.lastSyncAt});
  factory _BackupRecord.fromJson(Map<String, dynamic> json) => _$BackupRecordFromJson(json);

@override final  String id;
@override@JsonKey() final  bool connected;
@override@JsonKey() final  String state;
@override@JsonKey() final  int pendingCount;
@override final  String? error;
@override final  DateTime? lastSyncAt;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupRecordCopyWith<_BackupRecord> get copyWith => __$BackupRecordCopyWithImpl<_BackupRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BackupRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.connected, connected) || other.connected == connected)&&(identical(other.state, state) || other.state == state)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.error, error) || other.error == error)&&(identical(other.lastSyncAt, lastSyncAt) || other.lastSyncAt == lastSyncAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,connected,state,pendingCount,error,lastSyncAt);
}

@override
String toString() {
    return 'BackupRecord(id: $id, connected: $connected, state: $state, pendingCount: $pendingCount, error: $error, lastSyncAt: $lastSyncAt)';
}


}

/// @nodoc
abstract mixin class _$BackupRecordCopyWith<$Res> implements $BackupRecordCopyWith<$Res> {
  factory _$BackupRecordCopyWith(_BackupRecord value, $Res Function(_BackupRecord) _then) = __$BackupRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, bool connected, String state, int pendingCount, String? error, DateTime? lastSyncAt
});




}
/// @nodoc
class __$BackupRecordCopyWithImpl<$Res>
    implements _$BackupRecordCopyWith<$Res> {
  __$BackupRecordCopyWithImpl(this._self, this._then);

  final _BackupRecord _self;
  final $Res Function(_BackupRecord) _then;

/// Create a copy of BackupRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? connected = null,Object? state = null,Object? pendingCount = null,Object? error = freezed,Object? lastSyncAt = freezed,}) {
  return _then(_BackupRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAt: freezed == lastSyncAt ? _self.lastSyncAt : lastSyncAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
