// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'developer_identity_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeveloperIdentityRecord {

 String get id; String get socketId; String get claimCode; String get publicKey; String get status; DateTime get createdAt;
/// Create a copy of DeveloperIdentityRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeveloperIdentityRecordCopyWith<DeveloperIdentityRecord> get copyWith => _$DeveloperIdentityRecordCopyWithImpl<DeveloperIdentityRecord>(this as DeveloperIdentityRecord, _$identity);

  /// Serializes this DeveloperIdentityRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeveloperIdentityRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeveloperIdentityRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.socketId, _this.socketId) || other.socketId == _this.socketId)&&(identical(other.claimCode, _this.claimCode) || other.claimCode == _this.claimCode)&&(identical(other.publicKey, _this.publicKey) || other.publicKey == _this.publicKey)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeveloperIdentityRecord;
  return Object.hash(runtimeType,_this.id,_this.socketId,_this.claimCode,_this.publicKey,_this.status,_this.createdAt);
}

@override
String toString() {
  final _this = this as DeveloperIdentityRecord;
  return 'DeveloperIdentityRecord(id: ${_this.id}, socketId: ${_this.socketId}, claimCode: ${_this.claimCode}, publicKey: ${_this.publicKey}, status: ${_this.status}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $DeveloperIdentityRecordCopyWith<$Res>  {
  factory $DeveloperIdentityRecordCopyWith(DeveloperIdentityRecord value, $Res Function(DeveloperIdentityRecord) _then) = _$DeveloperIdentityRecordCopyWithImpl;
@useResult
$Res call({
 String id, String socketId, String claimCode, String publicKey, String status, DateTime createdAt
});




}
/// @nodoc
class _$DeveloperIdentityRecordCopyWithImpl<$Res>
    implements $DeveloperIdentityRecordCopyWith<$Res> {
  _$DeveloperIdentityRecordCopyWithImpl(this._self, this._then);

  final DeveloperIdentityRecord _self;
  final $Res Function(DeveloperIdentityRecord) _then;

/// Create a copy of DeveloperIdentityRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? socketId = null,Object? claimCode = null,Object? publicKey = null,Object? status = null,Object? createdAt = null,}) {
  return _then(DeveloperIdentityRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,socketId: null == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String,claimCode: null == claimCode ? _self.claimCode : claimCode // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DeveloperIdentityRecord].
extension DeveloperIdentityRecordPatterns on DeveloperIdentityRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeveloperIdentityRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeveloperIdentityRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeveloperIdentityRecord value)  $default,){
final _that = this;
switch (_that) {
case _DeveloperIdentityRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeveloperIdentityRecord value)?  $default,){
final _that = this;
switch (_that) {
case _DeveloperIdentityRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String socketId,  String claimCode,  String publicKey,  String status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeveloperIdentityRecord() when $default != null:
return $default(_that.id,_that.socketId,_that.claimCode,_that.publicKey,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String socketId,  String claimCode,  String publicKey,  String status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DeveloperIdentityRecord():
return $default(_that.id,_that.socketId,_that.claimCode,_that.publicKey,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String socketId,  String claimCode,  String publicKey,  String status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DeveloperIdentityRecord() when $default != null:
return $default(_that.id,_that.socketId,_that.claimCode,_that.publicKey,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeveloperIdentityRecord implements DeveloperIdentityRecord {
  const _DeveloperIdentityRecord({required this.id, required this.socketId, required this.claimCode, required this.publicKey, this.status = 'active', required this.createdAt});
  factory _DeveloperIdentityRecord.fromJson(Map<String, dynamic> json) => _$DeveloperIdentityRecordFromJson(json);

@override final  String id;
@override final  String socketId;
@override final  String claimCode;
@override final  String publicKey;
@override@JsonKey() final  String status;
@override final  DateTime createdAt;

/// Create a copy of DeveloperIdentityRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeveloperIdentityRecordCopyWith<_DeveloperIdentityRecord> get copyWith => __$DeveloperIdentityRecordCopyWithImpl<_DeveloperIdentityRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeveloperIdentityRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeveloperIdentityRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.socketId, socketId) || other.socketId == socketId)&&(identical(other.claimCode, claimCode) || other.claimCode == claimCode)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,socketId,claimCode,publicKey,status,createdAt);
}

@override
String toString() {
    return 'DeveloperIdentityRecord(id: $id, socketId: $socketId, claimCode: $claimCode, publicKey: $publicKey, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DeveloperIdentityRecordCopyWith<$Res> implements $DeveloperIdentityRecordCopyWith<$Res> {
  factory _$DeveloperIdentityRecordCopyWith(_DeveloperIdentityRecord value, $Res Function(_DeveloperIdentityRecord) _then) = __$DeveloperIdentityRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String socketId, String claimCode, String publicKey, String status, DateTime createdAt
});




}
/// @nodoc
class __$DeveloperIdentityRecordCopyWithImpl<$Res>
    implements _$DeveloperIdentityRecordCopyWith<$Res> {
  __$DeveloperIdentityRecordCopyWithImpl(this._self, this._then);

  final _DeveloperIdentityRecord _self;
  final $Res Function(_DeveloperIdentityRecord) _then;

/// Create a copy of DeveloperIdentityRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? socketId = null,Object? claimCode = null,Object? publicKey = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_DeveloperIdentityRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,socketId: null == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String,claimCode: null == claimCode ? _self.claimCode : claimCode // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
