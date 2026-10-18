// Adapts the persisted local mock repositories to the existing SEMS UI contract.
import '../../core/services/clock.dart';
import '../../core/services/id_generator.dart';
import '../../domain/models/json_record.dart';
import '../../domain/models/command_progress.dart';
import '../../domain/models/socket_device.dart';
import '../../domain/models/schedule_record.dart';
import '../../domain/models/bill_record.dart';
import '../../domain/models/tariff_record.dart';
import '../../domain/services/qr_claim_service.dart';
import '../../domain/services/qr_claim_validator.dart';
import '../../data/simulators/command_simulator.dart';
import '../../domain/usecases/move_appliance.dart';
import '../models/sems_models.dart';
import '../repositories/sems_repository.dart';
import 'mock_json_repository.dart';

class DriftSemsRepository implements SemsRepository {
  DriftSemsRepository._({
    required this._repositories,
    required this._devices,
    required this._appliances,
    required this._weeklyReadings,
    required this._hourlyReadings,
    required this._minuteReadings,
    required this._tenSecondReadings,
    required this._dailyReadings,
    required this._monthlyReadings,
    required this._alerts,
    required this._recommendations,
    required this._bills,
    required this._tariff,
    required this.coverageDays,
    required this._pendingClaimCode,
    required this._idGenerator,
    required this._clock,
  });

