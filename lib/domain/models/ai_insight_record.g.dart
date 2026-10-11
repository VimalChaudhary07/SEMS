// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_insight_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiInsightRecord _$AiInsightRecordFromJson(Map<String, dynamic> json) =>
    _AiInsightRecord(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      estimatedSavingInrPerMonth:
          (json['estimatedSavingInrPerMonth'] as num?)?.toDouble() ?? 0,
      severity: json['severity'] as String? ?? 'info',
      coverageDays: (json['coverageDays'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AiInsightRecordToJson(_AiInsightRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'estimatedSavingInrPerMonth': instance.estimatedSavingInrPerMonth,
      'severity': instance.severity,
      'coverageDays': instance.coverageDays,
    };
