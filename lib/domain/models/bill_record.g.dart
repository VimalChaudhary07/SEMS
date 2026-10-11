// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BillRecord _$BillRecordFromJson(Map<String, dynamic> json) => _BillRecord(
  id: json['id'] as String,
  period: json['period'] as String,
  energyKwh: (json['energyKwh'] as num).toDouble(),
  amount: (json['amount'] as num).toDouble(),
  effectiveRate: (json['effectiveRate'] as num?)?.toDouble(),
  status: json['status'] as String? ?? 'billed',
);

Map<String, dynamic> _$BillRecordToJson(_BillRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'period': instance.period,
      'energyKwh': instance.energyKwh,
      'amount': instance.amount,
      'effectiveRate': instance.effectiveRate,
      'status': instance.status,
    };