  static Future<DriftSemsRepository> load({
    required MockRepositories repositories,
    IdGenerator idGenerator = const _RepositoryIdGenerator(),
    Clock clock = const SystemClock(),
  }) async {
    final sockets = await repositories.sockets.getAll();
    final history = await repositories.telemetry.getAll();
    final historySummary = await repositories.history.getById(
      'history-summary-current',
    );
    final historySeries = await repositories.history.getById(
      'history-series-current',
    );
    final appliances = await repositories.appliances.getAll();
    final sessions = await repositories.sessions.getAll();
    final alertRecords = await repositories.alerts.getAll();
    final insightRecords = await repositories.ai.getAll();
    final billRecords = await repositories.bills.getAll();
    final tariffRecord = await repositories.tariffsData.getById(
      'tariff-current',
    );
    final latestTelemetry = <String, JsonRecord>{};
    for (final sample in history) {
      final deviceId = sample.data['device_id'];
      if (deviceId is String) latestTelemetry[deviceId] = sample;
    }
    final activeSessions = <String, JsonRecord>{};
    for (final session in sessions) {
      final applianceId = session.data['applianceId'];
      if (applianceId is String && session.data['endedAt'] == null) {
        activeSessions[applianceId] = session;
      }
    }
    final applianceNames = {
      for (final appliance in appliances)
        appliance.id: appliance.data['name'] as String? ?? appliance.id,
    };
    final weeklyValues = historySummary?.data['weeklyKwh'];
    return DriftSemsRepository._(
      repositories: repositories,
      devices: sockets
          .where((record) => record.data['status'] != 'unclaimed')
          .map(
            (record) => SemsDevice(
              id: record.id,
              name: record.data['name'] as String? ?? record.id,
              room: record.data['room'] as String? ?? '',
              appliance:
                  applianceNames[record.data['applianceId']] ??
                  _applianceName(record.data['applianceId'] as String?),
              watts: _number(record.data['powerW']).round(),
              todayKwh: _number(record.data['todayKwh']),
              isOn: record.data['relay'] == true,
              online: record.data['status'] == 'online',
              voltageV: _telemetryValue(
                latestTelemetry[record.id],
                'voltage_v',
              ),
              currentA: _telemetryValue(
                latestTelemetry[record.id],
                'current_a',
              ),
              frequencyHz: _telemetryValue(
                latestTelemetry[record.id],
                'frequency_hz',
              ),
              powerFactor: _telemetryValue(
                latestTelemetry[record.id],
                'power_factor',
              ),
              sessionKwh: _sessionKwh(
                activeSessions[record.data['applianceId']],
                record.data['meterKwh'],
              ),
              meterKwh: _number(record.data['meterKwh']),
              signalDbm: record.data['signalDbm'] is num
                  ? (record.data['signalDbm'] as num).round()
                  : null,
              lastSeenMinutes:
                  (record.data['lastSeenMinutes'] as num?)?.round() ?? 0,
              safetyTrip: record.data['safetyTrip'] == true,
              tripReason: record.data['tripReason'] as String?,
              tripSecondsRemaining:
                  (record.data['tripSecondsRemaining'] as num?)?.round(),
              safetyLimits: SemsSafetyLimits.fromJson(
                record.data['safetyLimits'],
              ),
            ),
          )
          .toList(growable: true),
      appliances: appliances
          .map(
            (record) => _mapAppliance(
              record,
              sockets: sockets,
              activeSession: activeSessions[record.id],
            ),
          )
          .toList(growable: true),
      weeklyReadings: weeklyValues is List
          ? [
              for (var index = 0; index < weeklyValues.length; index++)
                EnergyReading(
                  const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index % 7],
                  _number(weeklyValues[index]),
                ),
            ]
          : _weeklyFromTelemetry(history),
      hourlyReadings: _readings(historySummary, 'hourlyKwh', 'h'),
      minuteReadings: _readings(historySeries, 'minuteKwh', 'm'),
      tenSecondReadings: _readings(historySeries, 'tenSecondKwh', 's'),
      dailyReadings: _readings(historySeries, 'dailyKwh', 'd'),
      monthlyReadings: _readings(historySeries, 'monthlyKwh', 'Week '),
      alerts: alertRecords.map(_mapAlert).toList(growable: false),
      recommendations: insightRecords
          .map(_mapRecommendation)
          .toList(growable: false),
      bills: billRecords,
      tariff:
          tariffRecord ??
          const TariffRecord(
            id: 'tariff-current',
            slabs: [
              TariffSlabRecord(fromKwh: 0, toKwh: 100, rate: 6),
              TariffSlabRecord(fromKwh: 100, toKwh: 200, rate: 8),
              TariffSlabRecord(fromKwh: 200, rate: 9.5),
            ],
            fixedCharge: 120,
            dutyPercent: 2,
            budget: 1900,
            billingDay: 1,
          ),
      coverageDays: _number(historySummary?.data['coverageDays']).round(),
      pendingClaimCode: _firstClaimCode(sockets),
      idGenerator: idGenerator,
      clock: clock,
    );
  }

  final MockRepositories _repositories;
  final List<SemsDevice> _devices;
  final List<SemsAppliance> _appliances;
  final List<EnergyReading> _weeklyReadings;
  final List<EnergyReading> _hourlyReadings;
  final List<EnergyReading> _minuteReadings;
  final List<EnergyReading> _tenSecondReadings;
  final List<EnergyReading> _dailyReadings;
  final List<EnergyReading> _monthlyReadings;
  final List<SemsAlert> _alerts;
  final List<EnergyRecommendation> _recommendations;
  final List<BillRecord> _bills;
  TariffRecord _tariff;
  final IdGenerator _idGenerator;
  final Clock _clock;
  String? _pendingClaimCode;

  @override
  final int coverageDays;

  @override
  String? get pendingClaimCode => _pendingClaimCode;

  @override
  Future<QrClaimStatus> validateClaimCode(String claimCode) =>
      QrClaimService(identities: _repositories.developerIdentities)
          .validate(claimCode);

  @override
  List<SemsDevice> get devices => List.unmodifiable(_devices);

  @override
  List<SemsAppliance> get appliances => List.unmodifiable(_appliances);

  @override
  List<EnergyReading> get weeklyReadings => List.unmodifiable(_weeklyReadings);
  @override
  List<EnergyReading> get hourlyReadings => List.unmodifiable(_hourlyReadings);
  @override
  List<EnergyReading> get minuteReadings => List.unmodifiable(_minuteReadings);
  @override
  List<EnergyReading> get tenSecondReadings =>
      List.unmodifiable(_tenSecondReadings);
  @override
  List<EnergyReading> get dailyReadings => List.unmodifiable(_dailyReadings);
  @override
  List<EnergyReading> get monthlyReadings =>
      List.unmodifiable(_monthlyReadings);

  @override
  List<SemsAlert> get alerts => List.unmodifiable(_alerts);

  @override
  List<EnergyRecommendation> get recommendations =>
      List.unmodifiable(_recommendations);

  @override
  List<BillRecord> get bills => List.unmodifiable(_bills);

  @override
  TariffRecord get tariff => _tariff;

  @override
  Future<void> saveBill(BillRecord bill) async {
    await _repositories.bills.put(bill, id: bill.id);
    _bills.insert(0, bill);
  }

  @override
  Future<void> saveTariff(TariffRecord value) async {
    await _repositories.tariffsData.put(value, id: value.id);
    _tariff = value;
  }

  @override
  Future<void> setDeviceState(String id, bool isOn) async {
    final device = _findDevice(id);
    if (!device.online) {
      throw StateError('Cannot control offline socket "$id".');
    }
    final record = await _repositories.sockets.getById(id);
    if (record == null) throw StateError('Unknown socket "$id".');
    if (isOn && record.data['safetyTrip'] == true) {
      throw StateError(
        record.data['tripReason'] as String? ??
            'Socket is blocked by a safety trip.',
      );
    }
    final defaultWatts = device.appliance.toLowerCase().contains('heater')
        ? 2200
        : device.appliance.toLowerCase().contains('fan')
        ? 55
        : 126;
    final updated = {...record.data}
      ..['relay'] = isOn
      ..['powerW'] = isOn
          ? (device.watts == 0 ? defaultWatts : device.watts)
          : 0;
    await _repositories.sockets.put(JsonRecord(id: id, data: updated));
    _replaceDevice(
      device.copyWith(
        isOn: isOn,
        watts: isOn ? (device.watts == 0 ? defaultWatts : device.watts) : 0,
      ),
    );
    await _refreshApplianceForSocket(id);
  }

  @override
  Stream<CommandProgress> runCommand({
    required String socketId,
    required bool targetRelay,
    bool emergency = false,
  }) async* {
    final simulator = CommandSimulator(
      sockets: _repositories.sockets,
      commands: _repositories.commands,
      idGenerator: _idGenerator,
      clock: _clock,
      scenarioState: _repositories.scenarioState,
    );
    await for (final progress in simulator.run(
      socketId: socketId,
      targetRelay: targetRelay,
      emergency: emergency,
    )) {
      if (progress.state == CommandState.executed) {
        final record = await _repositories.sockets.getById(socketId);
        if (record == null) {
          throw StateError('Socket "$socketId" disappeared after command.');
        }
        final device = _findDevice(socketId);
        _replaceDevice(
          device.copyWith(
            isOn: targetRelay,
            watts: targetRelay ? _number(record.data['powerW']).round() : 0,
          ),
        );
        await _refreshApplianceForSocket(socketId);
      }
      yield progress;
    }
  }

  @override
  Future<void> addAppliance({
    required String name,
    required String category,
    int? ratedPowerW,
    String? socketId,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw ArgumentError.value(name, 'name');
    SemsDevice? selectedDevice;
    JsonRecord? selectedSocket;
    if (socketId != null) {
      selectedDevice = _findDevice(socketId);
      if (!selectedDevice.online) {
        throw StateError('Choose an online socket.');
      }
      selectedSocket = await _repositories.sockets.getById(socketId);
      if (selectedSocket == null) {
        throw StateError('Unknown socket "$socketId".');
      }
      final previousId = selectedSocket.data['applianceId'] as String?;
      if (previousId != null) {
        await _closeActiveSession(previousId, selectedSocket);
        final previous = await _repositories.appliances.getById(previousId);
        if (previous != null) {
          final detached = JsonRecord(
            id: previousId,
            data: {...previous.data, 'socketId': null},
          );
          await _repositories.appliances.put(detached);
          _replaceAppliance(_mapAppliance(detached));
        }
      }
    }

    final applianceId = _idGenerator.nextId();
    final applianceRecord = JsonRecord(
      id: applianceId,
      data: {
        'id': applianceId,
        'name': trimmedName,
        'category': category,
        'socketId': socketId,
        'room': selectedDevice?.room ?? '',
        'status': 'active',
        'ratedPowerW': ratedPowerW,
        'lifetimeKwh': 0,
        'todayKwh': 0,
      },
    );
    await _repositories.appliances.put(applianceRecord);
    JsonRecord? updatedSocket;
    JsonRecord? createdSession;
    if (socketId != null && selectedSocket != null) {
      updatedSocket = JsonRecord(
        id: socketId,
        data: {
          ...selectedSocket.data,
          'applianceId': applianceId,
          'applianceName': trimmedName,
          'relay': false,
          'powerW': 0,
        },
      );
      await _repositories.sockets.put(updatedSocket);
      final meterKwh = _number(selectedSocket.data['meterKwh']);
      final now = _clock.now().toIso8601String();
      final sessionId = _idGenerator.nextId();
      createdSession = JsonRecord(
        id: sessionId,
        data: {
          'id': sessionId,
          'applianceId': applianceId,
          'socketId': socketId,
          'startedAt': now,
          'startMeterKwh': meterKwh,
          'currentMeterKwh': meterKwh,
          'endedAt': null,
        },
      );
      await _repositories.sessions.put(createdSession);
      _replaceDevice(
        selectedDevice!.copyWith(appliance: trimmedName, isOn: false, watts: 0),
      );
    }
    _appliances.add(
      _mapAppliance(
        applianceRecord,
        sockets: [?updatedSocket],
        activeSession: createdSession,
      ),
    );
  }

  @override
  Future<void> archiveAppliance(String applianceId) async {
    final record = await _repositories.appliances.getById(applianceId);
    if (record == null) throw StateError('Unknown appliance "$applianceId".');
    final socketId = record.data['socketId'] as String?;
    if (socketId != null) {
      final socket = await _repositories.sockets.getById(socketId);
      if (socket == null) throw StateError('Unknown socket "$socketId".');
      await _closeActiveSession(applianceId, socket);
      await _repositories.sockets.put(
        JsonRecord(
          id: socketId,
          data: {
            ...socket.data,
            'applianceId': null,
            'applianceName': 'Unassigned',
            'relay': false,
            'powerW': 0,
          },
        ),
      );
      _replaceDevice(
        _findDevice(socketId)
            .copyWith(appliance: 'Unassigned', isOn: false, watts: 0),
      );
    }
    final archived = JsonRecord(
      id: applianceId,
      data: {...record.data, 'socketId': null, 'status': 'archived'},
    );
    await _repositories.appliances.put(archived);
    _replaceAppliance(_mapAppliance(archived));
  }

  @override
  Future<void> renameApplianceRecord(String applianceId, String name) async {
    final appliance = await _repositories.appliances.getById(applianceId);
    if (appliance == null) {
      throw StateError('Unknown appliance "$applianceId".');
    }
    final renamed = JsonRecord(
      id: applianceId,
      data: {...appliance.data, 'name': name.trim()},
    );
    await _repositories.appliances.put(renamed);
    final socketId = appliance.data['socketId'] as String?;
    if (socketId != null) {
      final socket = await _repositories.sockets.getById(socketId);
      if (socket == null) throw StateError('Unknown socket "$socketId".');
      await _repositories.sockets.put(
        JsonRecord(
          id: socketId,
          data: {...socket.data, 'applianceName': name.trim()},
        ),
      );
      _replaceDevice(_findDevice(socketId).copyWith(appliance: name.trim()));
    }
    final socket = socketId == null
        ? null
        : await _repositories.sockets.getById(socketId);
    final sessions = await _repositories.sessions.getAll();
    final activeSession = sessions.cast<JsonRecord?>().firstWhere(
      (session) =>
          session?.data['applianceId'] == applianceId &&
          session?.data['endedAt'] == null,
      orElse: () => null,
    );
    _replaceAppliance(
      _mapAppliance(renamed, sockets: [?socket], activeSession: activeSession),
    );
  }

  @override
  Future<void> addDevice({
    required String name,
    required String room,
    required String appliance,
  }) async {
    var id = 'SEMS-${_nextId.toString().padLeft(6, '0')}';
    while (await _repositories.sockets.getById(id) != null) {
      _nextId++;
      id = 'SEMS-${_nextId.toString().padLeft(6, '0')}';
    }
    _nextId++;
    final socket = SocketDevice(
      id: id,
      name: name,
      room: room,
      applianceId: appliance == 'Unassigned' ? null : appliance,
      status: 'online',
    );
    await _repositories.sockets.put(
      JsonRecord(id: id, data: socket.toJson().cast<String, Object?>()),
    );
    _devices.add(
      SemsDevice(
        id: id,
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
  Future<void> claimSocket({
    required String claimCode,
    required String name,
    required String room,
    required String appliance,
  }) async {
    final claimStatus = await validateClaimCode(claimCode);
    if (claimStatus != QrClaimStatus.valid) {
      throw StateError('The claim code is not available.');
    }
    final sockets = await _repositories.sockets.getAll();
    JsonRecord? socket;
    final identityRecords = await _repositories.developerIdentities.getAll();
    final identity = identityRecords.firstWhere(
      (record) => record.data['claimCode'] == claimCode,
    );
    for (final candidate in sockets) {
      if (candidate.id == identity.data['socketId'] &&
          candidate.data['status'] == 'unclaimed') {
        socket = candidate;
        break;
      }
    }
    if (socket == null) throw StateError('No unclaimed socket is available.');
    await _repositories.sockets.put(
      JsonRecord(
        id: socket.id,
        data: {
          ...socket.data,
          'name': name,
          'room': room,
          'applianceId': appliance,
          'applianceName': appliance,
          'status': 'online',
          'claimCode': null,
        },
      ),
    );
    await _repositories.developerIdentities.put(
      JsonRecord(
        id: identity.id,
        data: {...identity.data, 'status': 'claimed'},
      ),
    );
    _pendingClaimCode = null;
    _devices.add(
      SemsDevice(
        id: socket.id,
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
  Future<void> saveSafetyLimits(String id, SemsSafetyLimits limits) async {
    final device = _findDevice(id);
    final socket = await _repositories.sockets.getById(id);
    if (socket == null) throw StateError('Unknown socket "$id".');
    await _repositories.sockets.put(
      JsonRecord(
        id: id,
        data: {...socket.data, 'safetyLimits': limits.toJson()},
      ),
    );
    _replaceDevice(device.copyWith(safetyLimits: limits));
  }

  var _nextId = 1;

  @override
  Future<void> renameAppliance(String id, String name) async {
    final device = _findDevice(id);
    final applianceId = await _applianceId(id);
    if (applianceId != null) {
      final appliance = await _repositories.appliances.getById(applianceId);
      if (appliance != null) {
        await _repositories.appliances.put(
          JsonRecord(id: applianceId, data: {...appliance.data, 'name': name}),
        );
      }
    }
    final socket = await _repositories.sockets.getById(id);
    if (socket == null) throw StateError('Unknown socket "$id".');
    await _repositories.sockets.put(
      JsonRecord(id: id, data: {...socket.data, 'applianceName': name}),
    );
    _replaceDevice(device.copyWith(appliance: name));
    await _refreshApplianceForSocket(id);
  }

  @override
  Future<void> renameDevice(String id, String name) async {
    final device = _findDevice(id);
    final socket = await _repositories.sockets.getById(id);
    if (socket == null) throw StateError('Unknown socket "$id".');
    await _repositories.sockets.put(
      JsonRecord(id: id, data: {...socket.data, 'name': name}),
    );
    _replaceDevice(device.copyWith(name: name));
  }

  @override
  Future<void> assignRoom(String id, String room) async {
    final device = _findDevice(id);
    final socket = await _repositories.sockets.getById(id);
    if (socket == null) throw StateError('Unknown socket "$id".');
    await _repositories.sockets.put(
      JsonRecord(id: id, data: {...socket.data, 'room': room}),
    );
    _replaceDevice(device.copyWith(room: room));
    final applianceId = socket.data['applianceId'] as String?;
    if (applianceId != null) {
      final appliance = await _repositories.appliances.getById(applianceId);
      if (appliance != null) {
        await _repositories.appliances.put(
          JsonRecord(id: applianceId, data: {...appliance.data, 'room': room}),
        );
      }
      await _refreshApplianceForSocket(id);
    }
  }

  @override
  Future<void> removeDevice(String id) async {
    _findDevice(id);
    await _repositories.sockets.delete(id);
    _devices.removeWhere((device) => device.id == id);
  }

  @override
  Future<void> moveAppliance(String fromId, String toId) async {
    if (fromId == toId) {
      throw StateError('Choose a different destination socket.');
    }
    final source = _findDevice(fromId);
    final destination = _findDevice(toId);
    final applianceId = await _applianceId(fromId);
    if (applianceId == null) {
      throw StateError('The source socket has no assigned appliance.');
    }
    final move = MoveAppliance(
      sessions: _repositories.sessions,
      appliances: _repositories.appliances,
      sockets: _repositories.sockets,
      idGenerator: _idGenerator,
      clock: _clock,
    );
    await move(applianceId: applianceId, destinationSocketId: toId);
    final sourceRecord = await _repositories.sockets.getById(fromId);
    final destinationRecord = await _repositories.sockets.getById(toId);
    if (sourceRecord == null || destinationRecord == null) {
      throw StateError('A socket disappeared while moving the appliance.');
    }
    final moved = await _repositories.appliances.getById(applianceId);
    if (moved == null) {
      throw StateError('Appliance "$applianceId" disappeared while moving.');
    }
    final movedName = moved.data['name'] as String? ?? applianceId;
    await _repositories.sockets.put(
      JsonRecord(id: fromId, data: {...sourceRecord.data, 'applianceId': null}),
    );
    await _repositories.sockets.put(
      JsonRecord(
        id: toId,
        data: {
          ...destinationRecord.data,
          'applianceId': applianceId,
          'applianceName': movedName,
        },
      ),
    );
    _replaceDevice(source.copyWith(appliance: 'Unassigned'));
    _replaceDevice(destination.copyWith(appliance: movedName));
    await _refreshApplianceForSocket(toId);
    final destinationApplianceId = destinationRecord.data['applianceId'];
    final displacedId =
        destinationApplianceId is String &&
            destinationApplianceId != 'Unassigned' &&
            destinationApplianceId != applianceId
        ? destinationApplianceId
        : null;
    if (displacedId != null) {
      final displaced = await _repositories.appliances.getById(displacedId);
      if (displaced != null) {
        _replaceAppliance(_mapAppliance(displaced));
      }
    }
  }

  @override
  Future<List<ScheduleRecord>> getSchedules() =>
      _repositories.scheduleRecords.getAll();

  @override
  Future<void> saveSchedule(ScheduleRecord schedule) =>
      _repositories.scheduleRecords.put(schedule, id: schedule.id);

  @override
  Future<void> deleteSchedule(String id) =>
      _repositories.scheduleRecords.delete(id);

  @override
  Future<SchedulePauseState> getSchedulePauseState() async {
    final record = await _repositories.scheduleState.getById('global');
    final paused = record?.data['paused'] == true;
    final until = record?.data['until'];
    final date = until is String ? DateTime.tryParse(until) : null;
    return SchedulePauseState(
      paused: paused && (date == null || date.isAfter(_clock.now())),
      until: date,
    );
  }

  @override
  Future<void> pauseSchedules({Duration? duration}) async {
    final until = duration == null ? null : _clock.now().add(duration);
    await _repositories.scheduleState.put(
      JsonRecord(
        id: 'global',
        data: {
          'paused': true,
          if (until != null) 'until': until.toIso8601String(),
        },
      ),
    );
  }

  @override
  Future<void> resumeSchedules() async {
    await _repositories.scheduleState.put(
      const JsonRecord(id: 'global', data: {'paused': false}),
    );
  }

  @override
  Future<bool> isScheduleClockSynced(String applianceId) async {
    final appliance = await _repositories.appliances.getById(applianceId);
    final socketId = appliance?.data['socketId'];
    if (socketId is! String) return false;
    final socket = await _repositories.sockets.getById(socketId);
    return socket?.data['clockSynced'] != false;
  }

  @override
  Future<void> acknowledgeAlert(String id) async {
    final record = await _repositories.alerts.getById(id);
    if (record == null) throw StateError('Unknown alert "$id".');
    await _repositories.alerts.put(
      JsonRecord(id: id, data: {...record.data, 'acknowledged': true}),
    );
    final index = _alerts.indexWhere((alert) => alert.id == id);
    if (index < 0) throw StateError('Unknown alert "$id".');
    final alert = _alerts[index];
    _alerts[index] = SemsAlert(
      id: alert.id,
      title: alert.title,
      message: alert.message,
      time: alert.time,
      severity: alert.severity,
      category: alert.category,
      device: alert.device,
      note: alert.note,
      acknowledged: true,
    );
  }

  @override
  Future<AlertPreferences> getAlertPreferences() async {
    final record = await _repositories.alertPreferences.getById('preferences');
    return record == null
        ? const AlertPreferences()
        : AlertPreferences.fromJson(record.data.cast<String, dynamic>());
  }

  @override
  Future<void> saveAlertPreferences(AlertPreferences preferences) =>
      _repositories.alertPreferences.put(
        JsonRecord(
          id: 'preferences',
          data: preferences.toJson().cast<String, Object?>(),
        ),
      );

  SemsDevice _findDevice(String id) {
    for (final device in _devices) {
      if (device.id == id) return device;
    }
    throw StateError('Unknown socket "$id".');
  }

  Future<String?> _applianceId(String socketId) async {
    final socket = await _repositories.sockets.getById(socketId);
    return socket?.data['applianceId'] as String?;
  }

  void _replaceDevice(SemsDevice device) {
    final index = _devices.indexWhere((item) => item.id == device.id);
    if (index < 0) throw StateError('Unknown socket "${device.id}".');
    _devices[index] = device;
  }

  void _replaceAppliance(SemsAppliance appliance) {
    final index = _appliances.indexWhere((item) => item.id == appliance.id);
    if (index < 0) {
      _appliances.add(appliance);
    } else {
      _appliances[index] = appliance;
    }
  }

  Future<void> _refreshApplianceForSocket(String socketId) async {
    final socket = await _repositories.sockets.getById(socketId);
    final applianceId = socket?.data['applianceId'] as String?;
    if (socket == null || applianceId == null) return;
    final appliance = await _repositories.appliances.getById(applianceId);
    if (appliance == null) {
      throw StateError('Socket "$socketId" references an unknown appliance.');
    }
    final sessions = await _repositories.sessions.getAll();
    JsonRecord? activeSession;
    for (final session in sessions) {
      if (session.data['applianceId'] == applianceId &&
          session.data['endedAt'] == null) {
        if (activeSession != null) {
          throw StateError(
            'Appliance "$applianceId" has multiple active sessions.',
          );
        }
        activeSession = session;
      }
    }
    _replaceAppliance(
      _mapAppliance(appliance, sockets: [socket], activeSession: activeSession),
    );
  }

  Future<void> _closeActiveSession(
    String applianceId,
    JsonRecord socket,
  ) async {
    final active = (await _repositories.sessions.getAll()).where(
      (session) =>
          session.data['applianceId'] == applianceId &&
          session.data['endedAt'] == null,
    );
    if (active.length > 1) {
      throw StateError(
        'Appliance "$applianceId" has multiple active sessions.',
      );
    }
    if (active.isEmpty) {
      return;
    }
    final session = active.single;
    await _repositories.sessions.put(
      JsonRecord(
        id: session.id,
        data: {
          ...session.data,
          'currentMeterKwh': _number(socket.data['meterKwh']),
          'endedAt': _clock.now().toIso8601String(),
        },
      ),
    );
  }

  static SemsAppliance _mapAppliance(
    JsonRecord record, {
    List<JsonRecord> sockets = const [],
    JsonRecord? activeSession,
  }) {
    final socketId = record.data['socketId'] as String?;
    JsonRecord? socket;
    for (final candidate in sockets) {
      if (candidate.id == socketId) {
        socket = candidate;
        break;
      }
    }
    return SemsAppliance(
      id: record.id,
      name: record.data['name'] as String? ?? record.id,
      room: record.data['room'] as String? ?? '',
      status: record.data['status'] as String? ?? 'active',
      category: record.data['category'] as String? ?? 'Other',
      socketId: socketId,
      ratedPowerW: (record.data['ratedPowerW'] as num?)?.round(),
      watts: _number(socket?.data['powerW']).round(),
      todayKwh: _number(record.data['todayKwh']),
      lifetimeKwh: _number(record.data['lifetimeKwh']),
      online: socket?.data['status'] == 'online',
      meterKwh: socket == null ? null : _number(socket.data['meterKwh']),
      sessionKwh: activeSession == null
          ? null
          : _sessionKwh(activeSession, socket?.data['meterKwh']),
      sessionStartedAt: activeSession?.data['startedAt'] as String?,
      sessionStartMeterKwh: activeSession == null
          ? null
          : _number(activeSession.data['startMeterKwh']),
    );
  }

  static String _applianceName(String? id) {
    if (id == null) return 'Unassigned';
    return switch (id) {
      'heater' => 'Heater',
      'fan' => 'Fan',
      'refrigerator' => 'Refrigerator',
      _ => id,
    };
  }

  static double _number(Object? value) => value is num ? value.toDouble() : 0;

  static double? _telemetryValue(JsonRecord? sample, String key) {
    final value = sample?.data[key];
    return value is num ? value.toDouble() : null;
  }

  static double? _sessionKwh(JsonRecord? session, Object? currentMeter) {
    if (session == null) return null;
    final current = _number(currentMeter);
    final start = _number(session.data['startMeterKwh']);
    return current >= start ? current - start : null;
  }

  static String? _firstClaimCode(List<JsonRecord> sockets) {
    for (final socket in sockets) {
      if (socket.data['status'] == 'unclaimed') {
        final code = socket.data['claimCode'];
        if (code is String) return code;
      }
    }
    return null;
  }

  static List<EnergyReading> _weeklyFromTelemetry(List<JsonRecord> samples) =>
      samples
          .map((sample) => sample.data['powerW'])
          .whereType<num>()
          .take(7)
          .map((value) => EnergyReading('', value.toDouble() / 1000))
          .toList(growable: false);

  static List<EnergyReading> _readings(
    JsonRecord? summary,
    String key,
    String labelPrefix,
  ) {
    final values = summary?.data[key];
    if (values is! List) return const [];
    return [
      for (var index = 0; index < values.length; index++)
        if (values[index] is num)
          EnergyReading(
            labelPrefix == 'Week '
                ? '$labelPrefix${index + 1}'
                : '${index + 1}$labelPrefix',
            (values[index] as num).toDouble(),
          ),
    ];
  }

  static SemsAlert _mapAlert(JsonRecord record) {
    final severity = switch (record.data['severity']) {
      'critical' => AlertSeverity.critical,
      'warning' => AlertSeverity.warning,
      _ => AlertSeverity.info,
    };
    final category = switch (record.data['category']) {
      'electrical' => AlertCategory.electrical,
      'energy' => AlertCategory.energy,
      'connectivity' => AlertCategory.connectivity,
      'automation' || 'schedule' => AlertCategory.schedule,
      _ => AlertCategory.ai,
    };
    return SemsAlert(
      id: record.id,
      title: record.data['title'] as String? ?? '',
      message: record.data['message'] as String? ?? '',
      time: record.data['time'] as String? ?? '',
      severity: severity,
      category: category,
      device: record.data['device'] as String? ?? '',
      note: record.data['note'] as String?,
      acknowledged: record.data['acknowledged'] as bool? ?? false,
    );
  }

  static EnergyRecommendation _mapRecommendation(
    JsonRecord record,
  ) => EnergyRecommendation(
    title: record.data['title'] as String? ?? '',
    description: record.data['description'] as String? ?? '',
    saving:
        '₹${_number(record.data['estimatedSavingInrPerMonth']).round()} / month',
  );
}

class _RepositoryIdGenerator implements IdGenerator {
  const _RepositoryIdGenerator();

  @override
  String nextId() => DateTime.now().microsecondsSinceEpoch.toRadixString(36);
}
