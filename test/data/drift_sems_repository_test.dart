import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sems/data/local/mock_database.dart';
import 'package:sems/data/models/sems_models.dart';
import 'package:sems/data/mock/drift_sems_repository.dart';
import 'package:sems/data/mock/mock_data_store.dart';
import 'package:sems/data/providers/mock_data_provider.dart';
import 'package:sems/domain/models/command_progress.dart';

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

  test('hydrates dashboard values from local seeded records', () async {
    await store.seeder.seedIfNeeded();

    final repository = await DriftSemsRepository.load(
      repositories: store.repositories,
    );

    expect(repository.coverageDays, 45);
    expect(repository.devices, hasLength(3));
    expect(repository.devices.first.name, 'Living room socket');
    expect(repository.devices.first.appliance, 'Heater');
    expect(repository.devices.first.watts, 2200);
    expect(repository.devices.first.voltageV, 230.1);
    expect(repository.devices.first.sessionKwh, closeTo(4.2, 0.001));
    expect(repository.devices.first.meterKwh, 150);
    expect(repository.devices.first.signalDbm, -48);
    expect(repository.weeklyReadings, hasLength(7));
    expect(repository.weeklyReadings.first.kwh, 4.1);
    expect(repository.alerts, isNotEmpty);
    expect(repository.recommendations, isNotEmpty);
  });

  test(
    'claims the seeded socket identity without creating a duplicate',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );

      expect(repository.pendingClaimCode, '482913');
      await repository.claimSocket(
        claimCode: repository.pendingClaimCode!,
        name: 'Office plug',
        room: 'Office',
        appliance: 'Lamp',
      );

      expect(repository.devices, hasLength(4));
      expect(
        repository.devices.map((device) => device.id).toSet(),
        hasLength(4),
      );
      expect(repository.devices.last.id, 'SEMS-000004');
      expect(repository.pendingClaimCode, isNull);
      final identity = await store.repositories.developerIdentities.getById(
        'identity-demo-socket-4',
      );
      expect(identity!.data['status'], 'claimed');
      final claimedSocket = await store.repositories.sockets.getById(
        'SEMS-000004',
      );
      expect(claimedSocket!.data['name'], 'Office plug');
      expect(claimedSocket.data['status'], 'online');

      final reloaded = await DriftSemsRepository.load(
        repositories: store.repositories,
      );
      expect(reloaded.devices, hasLength(4));
      expect(reloaded.pendingClaimCode, isNull);
    },
  );

  test(
    'rejects a claim code that does not match an available identity',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );

      await expectLater(
        repository.claimSocket(
          claimCode: '000000',
          name: 'Invalid plug',
          room: 'Office',
          appliance: 'Lamp',
        ),
        throwsStateError,
      );
      expect(repository.devices, hasLength(3));
    },
  );

  test('persists safety limits in socket data and repository state', () async {
    await store.seeder.seedIfNeeded();
    final repository = await DriftSemsRepository.load(
      repositories: store.repositories,
    );
    const limits = SemsSafetyLimits(
      maxCurrentA: 12,
      maxPowerW: 2800,
      minVoltageV: 205,
      maxVoltageV: 245,
    );

    await repository.saveSafetyLimits('SEMS-000001', limits);

    expect(
      repository.devices
          .firstWhere((device) => device.id == 'SEMS-000001')
          .safetyLimits
          .maxCurrentA,
      12,
    );
    final record = await store.repositories.sockets.getById('SEMS-000001');
    expect(
      SemsSafetyLimits.fromJson(record!.data['safetyLimits']).maxVoltageV,
      245,
    );
    final reloaded = await DriftSemsRepository.load(
      repositories: store.repositories,
    );
    expect(
      reloaded.devices
          .firstWhere((device) => device.id == 'SEMS-000001')
          .safetyLimits
          .minVoltageV,
      205,
    );
  });

  test(
    'adds and archives appliances while preserving sessions and sockets',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );
      final socketCount = repository.devices.length;

      await repository.addAppliance(
        name: 'Desk heater',
        category: 'Heater',
        ratedPowerW: 900,
        socketId: 'SEMS-000001',
      );

      final created = repository.appliances.singleWhere(
        (item) => item.name == 'Desk heater',
      );
      expect(repository.devices, hasLength(socketCount));
      expect(created.socketId, 'SEMS-000001');
      expect(created.ratedPowerW, 900);
      expect(created.sessionKwh, 0);
      expect(created.sessionStartMeterKwh, 150);
      expect(
        repository.appliances
            .singleWhere((item) => item.id == 'heater')
            .socketId,
        isNull,
      );
      final oldHeaterSession = (await store.repositories.sessions.getAll())
          .singleWhere(
            (session) =>
                session.data['applianceId'] == 'heater' &&
                session.data['endedAt'] != null,
          );
      expect(oldHeaterSession.data['currentMeterKwh'], 150);

      await repository.archiveAppliance(created.id);

      expect(
        repository.appliances
            .singleWhere((item) => item.id == created.id)
            .status,
        'archived',
      );
      expect(repository.devices, hasLength(socketCount));
      expect(
        repository.devices
            .singleWhere((device) => device.id == 'SEMS-000001')
            .appliance,
        'Unassigned',
      );
      final socket = await store.repositories.sockets.getById('SEMS-000001');
      expect(socket!.data['applianceId'], isNull);
      expect(socket.data['relay'], isFalse);
    },
  );

  test(
    'repository commands persist state and emergency priority locally',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );

      final events = await repository
          .runCommand(
            socketId: 'SEMS-000001',
            targetRelay: false,
            emergency: true,
          )
          .toList();
      final stored = await store.repositories.commands.getById(
        events.last.commandId,
      );

      expect(events.map((event) => event.state), [
        CommandState.pending,
        CommandState.acknowledged,
        CommandState.executed,
      ]);
      expect(stored!.data['priority'], 'high');
      expect(stored.data['emergency'], isTrue);
      expect(
        repository.devices
            .singleWhere((device) => device.id == 'SEMS-000001')
            .isOn,
        isFalse,
      );
    },
  );

  test(
    'moving onto an occupied socket unassigns it and closes its session',
    () async {
      await store.seeder.seedIfNeeded();
      final repository = await DriftSemsRepository.load(
        repositories: store.repositories,
      );

      await repository.moveAppliance('SEMS-000001', 'SEMS-000002');

      expect(
        (await store.repositories.appliances.getById('heater'))!
            .data['socketId'],
        'SEMS-000002',
      );
      expect(
        (await store.repositories.appliances.getById('fan'))!.data['socketId'],
        isNull,
      );
      final fanSessions = (await store.repositories.sessions.getAll()).where(
        (session) => session.data['applianceId'] == 'fan',
      );
      expect(
        fanSessions.where((session) => session.data['endedAt'] == null),
        isEmpty,
      );
      expect(
        fanSessions
            .singleWhere((session) => session.data['endedAt'] != null)
            .data['currentMeterKwh'],
        80.9,
      );
      expect(
        repository.appliances.singleWhere((item) => item.id == 'fan').socketId,
        isNull,
      );
    },
  );

  test(
    'Riverpod adapter provider resolves with the local Drift database',
    () async {
      final container = ProviderContainer(
        overrides: [mockDatabaseProvider.overrideWith((ref) => database)],
      );
      addTearDown(container.dispose);

      final repository = await container.read(semsRepositoryProvider.future);

      expect(repository.devices, isNotEmpty);
    },
  );

  test('persists device edits, add/remove, and appliance moves', () async {
    await store.seeder.seedIfNeeded();
    final repository = await DriftSemsRepository.load(
      repositories: store.repositories,
    );

    await repository.setDeviceState('SEMS-000001', false);
    await repository.renameDevice('SEMS-000001', 'Study socket');
    await repository.renameAppliance('SEMS-000001', 'Space heater');
    await repository.assignRoom('SEMS-000001', 'Study');
    await repository.addDevice(
      name: 'Removed socket',
      room: 'Office',
      appliance: 'Lamp',
    );
    expect(
      repository.devices.any((device) => device.id == 'SEMS-000005'),
      isTrue,
    );
    await repository.removeDevice('SEMS-000005');

    await repository.addDevice(
      name: 'Destination socket',
      room: 'Office',
      appliance: 'Unassigned',
    );
    await repository.moveAppliance('SEMS-000001', 'SEMS-000006');

    final persistedSocket = await store.repositories.sockets.getById(
      'SEMS-000001',
    );
    expect(persistedSocket!.data['relay'], isFalse);
    expect(persistedSocket.data['name'], 'Study socket');
    expect(persistedSocket.data['room'], 'Study');
    expect(persistedSocket.data['applianceId'], isNull);

    final movedSocket = await store.repositories.sockets.getById('SEMS-000006');
    expect(movedSocket!.data['applianceId'], 'heater');

    final reloaded = await DriftSemsRepository.load(
      repositories: store.repositories,
    );
    final source = reloaded.devices.singleWhere(
      (device) => device.id == 'SEMS-000001',
    );
    expect(source.name, 'Study socket');
    expect(source.appliance, 'Unassigned');
    expect(
      reloaded.devices
          .singleWhere((device) => device.id == 'SEMS-000006')
          .appliance,
      'Space heater',
    );
    expect(await store.repositories.sockets.getById('SEMS-000005'), isNull);
  });
}
