// Calculates session energy from cumulative meter readings without mixing scopes.
double sessionEnergyKwh({
  required double startMeterKwh,
  required double currentMeterKwh,
}) {
  if (!startMeterKwh.isFinite ||
      !currentMeterKwh.isFinite ||
      startMeterKwh < 0 ||
      currentMeterKwh < 0 ||
      currentMeterKwh < startMeterKwh) {
    throw ArgumentError(
      'Meter readings must be finite, non-negative, and non-decreasing.',
    );
  }
  return currentMeterKwh - startMeterKwh;
}
