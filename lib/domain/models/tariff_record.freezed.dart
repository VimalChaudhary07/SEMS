// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tariff_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TariffSlabRecord {

 double get fromKwh; double? get toKwh; double get rate;
/// Create a copy of TariffSlabRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffSlabRecordCopyWith<TariffSlabRecord> get copyWith => _$TariffSlabRecordCopyWithImpl<TariffSlabRecord>(this as TariffSlabRecord, _$identity);

  /// Serializes this TariffSlabRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TariffSlabRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffSlabRecord&&(identical(other.fromKwh, _this.fromKwh) || other.fromKwh == _this.fromKwh)&&(identical(other.toKwh, _this.toKwh) || other.toKwh == _this.toKwh)&&(identical(other.rate, _this.rate) || other.rate == _this.rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TariffSlabRecord;
  return Object.hash(runtimeType,_this.fromKwh,_this.toKwh,_this.rate);
}

@override
String toString() {
  final _this = this as TariffSlabRecord;
  return 'TariffSlabRecord(fromKwh: ${_this.fromKwh}, toKwh: ${_this.toKwh}, rate: ${_this.rate})';
}


}

/// @nodoc
abstract mixin class $TariffSlabRecordCopyWith<$Res>  {
  factory $TariffSlabRecordCopyWith(TariffSlabRecord value, $Res Function(TariffSlabRecord) _then) = _$TariffSlabRecordCopyWithImpl;
@useResult
$Res call({
 double fromKwh, double? toKwh, double rate
});




}
/// @nodoc
class _$TariffSlabRecordCopyWithImpl<$Res>
    implements $TariffSlabRecordCopyWith<$Res> {
  _$TariffSlabRecordCopyWithImpl(this._self, this._then);

  final TariffSlabRecord _self;
  final $Res Function(TariffSlabRecord) _then;

/// Create a copy of TariffSlabRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromKwh = null,Object? toKwh = freezed,Object? rate = null,}) {
  return _then(TariffSlabRecord(
fromKwh: null == fromKwh ? _self.fromKwh : fromKwh // ignore: cast_nullable_to_non_nullable
as double,toKwh: freezed == toKwh ? _self.toKwh : toKwh // ignore: cast_nullable_to_non_nullable
as double?,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TariffSlabRecord].
extension TariffSlabRecordPatterns on TariffSlabRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffSlabRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffSlabRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffSlabRecord value)  $default,){
final _that = this;
switch (_that) {
case _TariffSlabRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffSlabRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TariffSlabRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double fromKwh,  double? toKwh,  double rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffSlabRecord() when $default != null:
return $default(_that.fromKwh,_that.toKwh,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double fromKwh,  double? toKwh,  double rate)  $default,) {final _that = this;
switch (_that) {
case _TariffSlabRecord():
return $default(_that.fromKwh,_that.toKwh,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double fromKwh,  double? toKwh,  double rate)?  $default,) {final _that = this;
switch (_that) {
case _TariffSlabRecord() when $default != null:
return $default(_that.fromKwh,_that.toKwh,_that.rate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffSlabRecord implements TariffSlabRecord {
  const _TariffSlabRecord({required this.fromKwh, this.toKwh, required this.rate});
  factory _TariffSlabRecord.fromJson(Map<String, dynamic> json) => _$TariffSlabRecordFromJson(json);

@override final  double fromKwh;
@override final  double? toKwh;
@override final  double rate;

/// Create a copy of TariffSlabRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffSlabRecordCopyWith<_TariffSlabRecord> get copyWith => __$TariffSlabRecordCopyWithImpl<_TariffSlabRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffSlabRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffSlabRecord&&(identical(other.fromKwh, fromKwh) || other.fromKwh == fromKwh)&&(identical(other.toKwh, toKwh) || other.toKwh == toKwh)&&(identical(other.rate, rate) || other.rate == rate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fromKwh,toKwh,rate);
}

@override
String toString() {
    return 'TariffSlabRecord(fromKwh: $fromKwh, toKwh: $toKwh, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$TariffSlabRecordCopyWith<$Res> implements $TariffSlabRecordCopyWith<$Res> {
  factory _$TariffSlabRecordCopyWith(_TariffSlabRecord value, $Res Function(_TariffSlabRecord) _then) = __$TariffSlabRecordCopyWithImpl;
@override @useResult
$Res call({
 double fromKwh, double? toKwh, double rate
});




}
/// @nodoc
class __$TariffSlabRecordCopyWithImpl<$Res>
    implements _$TariffSlabRecordCopyWith<$Res> {
  __$TariffSlabRecordCopyWithImpl(this._self, this._then);

  final _TariffSlabRecord _self;
  final $Res Function(_TariffSlabRecord) _then;

/// Create a copy of TariffSlabRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromKwh = null,Object? toKwh = freezed,Object? rate = null,}) {
  return _then(_TariffSlabRecord(
fromKwh: null == fromKwh ? _self.fromKwh : fromKwh // ignore: cast_nullable_to_non_nullable
as double,toKwh: freezed == toKwh ? _self.toKwh : toKwh // ignore: cast_nullable_to_non_nullable
as double?,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TariffRecord {

 String get id; String get currency; List<TariffSlabRecord> get slabs; double get fixedCharge; double get dutyPercent; double get budget; int get billingDay;
/// Create a copy of TariffRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TariffRecordCopyWith<TariffRecord> get copyWith => _$TariffRecordCopyWithImpl<TariffRecord>(this as TariffRecord, _$identity);

  /// Serializes this TariffRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TariffRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TariffRecord&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&const DeepCollectionEquality().equals(other.slabs, _this.slabs)&&(identical(other.fixedCharge, _this.fixedCharge) || other.fixedCharge == _this.fixedCharge)&&(identical(other.dutyPercent, _this.dutyPercent) || other.dutyPercent == _this.dutyPercent)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.billingDay, _this.billingDay) || other.billingDay == _this.billingDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TariffRecord;
  return Object.hash(runtimeType,_this.id,_this.currency,const DeepCollectionEquality().hash(_this.slabs),_this.fixedCharge,_this.dutyPercent,_this.budget,_this.billingDay);
}

@override
String toString() {
  final _this = this as TariffRecord;
  return 'TariffRecord(id: ${_this.id}, currency: ${_this.currency}, slabs: ${_this.slabs}, fixedCharge: ${_this.fixedCharge}, dutyPercent: ${_this.dutyPercent}, budget: ${_this.budget}, billingDay: ${_this.billingDay})';
}


}

/// @nodoc
abstract mixin class $TariffRecordCopyWith<$Res>  {
  factory $TariffRecordCopyWith(TariffRecord value, $Res Function(TariffRecord) _then) = _$TariffRecordCopyWithImpl;
@useResult
$Res call({
 String id, String currency, List<TariffSlabRecord> slabs, double fixedCharge, double dutyPercent, double budget, int billingDay
});




}
/// @nodoc
class _$TariffRecordCopyWithImpl<$Res>
    implements $TariffRecordCopyWith<$Res> {
  _$TariffRecordCopyWithImpl(this._self, this._then);

  final TariffRecord _self;
  final $Res Function(TariffRecord) _then;

/// Create a copy of TariffRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? currency = null,Object? slabs = null,Object? fixedCharge = null,Object? dutyPercent = null,Object? budget = null,Object? billingDay = null,}) {
  return _then(TariffRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,slabs: null == slabs ? _self.slabs : slabs // ignore: cast_nullable_to_non_nullable
as List<TariffSlabRecord>,fixedCharge: null == fixedCharge ? _self.fixedCharge : fixedCharge // ignore: cast_nullable_to_non_nullable
as double,dutyPercent: null == dutyPercent ? _self.dutyPercent : dutyPercent // ignore: cast_nullable_to_non_nullable
as double,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,billingDay: null == billingDay ? _self.billingDay : billingDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TariffRecord].
extension TariffRecordPatterns on TariffRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TariffRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TariffRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TariffRecord value)  $default,){
final _that = this;
switch (_that) {
case _TariffRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TariffRecord value)?  $default,){
final _that = this;
switch (_that) {
case _TariffRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String currency,  List<TariffSlabRecord> slabs,  double fixedCharge,  double dutyPercent,  double budget,  int billingDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TariffRecord() when $default != null:
return $default(_that.id,_that.currency,_that.slabs,_that.fixedCharge,_that.dutyPercent,_that.budget,_that.billingDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String currency,  List<TariffSlabRecord> slabs,  double fixedCharge,  double dutyPercent,  double budget,  int billingDay)  $default,) {final _that = this;
switch (_that) {
case _TariffRecord():
return $default(_that.id,_that.currency,_that.slabs,_that.fixedCharge,_that.dutyPercent,_that.budget,_that.billingDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String currency,  List<TariffSlabRecord> slabs,  double fixedCharge,  double dutyPercent,  double budget,  int billingDay)?  $default,) {final _that = this;
switch (_that) {
case _TariffRecord() when $default != null:
return $default(_that.id,_that.currency,_that.slabs,_that.fixedCharge,_that.dutyPercent,_that.budget,_that.billingDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TariffRecord implements TariffRecord {
  const _TariffRecord({required this.id, this.currency = 'INR',  List<TariffSlabRecord> slabs = const <TariffSlabRecord>[], this.fixedCharge = 0, this.dutyPercent = 0, this.budget = 0, this.billingDay = 1}): _slabs = slabs;
  factory _TariffRecord.fromJson(Map<String, dynamic> json) => _$TariffRecordFromJson(json);

@override final  String id;
@override@JsonKey() final  String currency;
 final  List<TariffSlabRecord> _slabs;
@override@JsonKey() List<TariffSlabRecord> get slabs {
  if (_slabs is EqualUnmodifiableListView) return _slabs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_slabs);
}

@override@JsonKey() final  double fixedCharge;
@override@JsonKey() final  double dutyPercent;
@override@JsonKey() final  double budget;
@override@JsonKey() final  int billingDay;

/// Create a copy of TariffRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TariffRecordCopyWith<_TariffRecord> get copyWith => __$TariffRecordCopyWithImpl<_TariffRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TariffRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TariffRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.slabs, _slabs)&&(identical(other.fixedCharge, fixedCharge) || other.fixedCharge == fixedCharge)&&(identical(other.dutyPercent, dutyPercent) || other.dutyPercent == dutyPercent)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.billingDay, billingDay) || other.billingDay == billingDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,currency,const DeepCollectionEquality().hash(_slabs),fixedCharge,dutyPercent,budget,billingDay);
}

@override
String toString() {
    return 'TariffRecord(id: $id, currency: $currency, slabs: $slabs, fixedCharge: $fixedCharge, dutyPercent: $dutyPercent, budget: $budget, billingDay: $billingDay)';
}


}

/// @nodoc
abstract mixin class _$TariffRecordCopyWith<$Res> implements $TariffRecordCopyWith<$Res> {
  factory _$TariffRecordCopyWith(_TariffRecord value, $Res Function(_TariffRecord) _then) = __$TariffRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String currency, List<TariffSlabRecord> slabs, double fixedCharge, double dutyPercent, double budget, int billingDay
});




}
/// @nodoc
class __$TariffRecordCopyWithImpl<$Res>
    implements _$TariffRecordCopyWith<$Res> {
  __$TariffRecordCopyWithImpl(this._self, this._then);

  final _TariffRecord _self;
  final $Res Function(_TariffRecord) _then;

/// Create a copy of TariffRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? currency = null,Object? slabs = null,Object? fixedCharge = null,Object? dutyPercent = null,Object? budget = null,Object? billingDay = null,}) {
  return _then(_TariffRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,slabs: null == slabs ? _self._slabs : slabs // ignore: cast_nullable_to_non_nullable
as List<TariffSlabRecord>,fixedCharge: null == fixedCharge ? _self.fixedCharge : fixedCharge // ignore: cast_nullable_to_non_nullable
as double,dutyPercent: null == dutyPercent ? _self.dutyPercent : dutyPercent // ignore: cast_nullable_to_non_nullable
as double,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,billingDay: null == billingDay ? _self.billingDay : billingDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
