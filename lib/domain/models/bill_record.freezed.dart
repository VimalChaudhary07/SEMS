// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillRecord {

 String get id; String get period; double get energyKwh; double get amount; double? get effectiveRate; String get status;
/// Create a copy of BillRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BillRecordCopyWith<BillRecord> get copyWith => _$BillRecordCopyWithImpl<BillRecord>(this as BillRecord, _$identity);

  /// Serializes this BillRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BillRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BillRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.period, _this.period) || other.period == _this.period)&&(identical(other.energyKwh, _this.energyKwh) || other.energyKwh == _this.energyKwh)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.effectiveRate, _this.effectiveRate) || other.effectiveRate == _this.effectiveRate)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BillRecord;
  return Object.hash(runtimeType,_this.id,_this.period,_this.energyKwh,_this.amount,_this.effectiveRate,_this.status);
}

@override
String toString() {
  final _this = this as BillRecord;
  return 'BillRecord(id: ${_this.id}, period: ${_this.period}, energyKwh: ${_this.energyKwh}, amount: ${_this.amount}, effectiveRate: ${_this.effectiveRate}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $BillRecordCopyWith<$Res>  {
  factory $BillRecordCopyWith(BillRecord value, $Res Function(BillRecord) _then) = _$BillRecordCopyWithImpl;
@useResult
$Res call({
 String id, String period, double energyKwh, double amount, double? effectiveRate, String status
});




}
/// @nodoc
class _$BillRecordCopyWithImpl<$Res>
    implements $BillRecordCopyWith<$Res> {
  _$BillRecordCopyWithImpl(this._self, this._then);

  final BillRecord _self;
  final $Res Function(BillRecord) _then;

/// Create a copy of BillRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? period = null,Object? energyKwh = null,Object? amount = null,Object? effectiveRate = freezed,Object? status = null,}) {
  return _then(BillRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,effectiveRate: freezed == effectiveRate ? _self.effectiveRate : effectiveRate // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BillRecord].
extension BillRecordPatterns on BillRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BillRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BillRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BillRecord value)  $default,){
final _that = this;
switch (_that) {
case _BillRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BillRecord value)?  $default,){
final _that = this;
switch (_that) {
case _BillRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String period,  double energyKwh,  double amount,  double? effectiveRate,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BillRecord() when $default != null:
return $default(_that.id,_that.period,_that.energyKwh,_that.amount,_that.effectiveRate,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String period,  double energyKwh,  double amount,  double? effectiveRate,  String status)  $default,) {final _that = this;
switch (_that) {
case _BillRecord():
return $default(_that.id,_that.period,_that.energyKwh,_that.amount,_that.effectiveRate,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String period,  double energyKwh,  double amount,  double? effectiveRate,  String status)?  $default,) {final _that = this;
switch (_that) {
case _BillRecord() when $default != null:
return $default(_that.id,_that.period,_that.energyKwh,_that.amount,_that.effectiveRate,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BillRecord implements BillRecord {
  const _BillRecord({required this.id, required this.period, required this.energyKwh, required this.amount, this.effectiveRate, this.status = 'billed'});
  factory _BillRecord.fromJson(Map<String, dynamic> json) => _$BillRecordFromJson(json);

@override final  String id;
@override final  String period;
@override final  double energyKwh;
@override final  double amount;
@override final  double? effectiveRate;
@override@JsonKey() final  String status;

/// Create a copy of BillRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BillRecordCopyWith<_BillRecord> get copyWith => __$BillRecordCopyWithImpl<_BillRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BillRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BillRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.period, period) || other.period == period)&&(identical(other.energyKwh, energyKwh) || other.energyKwh == energyKwh)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.effectiveRate, effectiveRate) || other.effectiveRate == effectiveRate)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,period,energyKwh,amount,effectiveRate,status);
}

@override
String toString() {
    return 'BillRecord(id: $id, period: $period, energyKwh: $energyKwh, amount: $amount, effectiveRate: $effectiveRate, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BillRecordCopyWith<$Res> implements $BillRecordCopyWith<$Res> {
  factory _$BillRecordCopyWith(_BillRecord value, $Res Function(_BillRecord) _then) = __$BillRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String period, double energyKwh, double amount, double? effectiveRate, String status
});




}
/// @nodoc
class __$BillRecordCopyWithImpl<$Res>
    implements _$BillRecordCopyWith<$Res> {
  __$BillRecordCopyWithImpl(this._self, this._then);

  final _BillRecord _self;
  final $Res Function(_BillRecord) _then;

/// Create a copy of BillRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? period = null,Object? energyKwh = null,Object? amount = null,Object? effectiveRate = freezed,Object? status = null,}) {
  return _then(_BillRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,energyKwh: null == energyKwh ? _self.energyKwh : energyKwh // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,effectiveRate: freezed == effectiveRate ? _self.effectiveRate : effectiveRate // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
