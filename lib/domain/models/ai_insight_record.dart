// Defines an immutable mock AI insight that always represents an estimate.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_insight_record.freezed.dart';
part 'ai_insight_record.g.dart';

@freezed
abstract class AiInsightRecord with _$AiInsightRecord {
  const factory AiInsightRecord({
    required String id,
    required String title,
    required String description,
    @Default(0) double estimatedSavingInrPerMonth,
    @Default('info') String severity,
    @Default(0) int coverageDays,
  }) = _AiInsightRecord;

  factory AiInsightRecord.fromJson(Map<String, dynamic> json) =>
      _$AiInsightRecordFromJson(json);
}
