import '../models/sems_models.dart';
import '../../domain/services/qr_claim_validator.dart';
import '../../domain/models/command_progress.dart';
import '../../domain/models/schedule_record.dart';

class SchedulePauseState {
  const SchedulePauseState({required this.paused, this.until});

  final bool paused;
  final DateTime? until;
}

abstract interface class SemsRepository {
  int get coverageDays;
  String? get pendingClaimCode;
  Future<QrClaimStatus> validateClaimCode(String claimCode);
  List<SemsDevice> get devices;
  List<SemsAppliance> get appliances;
  List<EnergyReading> get weeklyReadings;
  List<EnergyReading> get hourlyReadings;
  List<EnergyReading> get minuteReadings;
  List<EnergyReading> get tenSecondReadings;
  List<EnergyReading> get dailyReadings;
  List<EnergyReading> get monthlyReadings;
  List<SemsAlert> get alerts;
  List<EnergyRecommendation> get recommendations;
  Future<void> setDeviceState(String id, bool isOn);
  Stream<CommandProgress> runCommand({
    required String socketId,
    required bool targetRelay,
    bool emergency = false,
  });
  Future<void> addAppliance({
    required String name,
    required String category,
    int? ratedPowerW,
    String? socketId,
  });
  Future<void> archiveAppliance(String applianceId);
  Future<void> renameApplianceRecord(String applianceId, String name);
  Future<void> addDevice({
    required String name,
    required String room,
    required String appliance,
  });
  Future<void> claimSocket({
    required String claimCode,
    required String name,
    required String room,
    required String appliance,
  });
  Future<void> saveSafetyLimits(String id, SemsSafetyLimits limits);
  Future<void> renameAppliance(String id, String name);
  Future<void> renameDevice(String id, String name);
  Future<void> assignRoom(String id, String room);
  Future<void> removeDevice(String id);
  Future<void> moveAppliance(String fromId, String toId);
  Future<List<ScheduleRecord>> getSchedules();
  Future<void> saveSchedule(ScheduleRecord schedule);
  Future<void> deleteSchedule(String id);
  Future<SchedulePauseState> getSchedulePauseState();
  Future<void> pauseSchedules({Duration? duration});
  Future<void> resumeSchedules();
  Future<bool> isScheduleClockSynced(String applianceId);
  Future<void> acknowledgeAlert(String id);
  Future<AlertPreferences> getAlertPreferences();
  Future<void> saveAlertPreferences(AlertPreferences preferences);
}

class AlertPreferences {
  const AlertPreferences({
    this.overallPowerLimitW = 3000,
    this.appliancePowerLimitsW = const {'Heater': 2600, 'Fan': 120},
    this.muteNonCriticalAlerts = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '06:00',
  });

  final int overallPowerLimitW;
  final Map<String, int> appliancePowerLimitsW;
  final bool muteNonCriticalAlerts;
  final String quietHoursStart;
  final String quietHoursEnd;

  Map<String, Object> toJson() => {
    'overallPowerLimitW': overallPowerLimitW,
    'appliancePowerLimitsW': appliancePowerLimitsW,
    'muteNonCriticalAlerts': muteNonCriticalAlerts,
    'quietHoursStart': quietHoursStart,
    'quietHoursEnd': quietHoursEnd,
  };

  factory AlertPreferences.fromJson(Map<String, dynamic> json) {
    final rawLimits = json['appliancePowerLimitsW'];
    return AlertPreferences(
      overallPowerLimitW: (json['overallPowerLimitW'] as num?)?.toInt() ?? 3000,
      appliancePowerLimitsW: rawLimits is Map
          ? {
              for (final entry in rawLimits.entries)
                if (entry.value is num)
                  entry.key.toString(): (entry.value as num).toInt(),
            }
          : const {'Heater': 2600, 'Fan': 120},
      muteNonCriticalAlerts: json['muteNonCriticalAlerts'] as bool? ?? true,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '06:00',
    );
  }
}

