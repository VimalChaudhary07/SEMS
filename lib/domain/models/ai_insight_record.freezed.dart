// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_insight_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiInsightRecord {

 String get id; String get title; String get description; double get estimatedSavingInrPerMonth; String get severity; int get coverageDays;
/// Create a copy of AiInsightRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiInsightRecordCopyWith<AiInsightRecord> get copyWith => _$AiInsightRecordCopyWithImpl<AiInsightRecord>(this as AiInsightRecord, _$identity);

  /// Serializes this AiInsightRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AiInsightRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiInsightRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.estimatedSavingInrPerMonth, _this.estimatedSavingInrPerMonth) || other.estimatedSavingInrPerMonth == _this.estimatedSavingInrPerMonth)&&(identical(other.severity, _this.severity) || other.severity == _this.severity)&&(identical(other.coverageDays, _this.coverageDays) || other.coverageDays == _this.coverageDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AiInsightRecord;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.estimatedSavingInrPerMonth,_this.severity,_this.coverageDays);
}

@override
String toString() {
  final _this = this as AiInsightRecord;
  return 'AiInsightRecord(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, estimatedSavingInrPerMonth: ${_this.estimatedSavingInrPerMonth}, severity: ${_this.severity}, coverageDays: ${_this.coverageDays})';
}


}

/// @nodoc
abstract mixin class $AiInsightRecordCopyWith<$Res>  {
  factory $AiInsightRecordCopyWith(AiInsightRecord value, $Res Function(AiInsightRecord) _then) = _$AiInsightRecordCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, double estimatedSavingInrPerMonth, String severity, int coverageDays
});




}
/// @nodoc
class _$AiInsightRecordCopyWithImpl<$Res>
    implements $AiInsightRecordCopyWith<$Res> {
  _$AiInsightRecordCopyWithImpl(this._self, this._then);

  final AiInsightRecord _self;
  final $Res Function(AiInsightRecord) _then;

/// Create a copy of AiInsightRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? estimatedSavingInrPerMonth = null,Object? severity = null,Object? coverageDays = null,}) {
  return _then(AiInsightRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,estimatedSavingInrPerMonth: null == estimatedSavingInrPerMonth ? _self.estimatedSavingInrPerMonth : estimatedSavingInrPerMonth // ignore: cast_nullable_to_non_nullable
as double,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,coverageDays: null == coverageDays ? _self.coverageDays : coverageDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AiInsightRecord].
extension AiInsightRecordPatterns on AiInsightRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiInsightRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiInsightRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiInsightRecord value)  $default,){
final _that = this;
switch (_that) {
case _AiInsightRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiInsightRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AiInsightRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double estimatedSavingInrPerMonth,  String severity,  int coverageDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiInsightRecord() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.estimatedSavingInrPerMonth,_that.severity,_that.coverageDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  double estimatedSavingInrPerMonth,  String severity,  int coverageDays)  $default,) {final _that = this;
switch (_that) {
case _AiInsightRecord():
return $default(_that.id,_that.title,_that.description,_that.estimatedSavingInrPerMonth,_that.severity,_that.coverageDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  double estimatedSavingInrPerMonth,  String severity,  int coverageDays)?  $default,) {final _that = this;
switch (_that) {
case _AiInsightRecord() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.estimatedSavingInrPerMonth,_that.severity,_that.coverageDays);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiInsightRecord implements AiInsightRecord {
  const _AiInsightRecord({required this.id, required this.title, required this.description, this.estimatedSavingInrPerMonth = 0, this.severity = 'info', this.coverageDays = 0});
  factory _AiInsightRecord.fromJson(Map<String, dynamic> json) => _$AiInsightRecordFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override@JsonKey() final  double estimatedSavingInrPerMonth;
@override@JsonKey() final  String severity;
@override@JsonKey() final  int coverageDays;

/// Create a copy of AiInsightRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiInsightRecordCopyWith<_AiInsightRecord> get copyWith => __$AiInsightRecordCopyWithImpl<_AiInsightRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiInsightRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiInsightRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.estimatedSavingInrPerMonth, estimatedSavingInrPerMonth) || other.estimatedSavingInrPerMonth == estimatedSavingInrPerMonth)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.coverageDays, coverageDays) || other.coverageDays == coverageDays));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,estimatedSavingInrPerMonth,severity,coverageDays);
}

@override
String toString() {
    return 'AiInsightRecord(id: $id, title: $title, description: $description, estimatedSavingInrPerMonth: $estimatedSavingInrPerMonth, severity: $severity, coverageDays: $coverageDays)';
}


}

/// @nodoc
abstract mixin class _$AiInsightRecordCopyWith<$Res> implements $AiInsightRecordCopyWith<$Res> {
  factory _$AiInsightRecordCopyWith(_AiInsightRecord value, $Res Function(_AiInsightRecord) _then) = __$AiInsightRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, double estimatedSavingInrPerMonth, String severity, int coverageDays
});




}
/// @nodoc
class __$AiInsightRecordCopyWithImpl<$Res>
    implements _$AiInsightRecordCopyWith<$Res> {
  __$AiInsightRecordCopyWithImpl(this._self, this._then);

  final _AiInsightRecord _self;
  final $Res Function(_AiInsightRecord) _then;

/// Create a copy of AiInsightRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? estimatedSavingInrPerMonth = null,Object? severity = null,Object? coverageDays = null,}) {
  return _then(_AiInsightRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,estimatedSavingInrPerMonth: null == estimatedSavingInrPerMonth ? _self.estimatedSavingInrPerMonth : estimatedSavingInrPerMonth // ignore: cast_nullable_to_non_nullable
as double,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as String,coverageDays: null == coverageDays ? _self.coverageDays : coverageDays // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
