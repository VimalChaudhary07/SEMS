// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TariffSlabRecord _$TariffSlabRecordFromJson(Map<String, dynamic> json) =>
    _TariffSlabRecord(
      fromKwh: (json['fromKwh'] as num).toDouble(),
      toKwh: (json['toKwh'] as num?)?.toDouble(),
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$TariffSlabRecordToJson(_TariffSlabRecord instance) =>
    <String, dynamic>{
      'fromKwh': instance.fromKwh,
      'toKwh': instance.toKwh,
      'rate': instance.rate,
    };

_TariffRecord _$TariffRecordFromJson(Map<String, dynamic> json) =>
    _TariffRecord(
      id: json['id'] as String,
      currency: json['currency'] as String? ?? 'INR',
      slabs:
          (json['slabs'] as List<dynamic>?)
              ?.map((e) => TariffSlabRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TariffSlabRecord>[],
      fixedCharge: (json['fixedCharge'] as num?)?.toDouble() ?? 0,
      dutyPercent: (json['dutyPercent'] as num?)?.toDouble() ?? 0,
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      billingDay: (json['billingDay'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$TariffRecordToJson(_TariffRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'currency': instance.currency,
      'slabs': instance.slabs,
      'fixedCharge': instance.fixedCharge,
      'dutyPercent': instance.dutyPercent,
      'budget': instance.budget,
      'billingDay': instance.billingDay,
    };