/// Local sample data only. Replace this implementation with an API/MQTT-backed
/// repository when the SEMS services are available.
class MockSemsRepository implements SemsRepository {
  MockSemsRepository({this.coverageDays = 45, bool empty = false})
    : _devices = empty
          ? <SemsDevice>[]
          : [
              const SemsDevice(
                id: 'SEMS-000001',
                name: 'Living room socket',
                room: 'Living room',
                appliance: 'Heater',
                watts: 2200,
                todayKwh: 3.1,
                isOn: true,
              ),
              const SemsDevice(
                id: 'SEMS-000002',
                name: 'Bedroom socket',
                room: 'Bedroom',
                appliance: 'Fan',
                watts: 55,
                todayKwh: 0.6,
                isOn: true,
              ),
              const SemsDevice(
                id: 'SEMS-000003',
                name: 'Kitchen socket',
                room: 'Kitchen',
                appliance: 'Refrigerator',
                watts: 0,
                todayKwh: 1.2,
                isOn: false,
                online: false,
              ),
            ],
      _appliances = _initialAppliances(empty),
      _schedules = _initialSchedules(empty);
  final List<ScheduleRecord> _schedules;

  static List<ScheduleRecord> _initialSchedules(bool empty) => empty
      ? <ScheduleRecord>[]
      : [
          const ScheduleRecord(
            id: 'schedule-evening-heater',
            name: 'Evening heater',
            applianceId: 'heater',
            socketId: 'SEMS-000001',
            startTime: '18:00',
            endTime: '22:00',
            days: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'],
            kind: 'weekly',
          ),
          const ScheduleRecord(
            id: 'schedule-night-fan',
            name: 'Night fan',
            applianceId: 'fan',
            socketId: 'SEMS-000002',
            startTime: '23:00',
            endTime: '06:00',
            days: [
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday',
              'sunday',
            ],
            kind: 'weekly',
            overnight: true,
          ),
        ];
  SchedulePauseState _schedulePause = const SchedulePauseState(paused: false);
  final List<SemsAppliance> _appliances;

  static List<SemsAppliance> _initialAppliances(bool empty) => empty
      ? <SemsAppliance>[]
      : [
          const SemsAppliance(
            id: 'heater',
            name: 'Heater',
            room: 'Living room',
            status: 'active',
            category: 'Heater',
            socketId: 'SEMS-000001',
            ratedPowerW: 2200,
            watts: 2200,
            todayKwh: 3.1,
            lifetimeKwh: 14.2,
            online: true,
            meterKwh: 150,
            sessionKwh: 4.2,
            sessionStartedAt: 'Yesterday 22:41',
            sessionStartMeterKwh: 145.8,
          ),
          const SemsAppliance(
            id: 'fan',
            name: 'Fan',
            room: 'Bedroom',
            status: 'active',
            category: 'Fan',
            socketId: 'SEMS-000002',
            ratedPowerW: 55,
            watts: 55,
            todayKwh: 0.6,
            lifetimeKwh: 28.6,
            online: true,
            meterKwh: 80.9,
            sessionKwh: 0.6,
            sessionStartedAt: 'Today 13:00',
            sessionStartMeterKwh: 80.3,
          ),
          const SemsAppliance(
            id: 'refrigerator',
            name: 'Refrigerator',
            room: 'Kitchen',
            status: 'active',
            category: 'Refrigerator',
            socketId: 'SEMS-000003',
            ratedPowerW: 126,
            todayKwh: 1.2,
            lifetimeKwh: 74.1,
            online: false,
            meterKwh: 490.2,
          ),
          const SemsAppliance(
            id: 'water-heater',
            name: 'Water heater',
            room: '',
            status: 'archived',
            category: 'Heater',
            todayKwh: 0,
            lifetimeKwh: 35.8,
          ),
        ];

  @override
  final int coverageDays;
  String? _pendingClaimCode = '482913';
  @override
  String? get pendingClaimCode => _pendingClaimCode;
  final List<SemsDevice> _devices;
  int _nextId = 4;

