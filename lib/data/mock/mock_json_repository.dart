// Adapts Drift JSON records to the domain repository contracts.
import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/models/alert_record.dart';
import '../../domain/models/ai_insight_record.dart';
import '../../domain/models/appliance_record.dart';
import '../../domain/models/backup_record.dart';
import '../../domain/models/bill_record.dart';
import '../../domain/models/developer_identity_record.dart';
import '../../domain/models/energy_session_record.dart';
import '../../domain/models/family_member_record.dart';
import '../../domain/models/json_record.dart';
import '../../domain/models/schedule_record.dart';
import '../../domain/models/settings_record.dart';
import '../../domain/models/socket_device.dart';
import '../../domain/models/telemetry_sample.dart';
import '../../domain/models/tariff_record.dart';
import '../../domain/models/user_record.dart';
import '../../domain/repositories/repository_contracts.dart';
import '../local/mock_database.dart';
import 'typed_json_repository.dart';

class MockRepositories {
  MockRepositories(MockDatabase database)
    : auth = DriftJsonRepository(database, 'users'),
      sockets = DriftJsonRepository(database, 'sockets'),
      appliances = DriftJsonRepository(database, 'appliances'),
      sessions = DriftJsonRepository(database, 'sessions'),
      history = DriftJsonRepository(database, 'history'),
      telemetry = DriftJsonRepository(database, 'telemetry'),
      commands = DriftJsonRepository(database, 'commands'),
      schedules = DriftJsonRepository(database, 'schedules'),
      scheduleState = DriftJsonRepository(database, 'scheduleState'),
      alerts = DriftJsonRepository(database, 'alerts'),
      billing = DriftJsonRepository(database, 'bills'),
      tariffs = DriftJsonRepository(database, 'tariffs'),
      ai = DriftJsonRepository(database, 'ai'),
      backup = DriftJsonRepository(database, 'backup'),
      family = DriftJsonRepository(database, 'family'),
      settings = DriftJsonRepository(database, 'settings'),
      alertPreferences = DriftJsonRepository(database, 'alertPreferences'),
      developerIdentities = DriftJsonRepository(database, 'identities'),
      scenarioState = DriftJsonRepository(database, '_meta') {
    users = _typed(auth, UserRecord.fromJson, (value) => value.toJson());
    socketDevices = _typed(
      sockets,
      SocketDevice.fromJson,
      (value) => value.toJson(),
    );
    applianceRecords = _typed(
      appliances,
      ApplianceRecord.fromJson,
      (value) => value.toJson(),
    );
    energySessions = _typed(
      sessions,
      EnergySessionRecord.fromJson,
      (value) => value.toJson(),
    );
    telemetrySamples = _typed(
      telemetry,
      TelemetrySample.fromJson,
      (value) => value.toJson(),
    );
    scheduleRecords = _typed(
      schedules,
      ScheduleRecord.fromJson,
      (value) => value.toJson(),
    );
    alertRecords = _typed(
      alerts,
      AlertRecord.fromJson,
      (value) => value.toJson(),
    );
    bills = _typed(billing, BillRecord.fromJson, (value) => value.toJson());
    tariffsData = _typed(
      tariffs,
      TariffRecord.fromJson,
      (value) => value.toJson(),
    );
    aiInsights = _typed(
      ai,
      AiInsightRecord.fromJson,
      (value) => value.toJson(),
    );
    familyMembers = _typed(
      family,
      FamilyMemberRecord.fromJson,
      (value) => value.toJson(),
    );
    appSettings = _typed(
      settings,
      SettingsRecord.fromJson,
      (value) => value.toJson(),
    );
    backupRecords = _typed(
      backup,
      BackupRecord.fromJson,
      (value) => value.toJson(),
    );
    identities = _typed(
      developerIdentities,
      DeveloperIdentityRecord.fromJson,
      (value) => value.toJson(),
    );
  }

