// Classifies history coverage into the SEMS insight capability gates.
enum AiCoverageBand {
  learning,
  anomalyChecks,
  forecast,
  monthlyForecast,
  patterns,
}

AiCoverageBand aiCoverageForDays(int days) {
  if (days < 0) {
    throw ArgumentError.value(days, 'days', 'Must not be negative.');
  }
  if (days < 3) return AiCoverageBand.learning;
  if (days < 7) return AiCoverageBand.anomalyChecks;
  if (days < 30) return AiCoverageBand.forecast;
  if (days < 60) return AiCoverageBand.monthlyForecast;
  return AiCoverageBand.patterns;
}