  @override
  List<SemsDevice> get devices => List.unmodifiable(_devices);
  @override
  List<SemsAppliance> get appliances => List.unmodifiable(_appliances);
  @override
  List<EnergyReading> get weeklyReadings => const [
    EnergyReading('M', 4.1),
    EnergyReading('T', 3.4),
    EnergyReading('W', 5.2),
    EnergyReading('T', 4.6),
    EnergyReading('F', 3.8),
    EnergyReading('S', 5.8),
    EnergyReading('S', 4.9),
  ];
  @override
  List<EnergyReading> get hourlyReadings => const [
    EnergyReading('20h', .42),
    EnergyReading('21h', .48),
    EnergyReading('22h', .23),
    EnergyReading('23h', .19),
    EnergyReading('00h', .08),
    EnergyReading('01h', .07),
    EnergyReading('02h', .08),
    EnergyReading('03h', .09),
    EnergyReading('04h', .08),
    EnergyReading('05h', .21),
    EnergyReading('06h', .18),
    EnergyReading('07h', .25),
    EnergyReading('08h', .28),
    EnergyReading('09h', .23),
    EnergyReading('10h', .19),
    EnergyReading('11h', .22),
    EnergyReading('12h', .20),
    EnergyReading('13h', .18),
    EnergyReading('14h', .31),
    EnergyReading('15h', .27),
    EnergyReading('16h', .24),
    EnergyReading('17h', .32),
    EnergyReading('18h', .51),
    EnergyReading('19h', .36),
  ];
  @override
  List<EnergyReading> get minuteReadings => const [
    EnergyReading('1m', .012),
    EnergyReading('2m', .014),
    EnergyReading('3m', .010),
    EnergyReading('4m', .016),
    EnergyReading('5m', .011),
    EnergyReading('6m', .009),
    EnergyReading('7m', .014),
    EnergyReading('8m', .013),
    EnergyReading('9m', .012),
    EnergyReading('10m', .015),
    EnergyReading('11m', .011),
    EnergyReading('12m', .010),
  ];
  @override
  List<EnergyReading> get tenSecondReadings => const [
    EnergyReading('10s', .003),
    EnergyReading('20s', .004),
    EnergyReading('30s', .002),
    EnergyReading('40s', .004),
    EnergyReading('50s', .003),
    EnergyReading('60s', .003),
    EnergyReading('70s', .004),
    EnergyReading('80s', .003),
    EnergyReading('90s', .002),
    EnergyReading('100s', .004),
    EnergyReading('110s', .003),
    EnergyReading('120s', .003),
  ];
  @override
  List<EnergyReading> get dailyReadings => weeklyReadings;
  @override
  List<EnergyReading> get monthlyReadings => const [
    EnergyReading('Week 1', 28.4),
    EnergyReading('Week 2', 30.1),
    EnergyReading('Week 3', 27.8),
    EnergyReading('Week 4', 31.2),
  ];
  @override
  List<SemsAlert> get alerts => List.unmodifiable(_alerts);
  final List<SemsAlert> _alerts = [
    SemsAlert(
      id: 'alert-1',
      title: 'Over-current at SEMS-000001',
      message: 'Current reached 16.4 A, above the 16 A safety limit. The socket switched the heater OFF to protect the wiring.',
      time: 'Today 18:15',
      severity: AlertSeverity.critical,
      category: AlertCategory.electrical,
      device: 'Living room · Heater',
    ),
    SemsAlert(
      id: 'alert-2',
      title: 'Monthly budget 80% used',
      message: 'Estimated bill reached ₹1,500 of your ₹1,900 monthly budget with 11 days left.',
      time: 'Today 15:40',
      severity: AlertSeverity.warning,
      category: AlertCategory.energy,
      device: 'All appliances',
    ),
    SemsAlert(
      id: 'alert-3',
      title: 'SEMS-000003 is offline',
      message: 'No telemetry for 14 minutes. The socket may have lost Wi-Fi. Local safety and schedules continue.',
      time: 'Today 18:30',
      severity: AlertSeverity.warning,
      category: AlertCategory.connectivity,
      device: 'Kitchen · Refrigerator',
      acknowledged: false,
    ),
    SemsAlert(
      id: 'alert-4',
      title: 'Schedule "Night fan" executed',
      message: 'Weekly schedule switched the fan OFF at 06:00 as planned.',
      time: 'Today 13:40',
      severity: AlertSeverity.info,
      category: AlertCategory.schedule,
      device: 'Bedroom · Fan',
      acknowledged: true,
    ),
    const SemsAlert(
      id: 'alert-ai-1',
      title: 'Heater usage is higher than usual',
      message: 'Estimated usage is 18% above your recent pattern. This is an AI estimate, not a measured fault.',
      time: 'Today 12:05',
      severity: AlertSeverity.info,
      category: AlertCategory.ai,
      device: 'Living room · Heater',
    ),
    const SemsAlert(
      id: 'alert-ai-2',
      title: 'Fan may be left running',
      message: 'The fan has been on longer than its usual weekday pattern.',
      time: 'Yesterday 21:10',
      severity: AlertSeverity.info,
      category: AlertCategory.ai,
      device: 'Bedroom · Fan',
    ),
    const SemsAlert(
      id: 'alert-ai-3',
      title: 'Monthly use estimate updated',
      message: 'Your estimated monthly energy use is based on available local readings.',
      time: 'Yesterday 18:00',
      severity: AlertSeverity.info,
      category: AlertCategory.ai,
      device: 'All appliances',
    ),
  ];
  @override
  List<EnergyRecommendation> get recommendations => const [
    EnergyRecommendation(
      title: 'Reduce standby usage',
      description: 'Turn off the television plug when you are away.',
      saving: '₹120 / month',
    ),
    EnergyRecommendation(
      title: 'Shift cooling hours',
      description: 'Run cooling before the evening peak to reduce costs.',
      saving: '₹85 / month',
    ),
  ];
  AlertPreferences _alertPreferences = const AlertPreferences();