  final AuthRepository auth;
  final SocketRepository sockets;
  final ApplianceRepository appliances;
  final SessionRepository sessions;
  final JsonCollectionRepository history;
  final TelemetryRepository telemetry;
  final CommandRepository commands;
  final ScheduleRepository schedules;
  final JsonCollectionRepository scheduleState;
  final AlertRepository alerts;
  final BillingRepository billing;
  final JsonCollectionRepository tariffs;
  final AiRepository ai;
  final BackupRepository backup;
  final FamilyRepository family;
  final SettingsRepository settings;
  final JsonCollectionRepository alertPreferences;
  final DeveloperIdentityRepository developerIdentities;
  final JsonCollectionRepository scenarioState;

  late final TypedJsonRepository<UserRecord> users;
  late final TypedJsonRepository<SocketDevice> socketDevices;
  late final TypedJsonRepository<ApplianceRecord> applianceRecords;
  late final TypedJsonRepository<EnergySessionRecord> energySessions;
  late final TypedJsonRepository<TelemetrySample> telemetrySamples;
  late final TypedJsonRepository<ScheduleRecord> scheduleRecords;
  late final TypedJsonRepository<AlertRecord> alertRecords;
  late final TypedJsonRepository<BillRecord> bills;
  late final TypedJsonRepository<TariffRecord> tariffsData;
  late final TypedJsonRepository<AiInsightRecord> aiInsights;
  late final TypedJsonRepository<FamilyMemberRecord> familyMembers;
  late final TypedJsonRepository<SettingsRecord> appSettings;
  late final TypedJsonRepository<BackupRecord> backupRecords;
  late final TypedJsonRepository<DeveloperIdentityRecord> identities;

  TypedJsonRepository<T> _typed<T>(
    JsonCollectionRepository records,
    T Function(Map<String, dynamic> json) decode,
    Map<String, dynamic> Function(T value) encode,
  ) => TypedJsonRepository<T>(records: records, decode: decode, encode: encode);
}

class DriftJsonRepository
    implements
        AuthRepository,
        SocketRepository,
        ApplianceRepository,
        SessionRepository,
        TelemetryRepository,
        CommandRepository,
        ScheduleRepository,
        AlertRepository,
        BillingRepository,
        AiRepository,
        BackupRepository,
        FamilyRepository,
        SettingsRepository,
        DeveloperIdentityRepository {
  DriftJsonRepository(this._database, this.collection);

  final MockDatabase _database;
  final String collection;

  SimpleSelectStatement<$MockRecordsTable, MockRecord> _query() =>
      _database.select(_database.mockRecords)
        ..where((row) => row.collection.equals(collection));

  List<JsonRecord> _decodeRows(List<MockRecord> rows) => [
    for (final row in rows)
      JsonRecord(
        id: row.recordId,
        data: (jsonDecode(row.payload) as Map<String, dynamic>)
            .cast<String, Object?>(),
      ),
  ];

  @override
  Stream<List<JsonRecord>> watchAll() => _query().watch().map(_decodeRows);

  @override
  Future<List<JsonRecord>> getAll() async => _decodeRows(await _query().get());

  @override
  Future<JsonRecord?> getById(String id) async {
    final row =
        await (_database.select(_database.mockRecords)..where(
              (record) =>
                  record.collection.equals(collection) &
                  record.recordId.equals(id),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return _decodeRows([row]).single;
  }

  @override
  Future<void> put(JsonRecord record) async {
    await _database
        .into(_database.mockRecords)
        .insertOnConflictUpdate(
          MockRecordsCompanion.insert(
            collection: collection,
            recordId: record.id,
            payload: jsonEncode(record.data),
          ),
        );
  }

  @override
  Future<void> delete(String id) async {
    await (_database.delete(_database.mockRecords)..where(
          (record) =>
              record.collection.equals(collection) & record.recordId.equals(id),
        ))
        .go();
  }
}
