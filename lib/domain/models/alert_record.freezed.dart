// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alert_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertRecord {

 String get id; String get title; String get message; String get time; String get severity; String get category; String get device; bool get acknowledged;
/// Create a copy of AlertRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertRecordCopyWith<AlertRecord> get copyWith => _$AlertRecordCopyWithImpl<AlertRecord>(this as AlertRecord, _$identity);

  /// Serializes this AlertRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlertRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlertRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.acknowledged, _this.acknowledged) || other.acknowledged == _this.acknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlertRecord;
  return Object.hash(runtimeType,_this.id,_this.title,_this.message,_this.time,_this.severity,_this.category,_this.device,_this.acknowledged);
}

@override
String toString() {
  final _this = this as AlertRecord;
  return 'AlertRecord(id: ${_this.id}, title: ${_this.title}, message: ${_this.message}, time: ${_this.time}, severity: ${_this.severity}, category: ${_this.category}, device: ${_this.device}, acknowledged: ${_this.acknowledged})';
}


}

/// @nodoc
abstract mixin class $AlertRecordCopyWith<$Res>  {
  factory $AlertRecordCopyWith(AlertRecord value, $Res Function(AlertRecord) _then) = _$AlertRecordCopyWithImpl;
@useResult
$Res call({
 String id, String title, String message, String time, String severity, String category, String device, bool acknowledged
});




}
/// @nodoc
class _$AlertRecordCopyWithImpl<$Res>
    implements $AlertRecordCopyWith<$Res> {
  _$AlertRecordCopyWithImpl(this._self, this._then);

  final AlertRecord _self;
  final $Res Function(AlertRecord) _then;

/// Create a copy of AlertRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? message = null,Object? time = null,Object? severity = null,Object? category = null,Object? device = null,Object? acknowledged = null,}) {
  return _then(AlertRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AlertRecord].
extension AlertRecordPatterns on AlertRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlertRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlertRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlertRecord value)  $default,){
final _that = this;
switch (_that) {
case _AlertRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlertRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AlertRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String message,  String time,  String severity,  String category,  String device,  bool acknowledged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlertRecord() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.time,_that.severity,_that.category,_that.device,_that.acknowledged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String message,  String time,  String severity,  String category,  String device,  bool acknowledged)  $default,) {final _that = this;
switch (_that) {
case _AlertRecord():
return $default(_that.id,_that.title,_that.message,_that.time,_that.severity,_that.category,_that.device,_that.acknowledged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String message,  String time,  String severity,  String category,  String device,  bool acknowledged)?  $default,) {final _that = this;
switch (_that) {
case _AlertRecord() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.time,_that.severity,_that.category,_that.device,_that.acknowledged);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlertRecord implements AlertRecord {
  const _AlertRecord({required this.id, required this.title, required this.message, required this.time, this.severity = 'info', this.category = 'energy', this.device = '', this.acknowledged = false});
  factory _AlertRecord.fromJson(Map<String, dynamic> json) => _$AlertRecordFromJson(json);

@override final  String id;
@override final  String title;
@override final  String message;
@override final  String time;
@override@JsonKey() final  String severity;
@override@JsonKey() final  String category;
@override@JsonKey() final  String device;
@override@JsonKey() final  bool acknowledged;

/// Create a copy of AlertRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertRecordCopyWith<_AlertRecord> get copyWith => __$AlertRecordCopyWithImpl<_AlertRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlertRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.time, time) || other.time == time)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.category, category) || other.category == category)&&(identical(other.device, device) || other.device == device)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,message,time,severity,category,device,acknowledged);
}

@override
String toString() {
    return 'AlertRecord(id: $id, title: $title, message: $message, time: $time, severity: $severity, category: $category, device: $device, acknowledged: $acknowledged)';
}


}

/// @nodoc
abstract mixin class _$AlertRecordCopyWith<$Res> implements $AlertRecordCopyWith<$Res> {
  factory _$AlertRecordCopyWith(_AlertRecord value, $Res Function(_AlertRecord) _then) = __$AlertRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String message, String time, String severity, String category, String device, bool acknowledged
});




}
/// @nodoc
class __$AlertRecordCopyWithImpl<$Res>
    implements _$AlertRecordCopyWith<$Res> {
  __$AlertRecordCopyWithImpl(this._self, this._then);

  final _AlertRecord _self;
  final $Res Function(_AlertRecord) _then;

/// Create a copy of AlertRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = null,Object? time = null,Object? severity = null,Object? category = null,Object? device = null,Object? acknowledged = null,}) {
  return _then(_AlertRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