  @override
  Future<void> acknowledgeAlert(String id) async {
    final index = _alerts.indexWhere((alert) => alert.id == id);
    if (index == -1) throw StateError('Unknown alert "$id".');
    final alert = _alerts[index];
    _alerts[index] = SemsAlert(
      id: alert.id,
      title: alert.title,
      message: alert.message,
      time: alert.time,
      severity: alert.severity,
      category: alert.category,
      device: alert.device,
      acknowledged: true,
    );
  }

  @override
  Future<AlertPreferences> getAlertPreferences() async => _alertPreferences;

  @override
  Future<void> saveAlertPreferences(AlertPreferences preferences) async {
    _alertPreferences = preferences;
  }

  @override
  Future<void> setDeviceState(String id, bool isOn) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index >= 0) {
      final device = _devices[index];
      final defaultWatts = device.appliance.toLowerCase().contains('heater')
          ? 2200
          : device.appliance.toLowerCase().contains('fan')
          ? 55
          : 126;
      _devices[index] = device.copyWith(
        isOn: isOn,
        watts: isOn ? (device.watts == 0 ? defaultWatts : device.watts) : 0,
      );
    }
  }

  @override
  Stream<CommandProgress> runCommand({
    required String socketId,
    required bool targetRelay,
    bool emergency = false,
  }) async* {
    final device = _devices.where((item) => item.id == socketId);
    if (device.isEmpty) throw StateError('Unknown socket "$socketId".');
    if (!device.single.online) {
      yield CommandProgress(
        commandId: 'mock-command',
        socketId: socketId,
        targetRelay: targetRelay,
        state: CommandState.failed,
        message: 'Socket is offline.',
      );
      return;
    }
    if (targetRelay && device.single.safetyTrip) {
      yield CommandProgress(
        commandId: 'mock-command',
        socketId: socketId,
        targetRelay: true,
        state: CommandState.blocked,
        message: device.single.tripReason ?? 'Blocked by a safety limit.',
      );
      return;
    }
    yield CommandProgress(
      commandId: 'mock-command',
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.pending,
      message: 'Control locked until the socket confirms.',
    );
    yield CommandProgress(
      commandId: 'mock-command',
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.acknowledged,
    );
    await setDeviceState(socketId, targetRelay);
    yield CommandProgress(
      commandId: 'mock-command',
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.executed,
    );
  }

  @override
  Future<void> addAppliance({
    required String name,
    required String category,
    int? ratedPowerW,
    String? socketId,
  }) async {
    final id = 'appliance-${_nextId++}';
    if (socketId != null) {
      final selected = _devices.indexWhere((device) => device.id == socketId);
      if (selected < 0 || !_devices[selected].online) {
        throw StateError('Choose an online socket.');
      }
      for (var index = 0; index < _appliances.length; index++) {
        if (_appliances[index].socketId == socketId &&
            !_appliances[index].archived) {
          _appliances[index] = SemsAppliance(
            id: _appliances[index].id,
            name: _appliances[index].name,
            room: _appliances[index].room,
            status: 'active',
            todayKwh: _appliances[index].todayKwh,
            lifetimeKwh: _appliances[index].lifetimeKwh,
          );
        }
      }
      _devices[selected] = _devices[selected].copyWith(
        appliance: name,
        watts: 0,
        isOn: false,
      );
    }
    _appliances.add(
      SemsAppliance(
        id: id,
        name: name,
        room: socketId == null
            ? ''
            : _devices.firstWhere((device) => device.id == socketId).room,
        status: 'active',
        category: category,
        socketId: socketId,
        ratedPowerW: ratedPowerW,
        todayKwh: 0,
        lifetimeKwh: 0,
        online: socketId != null,
      ),
    );
  }

  @override
  Future<void> archiveAppliance(String applianceId) async {
    final index = _appliances.indexWhere((item) => item.id == applianceId);
    if (index < 0) throw StateError('Unknown appliance "$applianceId".');
    final appliance = _appliances[index];
    _appliances[index] = SemsAppliance(
      id: appliance.id,
      name: appliance.name,
      room: appliance.room,
      status: 'archived',
      category: appliance.category,
      todayKwh: appliance.todayKwh,
      lifetimeKwh: appliance.lifetimeKwh,
      ratedPowerW: appliance.ratedPowerW,
    );
    final socketId = appliance.socketId;
    if (socketId != null) {
      final deviceIndex = _devices.indexWhere(
        (device) => device.id == socketId,
      );
      if (deviceIndex >= 0) {
        _devices[deviceIndex] = _devices[deviceIndex].copyWith(
          appliance: 'Unassigned',
          isOn: false,
          watts: 0,
        );
      }
    }
  }

  @override
  Future<void> renameApplianceRecord(String applianceId, String name) async {
    final index = _appliances.indexWhere((item) => item.id == applianceId);
    if (index < 0) throw StateError('Unknown appliance "$applianceId".');
    final appliance = _appliances[index];
    _appliances[index] = SemsAppliance(
      id: appliance.id,
      name: name.trim(),
      room: appliance.room,
      status: appliance.status,
      category: appliance.category,
      socketId: appliance.socketId,
      ratedPowerW: appliance.ratedPowerW,
      watts: appliance.watts,
      todayKwh: appliance.todayKwh,
      lifetimeKwh: appliance.lifetimeKwh,
      online: appliance.online,
      meterKwh: appliance.meterKwh,
      sessionKwh: appliance.sessionKwh,
      sessionStartedAt: appliance.sessionStartedAt,
      sessionStartMeterKwh: appliance.sessionStartMeterKwh,
    );
    final socketId = appliance.socketId;
    if (socketId != null) {
      final deviceIndex = _devices.indexWhere(
        (device) => device.id == socketId,
      );
      if (deviceIndex >= 0) {
        _devices[deviceIndex] = _devices[deviceIndex].copyWith(
          appliance: name.trim(),
        );
      }
    }
  }

  @override
  Future<void> addDevice({
    required String name,
    required String room,
    required String appliance,
  }) async {
    _devices.add(
      SemsDevice(
        id: 'SEMS-${(_nextId++).toString().padLeft(6, '0')}',
        name: name,
        room: room,
        appliance: appliance,
        watts: 0,
        todayKwh: 0,
        isOn: false,
      ),
    );
  }

  @override
  Future<QrClaimStatus> validateClaimCode(String claimCode) async {
    if (claimCode != _pendingClaimCode) {
      return QrClaimStatus.invalidQr;
    }
    return QrClaimStatus.valid;
  }

  @override
  Future<void> claimSocket({
    required String claimCode,
    required String name,
    required String room,
    required String appliance,
  }) async {
    final status = await validateClaimCode(claimCode);
    if (status != QrClaimStatus.valid) {
      throw StateError('The claim code is not available.');
    }
    await addDevice(name: name, room: room, appliance: appliance);
    _pendingClaimCode = null;
  }

  @override
  Future<void> saveSafetyLimits(String id, SemsSafetyLimits limits) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index < 0) throw StateError('Unknown socket "$id".');
    _devices[index] = _devices[index].copyWith(safetyLimits: limits);
  }

  @override
  Future<void> renameAppliance(String id, String name) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index >= 0) _devices[index] = _devices[index].copyWith(appliance: name);
  }

  @override
  Future<void> renameDevice(String id, String name) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index >= 0) _devices[index] = _devices[index].copyWith(name: name);
  }

  @override
  Future<void> assignRoom(String id, String room) async {
    final index = _devices.indexWhere((device) => device.id == id);
    if (index >= 0) _devices[index] = _devices[index].copyWith(room: room);
  }

  @override
  Future<void> removeDevice(String id) async {
    _devices.removeWhere((device) => device.id == id);
  }

  @override
  Future<void> moveAppliance(String fromId, String toId) async {
    final from = _devices.indexWhere((device) => device.id == fromId);
    final to = _devices.indexWhere((device) => device.id == toId);
    if (from < 0 || to < 0) throw StateError('Unknown socket.');
    if (fromId == toId) {
      throw StateError('Choose a different destination socket.');
    }
    if (!_devices[to].online) {
      throw StateError('Destination socket is offline.');
    }
    final applianceName = _devices[from].appliance;
    final movedIndex = _appliances.indexWhere(
      (item) => item.socketId == fromId && !item.archived,
    );
    if (movedIndex < 0) {
      throw StateError('The source socket has no assigned appliance.');
    }
    final destinationIndex = _appliances.indexWhere(
      (item) => item.socketId == toId && !item.archived,
    );
    if (destinationIndex >= 0) {
      final displaced = _appliances[destinationIndex];
      _appliances[destinationIndex] = SemsAppliance(
        id: displaced.id,
        name: displaced.name,
        room: displaced.room,
        status: displaced.status,
        category: displaced.category,
        ratedPowerW: displaced.ratedPowerW,
        todayKwh: displaced.todayKwh,
        lifetimeKwh: displaced.lifetimeKwh,
      );
    }
    final moved = _appliances[movedIndex];
    _appliances[movedIndex] = SemsAppliance(
      id: moved.id,
      name: moved.name,
      room: _devices[to].room,
      status: moved.status,
      category: moved.category,
      socketId: toId,
      ratedPowerW: moved.ratedPowerW,
      watts: _devices[to].watts,
      todayKwh: moved.todayKwh,
      lifetimeKwh: moved.lifetimeKwh,
      online: true,
      meterKwh: _devices[to].meterKwh,
      sessionKwh: 0,
      sessionStartedAt: 'Just now',
      sessionStartMeterKwh: _devices[to].meterKwh,
    );
    _devices[from] = _devices[from].copyWith(appliance: 'Unassigned');
    _devices[to] = _devices[to].copyWith(appliance: applianceName);
  }

  @override
  Future<List<ScheduleRecord>> getSchedules() async =>
      List.unmodifiable(_schedules);

  @override
  Future<void> saveSchedule(ScheduleRecord schedule) async {
    final index = _schedules.indexWhere((item) => item.id == schedule.id);
    if (index == -1) {
      _schedules.add(schedule);
    } else {
      _schedules[index] = schedule;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    _schedules.removeWhere((schedule) => schedule.id == id);
  }

  @override
  Future<SchedulePauseState> getSchedulePauseState() async => _schedulePause;

  @override
  Future<void> pauseSchedules({Duration? duration}) async {
    _schedulePause = SchedulePauseState(
      paused: true,
      until: duration == null ? null : DateTime.now().add(duration),
    );
  }

  @override
  Future<void> resumeSchedules() async {
    _schedulePause = const SchedulePauseState(paused: false);
  }

  @override
  Future<bool> isScheduleClockSynced(String applianceId) async => true;
}
