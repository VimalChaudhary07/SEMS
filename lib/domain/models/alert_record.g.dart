// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlertRecord _$AlertRecordFromJson(Map<String, dynamic> json) => _AlertRecord(
  id: json['id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  time: json['time'] as String,
  severity: json['severity'] as String? ?? 'info',
  category: json['category'] as String? ?? 'energy',
  device: json['device'] as String? ?? '',
  acknowledged: json['acknowledged'] as bool? ?? false,
);

Map<String, dynamic> _$AlertRecordToJson(_AlertRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'time': instance.time,
      'severity': instance.severity,
      'category': instance.category,
      'device': instance.device,
      'acknowledged': instance.acknowledged,
    };
