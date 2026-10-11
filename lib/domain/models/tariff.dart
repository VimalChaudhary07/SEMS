import 'dart:math' as math;

// Represents the local tariff slabs used by bill estimates.
class TariffSlab {
  const TariffSlab({
    required this.fromKwh,
    required this.ratePerKwh,
    this.toKwh,
  });

  final double fromKwh;
  final double? toKwh;
  final double ratePerKwh;
}

class Tariff {
  const Tariff({
    required this.slabs,
    required this.fixedCharge,
    required this.dutyPercent,
    required this.budget,
  });

  final List<TariffSlab> slabs;
  final double fixedCharge;
  final double dutyPercent;
  final double budget;
}

class BillEstimate {
  const BillEstimate({
    required this.energyCharges,
    required this.fixedCharge,
    required this.duty,
    required this.total,
  });

  final double energyCharges;
  final double fixedCharge;
  final double duty;
  final double total;
}

BillEstimate estimateBill({required double energyKwh, required Tariff tariff}) {
  if (!energyKwh.isFinite || energyKwh < 0) {
    throw ArgumentError.value(energyKwh, 'energyKwh', 'Must be non-negative.');
  }
  if (!tariff.dutyPercent.isFinite || tariff.dutyPercent < 0) {
    throw ArgumentError.value(
      tariff.dutyPercent,
      'dutyPercent',
      'Must be non-negative.',
    );
  }
  if (!tariff.fixedCharge.isFinite || tariff.fixedCharge < 0) {
    throw ArgumentError.value(
      tariff.fixedCharge,
      'fixedCharge',
      'Must be non-negative.',
    );
  }
  if (!tariff.budget.isFinite || tariff.budget < 0) {
    throw ArgumentError.value(tariff.budget, 'budget', 'Must be non-negative.');
  }
  final slabs = [...tariff.slabs]
    ..sort((a, b) => a.fromKwh.compareTo(b.fromKwh));
  if (slabs.isEmpty || slabs.first.fromKwh != 0) {
    throw ArgumentError.value(
      tariff.slabs,
      'slabs',
      'Must start at 0 kWh and include at least one slab.',
    );
  }
  for (var i = 0; i < slabs.length; i++) {
    final slab = slabs[i];
    if (!slab.fromKwh.isFinite ||
        !slab.ratePerKwh.isFinite ||
        slab.ratePerKwh < 0 ||
        (slab.toKwh != null &&
            (!slab.toKwh!.isFinite || slab.toKwh! <= slab.fromKwh))) {
      throw ArgumentError.value(slab, 'slabs', 'Contains an invalid slab.');
    }
    if (i < slabs.length - 1 &&
        (slab.toKwh == null || slab.toKwh != slabs[i + 1].fromKwh)) {
      throw ArgumentError.value(
        tariff.slabs,
        'slabs',
        'Slabs must be contiguous and ordered.',
      );
    }
    if (i == slabs.length - 1 && slab.toKwh != null) {
      throw ArgumentError.value(
        slab.toKwh,
        'toKwh',
        'The final slab must have no upper limit.',
      );
    }
  }
  var energyCharges = 0.0;
  for (var i = 0; i < slabs.length; i++) {
    final slab = slabs[i];
    final end =
        slab.toKwh ?? (i + 1 < slabs.length ? slabs[i + 1].fromKwh : energyKwh);
    final used = math.max(0, math.min(energyKwh, end) - slab.fromKwh);
    energyCharges += used * slab.ratePerKwh;
  }
  final subtotal = energyCharges + tariff.fixedCharge;
  final duty = subtotal * tariff.dutyPercent / 100;
  return BillEstimate(
    energyCharges: energyCharges,
    fixedCharge: tariff.fixedCharge,
    duty: duty,
    total: subtotal + duty,
  );
}
