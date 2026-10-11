// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserRecord {

 String get id; String get name; String get email; String get role; bool get verified;
/// Create a copy of UserRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserRecordCopyWith<UserRecord> get copyWith => _$UserRecordCopyWithImpl<UserRecord>(this as UserRecord, _$identity);

  /// Serializes this UserRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.verified, _this.verified) || other.verified == _this.verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserRecord;
  return Object.hash(runtimeType,_this.id,_this.name,_this.email,_this.role,_this.verified);
}

@override
String toString() {
  final _this = this as UserRecord;
  return 'UserRecord(id: ${_this.id}, name: ${_this.name}, email: ${_this.email}, role: ${_this.role}, verified: ${_this.verified})';
}


}

/// @nodoc
abstract mixin class $UserRecordCopyWith<$Res>  {
  factory $UserRecordCopyWith(UserRecord value, $Res Function(UserRecord) _then) = _$UserRecordCopyWithImpl;
@useResult
$Res call({
 String id, String name, String email, String role, bool verified
});




}
/// @nodoc
class _$UserRecordCopyWithImpl<$Res>
    implements $UserRecordCopyWith<$Res> {
  _$UserRecordCopyWithImpl(this._self, this._then);

  final UserRecord _self;
  final $Res Function(UserRecord) _then;

/// Create a copy of UserRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? verified = null,}) {
  return _then(UserRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserRecord].
extension UserRecordPatterns on UserRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserRecord value)  $default,){
final _that = this;
switch (_that) {
case _UserRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserRecord value)?  $default,){
final _that = this;
switch (_that) {
case _UserRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String role,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserRecord() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String email,  String role,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _UserRecord():
return $default(_that.id,_that.name,_that.email,_that.role,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String email,  String role,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _UserRecord() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.role,_that.verified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserRecord implements UserRecord {
  const _UserRecord({required this.id, required this.name, required this.email, this.role = 'owner', this.verified = true});
  factory _UserRecord.fromJson(Map<String, dynamic> json) => _$UserRecordFromJson(json);

@override final  String id;
@override final  String name;
@override final  String email;
@override@JsonKey() final  String role;
@override@JsonKey() final  bool verified;

/// Create a copy of UserRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserRecordCopyWith<_UserRecord> get copyWith => __$UserRecordCopyWithImpl<_UserRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.role, role) || other.role == role)&&(identical(other.verified, verified) || other.verified == verified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,email,role,verified);
}

@override
String toString() {
    return 'UserRecord(id: $id, name: $name, email: $email, role: $role, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$UserRecordCopyWith<$Res> implements $UserRecordCopyWith<$Res> {
  factory _$UserRecordCopyWith(_UserRecord value, $Res Function(_UserRecord) _then) = __$UserRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String email, String role, bool verified
});




}
/// @nodoc
class __$UserRecordCopyWithImpl<$Res>
    implements _$UserRecordCopyWith<$Res> {
  __$UserRecordCopyWithImpl(this._self, this._then);

  final _UserRecord _self;
  final $Res Function(_UserRecord) _then;

/// Create a copy of UserRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = null,Object? role = null,Object? verified = null,}) {
  return _then(_UserRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
