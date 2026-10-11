// Applies local deterministic coverage gates to mock energy history.
import '../models/ai_coverage.dart';

class AiAnalysis {
  const AiAnalysis({
    required this.coverage,
    required this.measuredAverageKwh,
    this.forecastKwh,
    this.anomalyCount = 0,
  });

  final AiCoverageBand coverage;
  final double? measuredAverageKwh;
  final double? forecastKwh;
  final int anomalyCount;

  bool get isEstimated => true;
}

class AiEngine {
  const AiEngine();

  AiAnalysis analyze({
    required int coverageDays,
    required List<double?> dailyKwh,
  }) {
    final coverage = aiCoverageForDays(coverageDays);
    final readings = dailyKwh.whereType<double>().where(
      (value) => value.isFinite && value >= 0,
    );
    if (coverage == AiCoverageBand.learning || readings.isEmpty) {
      return AiAnalysis(coverage: coverage, measuredAverageKwh: null);
    }
    final values = readings.toList(growable: false);
    final average = values.reduce((a, b) => a + b) / values.length;
    final anomalies = values.where((value) => value > average * 1.5).length;
    return AiAnalysis(
      coverage: coverage,
      measuredAverageKwh: average,
      forecastKwh: coverage.index >= AiCoverageBand.forecast.index
          ? average * 30
          : null,
      anomalyCount: coverage.index >= AiCoverageBand.anomalyChecks.index
          ? anomalies
          : 0,
    );
  }
}
