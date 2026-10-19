class SemsDevice {
  const SemsDevice({
    required this.id,
    required this.name,
    required this.room,
    required this.appliance,
    required this.watts,
    required this.todayKwh,
    required this.isOn,
    this.online = true,
    this.voltageV,
    this.currentA,
    this.frequencyHz,
    this.powerFactor,
    this.sessionKwh,
    this.meterKwh = 0,
    this.signalDbm,
    this.lastSeenMinutes = 0,
    this.safetyTrip = false,
    this.tripReason,
    this.tripSecondsRemaining,
    this.safetyLimits = const SemsSafetyLimits(),
  });
  final String id;
  final String name;
  final String room;
  final String appliance;
  final int watts;
  final double todayKwh;
  final bool isOn;
  final bool online;
  final double? voltageV;
  final double? currentA;
  final double? frequencyHz;
  final double? powerFactor;
  final double? sessionKwh;
  final double meterKwh;
  final int? signalDbm;
  final int lastSeenMinutes;
  final bool safetyTrip;
  final String? tripReason;
  final int? tripSecondsRemaining;
  final SemsSafetyLimits safetyLimits;

  SemsDevice copyWith({
    bool? isOn,
    String? appliance,
    String? room,
    int? watts,
    String? name,
    bool? safetyTrip,
    String? tripReason,
    int? tripSecondsRemaining,
    SemsSafetyLimits? safetyLimits,
  }) => SemsDevice(
    id: id,
    name: name ?? this.name,
    room: room ?? this.room,
    appliance: appliance ?? this.appliance,
    watts: watts ?? this.watts,
    todayKwh: todayKwh,
    isOn: isOn ?? this.isOn,
    online: online,
    voltageV: voltageV,
    currentA: currentA,
    frequencyHz: frequencyHz,
    powerFactor: powerFactor,
    sessionKwh: sessionKwh,
    meterKwh: meterKwh,
    signalDbm: signalDbm,
    lastSeenMinutes: lastSeenMinutes,
    safetyTrip: safetyTrip ?? this.safetyTrip,
    tripReason: tripReason ?? this.tripReason,
    tripSecondsRemaining: tripSecondsRemaining ?? this.tripSecondsRemaining,
    safetyLimits: safetyLimits ?? this.safetyLimits,
  );
}

class SemsSafetyLimits {
  const SemsSafetyLimits({
    this.maxCurrentA = 16,
    this.maxPowerW = 3680,
    this.minVoltageV = 200,
    this.maxVoltageV = 250,
  });

  final double maxCurrentA;
  final double maxPowerW;
  final double minVoltageV;
  final double maxVoltageV;

  Map<String, Object> toJson() => {
    'maxCurrentA': maxCurrentA,
    'maxPowerW': maxPowerW,
    'minVoltageV': minVoltageV,
    'maxVoltageV': maxVoltageV,
  };

  factory SemsSafetyLimits.fromJson(Object? value) {
    if (value is! Map) return const SemsSafetyLimits();
    return SemsSafetyLimits(
      maxCurrentA: _number(value['maxCurrentA'], 16),
      maxPowerW: _number(value['maxPowerW'], 3680),
      minVoltageV: _number(value['minVoltageV'], 200),
      maxVoltageV: _number(value['maxVoltageV'], 250),
    );
  }

  static double _number(Object? value, double fallback) =>
      value is num ? value.toDouble() : fallback;
}

class SemsAppliance {
  const SemsAppliance({
    required this.id,
    required this.name,
    required this.room,
    required this.status,
    required this.todayKwh,
    required this.lifetimeKwh,
    this.category = 'Other',
    this.socketId,
    this.ratedPowerW,
    this.watts = 0,
    this.online = false,
    this.meterKwh,
    this.sessionKwh,
    this.sessionStartedAt,
    this.sessionEndedAt,
    this.sessionStartMeterKwh,
  });

  final String id;
  final String name;
  final String room;
  final String status;
  final String category;
  final String? socketId;
  final int? ratedPowerW;
  final int watts;
  final double todayKwh;
  final double lifetimeKwh;
  final bool online;
  final double? meterKwh;
  final double? sessionKwh;
  final String? sessionStartedAt;
  final String? sessionEndedAt;
  final double? sessionStartMeterKwh;

  bool get archived => status == 'archived';
}

class EnergyReading {
  const EnergyReading(this.label, this.kwh);
  final String label;
  final double kwh;
}

enum AlertSeverity { critical, warning, info }

enum AlertCategory { electrical, energy, connectivity, schedule, ai }

class SemsAlert {
  const SemsAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.severity,
    required this.category,
    required this.device,
    this.note,
    this.nextAction,
    this.seenNote,
    this.badgeLabel,
    this.whatHappened,
    this.whatToDoNext,
    this.occurredAt,
    this.receivedAt,
    this.secondaryActionLabel,
    this.acknowledged = false,
  });
  final String id;
  final String title;
  final String message;
  final String time;
  final AlertSeverity severity;
  final AlertCategory category;
  final String device;
  final String? note;
  final String? nextAction;
  final String? seenNote;
  final String? badgeLabel;
  final String? whatHappened;
  final String? whatToDoNext;
  final String? occurredAt;
  final String? receivedAt;
  final String? secondaryActionLabel;
  final bool acknowledged;
}

class EnergyRecommendation {
  const EnergyRecommendation({
    required this.title,
    required this.description,
    required this.saving,
  });
  final String title;
  final String description;
  final String saving;
}
