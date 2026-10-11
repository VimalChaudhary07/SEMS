// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'json_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JsonRecord {

 String get id; JsonMap get data;
/// Create a copy of JsonRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JsonRecordCopyWith<JsonRecord> get copyWith => _$JsonRecordCopyWithImpl<JsonRecord>(this as JsonRecord, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JsonRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JsonRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&const DeepCollectionEquality().equals(other.data, _this.data));
}


@override
int get hashCode {
  final _this = this as JsonRecord;
  return Object.hash(runtimeType,_this.id,const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as JsonRecord;
  return 'JsonRecord(id: ${_this.id}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $JsonRecordCopyWith<$Res>  {
  factory $JsonRecordCopyWith(JsonRecord value, $Res Function(JsonRecord) _then) = _$JsonRecordCopyWithImpl;
@useResult
$Res call({
 String id, JsonMap data
});




}
/// @nodoc
class _$JsonRecordCopyWithImpl<$Res>
    implements $JsonRecordCopyWith<$Res> {
  _$JsonRecordCopyWithImpl(this._self, this._then);

  final JsonRecord _self;
  final $Res Function(JsonRecord) _then;

/// Create a copy of JsonRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? data = null,}) {
  return _then(JsonRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as JsonMap,
  ));
}

}


/// Adds pattern-matching-related methods to [JsonRecord].
extension JsonRecordPatterns on JsonRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JsonRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JsonRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JsonRecord value)  $default,){
final _that = this;
switch (_that) {
case _JsonRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JsonRecord value)?  $default,){
final _that = this;
switch (_that) {
case _JsonRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  JsonMap data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JsonRecord() when $default != null:
return $default(_that.id,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  JsonMap data)  $default,) {final _that = this;
switch (_that) {
case _JsonRecord():
return $default(_that.id,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  JsonMap data)?  $default,) {final _that = this;
switch (_that) {
case _JsonRecord() when $default != null:
return $default(_that.id,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _JsonRecord implements JsonRecord {
  const _JsonRecord({required this.id, required  JsonMap data}): _data = data;
  

@override final  String id;
 final  JsonMap _data;
@override JsonMap get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of JsonRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JsonRecordCopyWith<_JsonRecord> get copyWith => __$JsonRecordCopyWithImpl<_JsonRecord>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JsonRecord&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.data, _data));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'JsonRecord(id: $id, data: $data)';
}


}

/// @nodoc
abstract mixin class _$JsonRecordCopyWith<$Res> implements $JsonRecordCopyWith<$Res> {
  factory _$JsonRecordCopyWith(_JsonRecord value, $Res Function(_JsonRecord) _then) = __$JsonRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, JsonMap data
});




}
/// @nodoc
class __$JsonRecordCopyWithImpl<$Res>
    implements _$JsonRecordCopyWith<$Res> {
  __$JsonRecordCopyWithImpl(this._self, this._then);

  final _JsonRecord _self;
  final $Res Function(_JsonRecord) _then;

/// Create a copy of JsonRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? data = null,}) {
  return _then(_JsonRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as JsonMap,
  ));
}


}

// dart format on
