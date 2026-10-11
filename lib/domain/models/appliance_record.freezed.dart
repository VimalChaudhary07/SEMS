// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appliance_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplianceRecord {

 String get id; String get name; String? get socketId; String get room; String get status; double get lifetimeKwh; double get todayKwh;
/// Create a copy of ApplianceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplianceRecordCopyWith<ApplianceRecord> get copyWith => _$ApplianceRecordCopyWithImpl<ApplianceRecord>(this as ApplianceRecord, _$identity);

  /// Serializes this ApplianceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApplianceRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplianceRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.socketId, _this.socketId) || other.socketId == _this.socketId)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.lifetimeKwh, _this.lifetimeKwh) || other.lifetimeKwh == _this.lifetimeKwh)&&(identical(other.todayKwh, _this.todayKwh) || other.todayKwh == _this.todayKwh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApplianceRecord;
  return Object.hash(runtimeType,_this.id,_this.name,_this.socketId,_this.room,_this.status,_this.lifetimeKwh,_this.todayKwh);
}

@override
String toString() {
  final _this = this as ApplianceRecord;
  return 'ApplianceRecord(id: ${_this.id}, name: ${_this.name}, socketId: ${_this.socketId}, room: ${_this.room}, status: ${_this.status}, lifetimeKwh: ${_this.lifetimeKwh}, todayKwh: ${_this.todayKwh})';
}


}

/// @nodoc
abstract mixin class $ApplianceRecordCopyWith<$Res>  {
  factory $ApplianceRecordCopyWith(ApplianceRecord value, $Res Function(ApplianceRecord) _then) = _$ApplianceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? socketId, String room, String status, double lifetimeKwh, double todayKwh
});




}
/// @nodoc
class _$ApplianceRecordCopyWithImpl<$Res>
    implements $ApplianceRecordCopyWith<$Res> {
  _$ApplianceRecordCopyWithImpl(this._self, this._then);

  final ApplianceRecord _self;
  final $Res Function(ApplianceRecord) _then;

/// Create a copy of ApplianceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? socketId = freezed,Object? room = null,Object? status = null,Object? lifetimeKwh = null,Object? todayKwh = null,}) {
  return _then(ApplianceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,socketId: freezed == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String?,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lifetimeKwh: null == lifetimeKwh ? _self.lifetimeKwh : lifetimeKwh // ignore: cast_nullable_to_non_nullable
as double,todayKwh: null == todayKwh ? _self.todayKwh : todayKwh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplianceRecord].
extension ApplianceRecordPatterns on ApplianceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplianceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplianceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplianceRecord value)  $default,){
final _that = this;
switch (_that) {
case _ApplianceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplianceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ApplianceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? socketId,  String room,  String status,  double lifetimeKwh,  double todayKwh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplianceRecord() when $default != null:
return $default(_that.id,_that.name,_that.socketId,_that.room,_that.status,_that.lifetimeKwh,_that.todayKwh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? socketId,  String room,  String status,  double lifetimeKwh,  double todayKwh)  $default,) {final _that = this;
switch (_that) {
case _ApplianceRecord():
return $default(_that.id,_that.name,_that.socketId,_that.room,_that.status,_that.lifetimeKwh,_that.todayKwh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? socketId,  String room,  String status,  double lifetimeKwh,  double todayKwh)?  $default,) {final _that = this;
switch (_that) {
case _ApplianceRecord() when $default != null:
return $default(_that.id,_that.name,_that.socketId,_that.room,_that.status,_that.lifetimeKwh,_that.todayKwh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplianceRecord implements ApplianceRecord {
  const _ApplianceRecord({required this.id, required this.name, this.socketId, this.room = '', this.status = 'active', this.lifetimeKwh = 0, this.todayKwh = 0});
  factory _ApplianceRecord.fromJson(Map<String, dynamic> json) => _$ApplianceRecordFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? socketId;
@override@JsonKey() final  String room;
@override@JsonKey() final  String status;
@override@JsonKey() final  double lifetimeKwh;
@override@JsonKey() final  double todayKwh;

/// Create a copy of ApplianceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplianceRecordCopyWith<_ApplianceRecord> get copyWith => __$ApplianceRecordCopyWithImpl<_ApplianceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplianceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplianceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.socketId, socketId) || other.socketId == socketId)&&(identical(other.room, room) || other.room == room)&&(identical(other.status, status) || other.status == status)&&(identical(other.lifetimeKwh, lifetimeKwh) || other.lifetimeKwh == lifetimeKwh)&&(identical(other.todayKwh, todayKwh) || other.todayKwh == todayKwh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,socketId,room,status,lifetimeKwh,todayKwh);
}

@override
String toString() {
    return 'ApplianceRecord(id: $id, name: $name, socketId: $socketId, room: $room, status: $status, lifetimeKwh: $lifetimeKwh, todayKwh: $todayKwh)';
}


}

/// @nodoc
abstract mixin class _$ApplianceRecordCopyWith<$Res> implements $ApplianceRecordCopyWith<$Res> {
  factory _$ApplianceRecordCopyWith(_ApplianceRecord value, $Res Function(_ApplianceRecord) _then) = __$ApplianceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? socketId, String room, String status, double lifetimeKwh, double todayKwh
});




}
/// @nodoc
class __$ApplianceRecordCopyWithImpl<$Res>
    implements _$ApplianceRecordCopyWith<$Res> {
  __$ApplianceRecordCopyWithImpl(this._self, this._then);

  final _ApplianceRecord _self;
  final $Res Function(_ApplianceRecord) _then;

/// Create a copy of ApplianceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? socketId = freezed,Object? room = null,Object? status = null,Object? lifetimeKwh = null,Object? todayKwh = null,}) {
  return _then(_ApplianceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,socketId: freezed == socketId ? _self.socketId : socketId // ignore: cast_nullable_to_non_nullable
as String?,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,lifetimeKwh: null == lifetimeKwh ? _self.lifetimeKwh : lifetimeKwh // ignore: cast_nullable_to_non_nullable
as double,todayKwh: null == todayKwh ? _self.todayKwh : todayKwh // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
