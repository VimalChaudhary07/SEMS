// Verifies the local Drift seed, mock scenarios, and simulator behavior.
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/services/clock.dart';
import 'package:sems/core/services/id_generator.dart';
import 'package:sems/data/local/mock_database.dart';
import 'package:sems/data/mock/mock_data_store.dart';
import 'package:sems/data/mock/mock_scenario.dart';
import 'package:sems/data/mock/drift_sems_repository.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/data/simulators/backup_simulator.dart';
import 'package:sems/data/simulators/command_simulator.dart';
import 'package:sems/data/simulators/pairing_simulator.dart';
import 'package:sems/data/simulators/telemetry_simulator.dart';
import 'package:sems/domain/models/ai_coverage.dart';
import 'package:sems/domain/models/command_progress.dart';
import 'package:sems/domain/models/json_record.dart';
import 'package:sems/domain/models/schedule_window.dart';
import 'package:sems/domain/models/schedule_record.dart';
import 'package:sems/domain/models/simulation_results.dart';
import 'package:sems/domain/models/tariff.dart';
import 'package:sems/domain/models/tariff_record.dart';
import 'package:sems/domain/services/ai_engine.dart';
import 'package:sems/domain/services/qr_claim_service.dart';
import 'package:sems/domain/usecases/merge_backup.dart';
import 'package:sems/domain/usecases/move_appliance.dart';
import 'package:sems/domain/usecases/session_energy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDatabase database;
  late MockDataStore store;

  setUp(() {
    database = MockDatabase(executor: NativeDatabase.memory());
    store = MockDataStore(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'seeds each JSON collection once and preserves repository updates',
    () async {
      expect(await store.seeder.seedIfNeeded(), isTrue);
      expect(await store.seeder.seedIfNeeded(), isFalse);
      expect((await store.repositories.auth.getAll()).length, 2);
      expect((await store.repositories.sockets.getAll()).length, 4);
      expect(
        (await store.repositories.users.getById('owner'))!.name,
        'Asha Verma',
      );

      expect(
        (await store.repositories.socketDevices.getById('SEMS-000001'))!.powerW,
        2200,
      );
      expect(
        (await store.repositories.energySessions.getById(
          'session-heater-active',
        ))!.sessionKwh,
        closeTo(4.2, 0.001),
      );
      expect(
        (await store.repositories.tariffsData.getById('tariff-default'))!
            .slabs
            .length,
        3,
      );
      expect(
        (await store.repositories.applianceRecords.getById('heater'))!
            .lifetimeKwh,
        14.2,
      );
      expect(
        (await store.repositories.scheduleRecords.getById(
          'schedule-night-fan',
        ))!.overnight,
        isTrue,
      );
      expect(
        (await store.repositories.alertRecords.getById('alert-overcurrent'))!
            .severity,
        'critical',
      );
      expect(
        (await store.repositories.bills.getById('bill-2026-09'))!.amount,
        1860,
      );
      expect(
        (await store.repositories.aiInsights.getById('insight-standby'))!
            .estimatedSavingInrPerMonth,
        120,
      );
      expect(
        (await store.repositories.identities.getById('identity-demo-socket-4'))!
            .status,
        'unclaimed',
      );
      expect(
        (await store.repositories.telemetrySamples.getById(
          'sample-2026-10-11-001',
        ))!.energyKwh,
        150,
      );
      expect(
        (await store.repositories.backupRecords.getById('drive-status'))!
            .connected,
        isFalse,
      );
      expect(
        (await store.repositories.familyMembers.getById('family'))!.role,
        'family',
      );
      expect(
        (await store.repositories.appSettings.getById('preferences'))!
            .telemetryRetentionDays,
        90,
      );

      await store.repositories.sockets.put(
        const JsonRecord(
          id: 'SEMS-000002',
          data: {'id': 'SEMS-000002', 'room': 'Study'},
        ),
      );
      expect(
        (await store.repositories.sockets.getById('SEMS-000002'))!.data['room'],
        'Study',
      );
    },
  );

  test(
    'schedules and pause state persist in local Drift repositories',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );
      const schedule = ScheduleRecord(
        id: 'schedule-test',
        name: 'Morning and evening',
        applianceId: 'heater',
        socketId: 'SEMS-000001',
        startTime: '06:00',
        endTime: '08:00',
        days: ['monday', 'tuesday'],
        intervals: [
          ScheduleInterval(startTime: '06:00', endTime: '08:00'),
          ScheduleInterval(startTime: '18:00', endTime: '22:00'),
        ],
        kind: 'multipleIntervals',
        manualOverride: 'stayOverridden',
      );
      await repository.saveSchedule(schedule);
      final saved = (await repository.getSchedules()).singleWhere(
        (item) => item.id == schedule.id,
      );
      expect(saved.intervals, schedule.intervals);
      expect(saved.manualOverride, 'stayOverridden');

      const countdown = ScheduleRecord(
        id: 'schedule-countdown-test',
        name: 'Short boost',
        applianceId: 'heater',
        socketId: 'SEMS-000001',
        startTime: '00:00',
        endTime: '00:00',
        countdownMinutes: 30,
        countdownEndsAt: '2026-10-12T18:30:00.000',
        countdownState: 'running',
        kind: 'countdown',
      );
      await repository.saveSchedule(countdown);
      final savedCountdown = (await repository.getSchedules()).singleWhere(
        (item) => item.id == countdown.id,
      );
      expect(savedCountdown.countdownEndsAt, countdown.countdownEndsAt);
      expect(savedCountdown.countdownState, 'running');

      await repository.pauseSchedules(duration: const Duration(days: 3));
      final pause = await repository.getSchedulePauseState();
      expect(pause.paused, isTrue);
      expect(pause.until, isNotNull);

      final socket = await store.repositories.sockets.getById('SEMS-000003');
      await store.repositories.sockets.put(
        JsonRecord(
          id: socket!.id,
          data: {...socket.data, 'clockSynced': false},
        ),
      );
      expect(await repository.isScheduleClockSynced('refrigerator'), isFalse);

      await repository.resumeSchedules();
      expect((await repository.getSchedulePauseState()).paused, isFalse);
      await repository.deleteSchedule(schedule.id);
      await repository.deleteSchedule(countdown.id);
      expect(
        (await repository.getSchedules()).any((item) => item.id == schedule.id),
        isFalse,
      );
    },
  );

  test(
    'seed upgrades add new examples without replacing local edits',
    () async {
      await store.seeder.seedIfNeeded();
      final heater = await store.repositories.appliances.getById('heater');
      await store.repositories.appliances.put(
        JsonRecord(
          id: 'heater',
          data: {...heater!.data, 'name': 'Locally renamed heater'},
        ),
      );
      await store.repositories.appliances.delete('water-heater');
      await database
          .into(database.mockRecords)
          .insertOnConflictUpdate(
            MockRecordsCompanion.insert(
              collection: '_meta',
              recordId: 'seedVersion',
              payload: '1',
            ),
          );

      expect(await store.seeder.seedIfNeeded(), isTrue);
      expect(
        (await store.repositories.appliances.getById('heater'))!.data['name'],
        'Locally renamed heater',
      );
      expect(
        (await store.repositories.appliances.getById('water-heater'))!
            .data['status'],
        'archived',
      );
    },
  );

  test('scenario activation resets then applies the selected preset', () async {
    await store.seeder.seedIfNeeded();
    final scenarios = MockScenarioController(database);
    await scenarios.activate(MockScenario.safetyTrip);

    final socket = await store.repositories.sockets.getById('SEMS-000001');
    expect(socket!.data['safetyTrip'], isTrue);
    expect(socket.data['powerW'], 0);
    expect((await store.repositories.sockets.getAll()).length, 4);
  });

  test(
    'all catalog scenarios can be activated and reset one another',
    () async {
      for (final scenario in MockScenario.values) {
        await store.scenarios.activate(scenario);
      }
      expect(
        (await store.repositories.scenarioState.getById('activeUser'))!
            .data['value'],
        'owner',
      );
      expect((await store.repositories.sockets.getAll()).length, 4);
    },
  );

  test('move appliance closes old session at current meter and opens one new session', () async {
    await store.seeder.seedIfNeeded();
    final move = MoveAppliance(
      sessions: store.repositories.sessions,
      appliances: store.repositories.appliances,
      sockets: store.repositories.sockets,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
    );

    await move(applianceId: 'heater', destinationSocketId: 'SEMS-000002');

    final sessions = await store.repositories.sessions.getAll();
    final heaterSessions = sessions.where(
      (session) => session.data['applianceId'] == 'heater',
    );
    expect(heaterSessions.length, 2);
    expect(
      heaterSessions
          .singleWhere((session) => session.data['endedAt'] != null)
          .data['currentMeterKwh'],
      150.0,
    );
    expect(
      heaterSessions
          .singleWhere((session) => session.data['endedAt'] == null)
          .data['socketId'],
      'SEMS-000002',
    );
    expect(
      (await store.repositories.appliances.getById('heater'))!.data['socketId'],
      'SEMS-000002',
    );
    final fanSessions = sessions.where(
      (session) => session.data['applianceId'] == 'fan',
    );
    expect(fanSessions, hasLength(1));
    expect(
      fanSessions
          .singleWhere((session) => session.data['endedAt'] != null)
          .data['currentMeterKwh'],
      80.9,
    );
    expect(
      (await store.repositories.appliances.getById('fan'))!.data['socketId'],
      isNull,
    );
  });

  test('command lifecycle changes socket state only after execution', () async {
    await store.seeder.seedIfNeeded();
    final simulator = CommandSimulator(
      sockets: store.repositories.sockets,
      commands: store.repositories.commands,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
      stepDelay: Duration.zero,
    );
    final events = await simulator
        .run(socketId: 'SEMS-000001', targetRelay: false)
        .toList();

    expect(events.map((event) => event.state), [
      CommandState.pending,
      CommandState.acknowledged,
      CommandState.executed,
    ]);
    expect(
      (await store.repositories.sockets.getById('SEMS-000001'))!.data['relay'],
      isFalse,
    );
  });

  test('emergency OFF is persisted as a high-priority local command', () async {
    await store.seeder.seedIfNeeded();
    final simulator = CommandSimulator(
      sockets: store.repositories.sockets,
      commands: store.repositories.commands,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
      stepDelay: Duration.zero,
    );

    final events = await simulator
        .run(socketId: 'SEMS-000001', targetRelay: false, emergency: true)
        .toList();
    final command = await store.repositories.commands.getById(
      events.last.commandId,
    );

    expect(events.last.state, CommandState.executed);
    expect(command!.data['emergency'], isTrue);
    expect(command.data['priority'], 'high');
  });

  test('command failure preset drives the local command simulator', () async {
    await store.seeder.seedIfNeeded();
    await MockScenarioController(database).activate(MockScenario.commandFails);
    final simulator = CommandSimulator(
      sockets: store.repositories.sockets,
      commands: store.repositories.commands,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
      scenarioState: store.repositories.scenarioState,
      stepDelay: Duration.zero,
    );

    final events = await simulator
        .run(socketId: 'SEMS-000001', targetRelay: false)
        .toList();
    expect(events.last.state, CommandState.failed);
    expect(
      (await store.repositories.sockets.getById('SEMS-000001'))!.data['relay'],
      isTrue,
    );

    await store.scenarios.activate(MockScenario.commandExpires);
    final expired = await simulator
        .run(socketId: 'SEMS-000001', targetRelay: false)
        .toList();
    expect(expired.last.state, CommandState.expired);
  });

  test(
    'failed, expired, offline, and safety-blocked commands do not switch relay',
    () async {
      await store.seeder.seedIfNeeded();
      final simulator = CommandSimulator(
        sockets: store.repositories.sockets,
        commands: store.repositories.commands,
        idGenerator: _FixedIdGenerator(),
        clock: _FixedClock(),
        stepDelay: Duration.zero,
      );
      final failed = await simulator
          .run(
            socketId: 'SEMS-000001',
            targetRelay: false,
            mode: CommandSimulationMode.fail,
          )
          .toList();
      expect(failed.last.state, CommandState.failed);
      expect(
        (await store.repositories.sockets.getById('SEMS-000001'))!
            .data['relay'],
        isTrue,
      );

      final expired = await simulator
          .run(
            socketId: 'SEMS-000001',
            targetRelay: false,
            mode: CommandSimulationMode.expire,
          )
          .toList();
      expect(expired.last.state, CommandState.expired);
      final offline = await simulator
          .run(socketId: 'SEMS-000003', targetRelay: true)
          .toList();
      expect(offline.single.state, CommandState.failed);
      final currentSocket = await store.repositories.sockets.getById(
        'SEMS-000001',
      );
      await store.repositories.sockets.put(
        JsonRecord(
          id: 'SEMS-000001',
          data: {...currentSocket!.data, 'safetyTrip': true},
        ),
      );
      final blocked = await simulator
          .run(socketId: 'SEMS-000001', targetRelay: true)
          .toList();
      expect(blocked.last.state, CommandState.blocked);
    },
  );

  test('safety trip scenario blocks ON while keeping the relay off', () async {
    await store.seeder.seedIfNeeded();
    await MockScenarioController(database).activate(MockScenario.safetyTrip);
    final simulator = CommandSimulator(
      sockets: store.repositories.sockets,
      commands: store.repositories.commands,
      idGenerator: _FixedIdGenerator(),
      clock: _FixedClock(),
      stepDelay: Duration.zero,
    );

    final events = await simulator
        .run(socketId: 'SEMS-000001', targetRelay: true)
        .toList();
    expect(events.single.state, CommandState.blocked);
    expect(
      (await store.repositories.sockets.getById('SEMS-000001'))!.data['relay'],
      isFalse,
    );
  });

  test(
    'telemetry emits only for online sockets and persists every sample',
    () async {
      await store.seeder.seedIfNeeded();
      final simulator = TelemetrySimulator(
        sockets: store.repositories.sockets,
        telemetry: store.repositories.telemetry,
        clock: _FixedClock(),
        idGenerator: _FixedIdGenerator(),
      );

      final emitted = await simulator.emitOnce();
      expect(emitted.length, 2);
      expect(emitted.first.timestamp, DateTime.utc(2026, 10, 11, 14, 12));
      expect((await store.repositories.telemetry.getAll()).length, 4);
      await simulator.dispose();
    },
  );

  test(
    'pairing simulator exposes eight steps and all eight error cases',
    () async {
      final simulator = PairingSimulator(stepDelay: Duration.zero);
      expect(
        (await simulator.run().toList()).length,
        PairingStep.values.length,
      );
      for (final error in PairingError.values) {
        final events = await simulator.run(failAt: error).toList();
        expect(events.last.error, error);
        expect(events.length, lessThan(PairingStep.values.length + 1));
      }
    },
  );

  test(
    'pairing validates claim codes against seeded developer identities',
    () async {
      await store.seeder.seedIfNeeded();
      final simulator = PairingSimulator(
        stepDelay: Duration.zero,
        claimService: QrClaimService(
          identities: store.repositories.developerIdentities,
        ),
      );

      expect(
        (await simulator.run(claimCode: '482913').toList()).length,
        PairingStep.values.length,
      );
      final claimed = await simulator.run(claimCode: '105702').toList();
      expect(claimed.single.error, PairingError.alreadyClaimed);
      final invalid = await simulator.run(claimCode: 'no-code').toList();
      expect(invalid.single.error, PairingError.invalidQr);
    },
  );

  test(
    'backup simulation reports completion and explicit validation failures',
    () async {
      final simulator = BackupSimulator(stepDelay: Duration.zero);
      final completed = await simulator.backup(pendingCount: 2).toList();
      expect(completed.last.stage, BackupStage.complete);
      expect(completed.last.pendingCount, 0);
      final failed = await simulator
          .restore(failure: BackupError.checksumFailure)
          .toList();
      expect(failed.last.error, BackupError.checksumFailure);
    },
  );

  test('backup merge resolves conflicts, imports as new, and skips duplicate batches', () async {
    await store.seeder.seedIfNeeded();
    final merge = MergeBackup(
      repositories: {'sockets': store.repositories.sockets},
      backups: store.repositories.backup,
      schemaVersion: 1,
    );
    final batch = BackupBatch(
      batchId: 'batch-001',
      schemaVersion: 1,
      checksumValid: true,
      records: const {
        'sockets': [
          JsonRecord(
            id: 'SEMS-000001',
            data: {
              'id': 'SEMS-000001',
              'name': 'Living room socket (restored)',
            },
          ),
        ],
      },
    );
    final merged = await merge(
      batches: [batch],
      importAsNew: false,
      newId: (id, batchId) => '$id-$batchId',
      resolveConflict: (existing, incoming) => JsonRecord(
        id: existing.id,
        data: {...existing.data, 'name': incoming.data['name']},
      ),
    );
    expect(merged.conflicts, hasLength(1));
    expect(
      (await store.repositories.sockets.getById('SEMS-000001'))!.data['name'],
      'Living room socket (restored)',
    );
    final repeated = await merge(
      batches: [batch],
      importAsNew: true,
      newId: (id, batchId) => '$id-$batchId',
      resolveConflict: (_, _) => null,
    );
    expect(repeated.skippedBatches, 1);
  });

  test(
    'AI gates and bill estimator use the configured thresholds and slab rates',
    () {
      expect(aiCoverageForDays(2), AiCoverageBand.learning);
      expect(aiCoverageForDays(3), AiCoverageBand.anomalyChecks);
      expect(aiCoverageForDays(7), AiCoverageBand.forecast);
      expect(aiCoverageForDays(30), AiCoverageBand.monthlyForecast);
      expect(aiCoverageForDays(60), AiCoverageBand.patterns);

      final analysis = const AiEngine().analyze(
        coverageDays: 10,
        dailyKwh: [1, 1, 2, 3],
      );
      expect(analysis.forecastKwh, 52.5);
      expect(analysis.isEstimated, isTrue);

      final estimate = estimateBill(
        energyKwh: 232,
        tariff: const Tariff(
          slabs: [
            TariffSlab(fromKwh: 0, toKwh: 100, ratePerKwh: 6),
            TariffSlab(fromKwh: 100, toKwh: 200, ratePerKwh: 8),
            TariffSlab(fromKwh: 200, ratePerKwh: 9.5),
          ],
          fixedCharge: 120,
          dutyPercent: 2,
          budget: 1900,
        ),
      );
      expect(estimate.total, closeTo(1860.48, 0.001));
    },
  );

  test(
    'session energy rejects reset meters and typed tariff matches seed',
    () async {
      expect(
        sessionEnergyKwh(startMeterKwh: 145.8, currentMeterKwh: 150),
        closeTo(4.2, 0.001),
      );
      expect(
        () => sessionEnergyKwh(startMeterKwh: 150, currentMeterKwh: 145),
        throwsArgumentError,
      );
      await store.seeder.seedIfNeeded();
      final tariff = await store.repositories.tariffsData.getById(
        'tariff-default',
      );
      expect(
        tariff!.slabs.first,
        const TariffSlabRecord(fromKwh: 0, toKwh: 100, rate: 6),
      );
    },
  );

  test(
    'schedule validation catches same-day and overnight cross-day overlap',
    () {
      final sameDay = validateScheduleWindows([
        const ScheduleWindow(startMinute: 600, endMinute: 720, days: {1}),
        const ScheduleWindow(startMinute: 700, endMinute: 800, days: {1}),
      ]);
      expect(sameDay.isValid, isFalse);

      final overnight = validateScheduleWindows([
        const ScheduleWindow(startMinute: 1380, endMinute: 360, days: {1}),
        const ScheduleWindow(startMinute: 120, endMinute: 180, days: {2}),
      ]);
      expect(overnight.isValid, isFalse);
      expect(
        validateScheduleWindows([
          const ScheduleWindow(startMinute: 600, endMinute: 720, days: {}),
        ]).isValid,
        isFalse,
      );
    },
  );

  test('history ranges and alert preferences persist locally', () async {
    await store.seeder.seedIfNeeded();
    final repository = await DriftSemsRepository.load(
      repositories: store.repositories,
    );
    expect(repository.hourlyReadings, hasLength(24));
    expect(repository.minuteReadings, hasLength(12));
    expect(repository.tenSecondReadings, hasLength(12));
    expect(repository.dailyReadings, hasLength(24));
    expect(repository.monthlyReadings, hasLength(4));
    expect(
      repository.alerts.where((alert) => alert.category.name == 'ai'),
      hasLength(3),
    );

    await repository.acknowledgeAlert('alert-budget');
    await repository.saveAlertPreferences(
      const AlertPreferences(
        overallPowerLimitW: 3500,
        appliancePowerLimitsW: {'Heater': 2800},
        muteNonCriticalAlerts: false,
      ),
    );
    final reloaded = await DriftSemsRepository.load(
      repositories: store.repositories,
    );
    expect(
      reloaded.alerts
          .singleWhere((alert) => alert.id == 'alert-budget')
          .acknowledged,
      isTrue,
    );
    expect((await reloaded.getAlertPreferences()).overallPowerLimitW, 3500);
    expect((await store.repositories.alertPreferences.getAll()), hasLength(1));
  });
}

class _FixedIdGenerator implements IdGenerator {
  int _value = 0;

  @override
  String nextId() => 'mock-id-${_value++}';
}

class _FixedClock implements Clock {
  @override
  DateTime now() => DateTime.utc(2026, 10, 11, 14, 12);
}
