// Loads the versioned JSON mock dataset into the local Drift database.
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../local/mock_database.dart';

class MockSeeder {
  MockSeeder(this._database, {AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  static const seedVersion = '4';
  static const _files = <String, String>{
    'users': 'assets/mock/users.json',
    'sockets': 'assets/mock/sockets.json',
    'appliances': 'assets/mock/appliances.json',
    'sessions': 'assets/mock/sessions.json',
    'schedules': 'assets/mock/schedules.json',
    'alerts': 'assets/mock/alerts.json',
    'backup': 'assets/mock/backup.json',
    'bills': 'assets/mock/billing.json',
    'tariffs': 'assets/mock/tariff.json',
    'ai': 'assets/mock/ai.json',
    'identities': 'assets/mock/identities.json',
    'history': 'assets/mock/history.json',
    'telemetry': 'assets/mock/telemetry.json',
    'family': 'assets/mock/family.json',
    'settings': 'assets/mock/settings.json',
    'scenarios': 'assets/mock/scenarios.json',
  };

  final MockDatabase _database;
  final AssetBundle _assetBundle;

  Future<bool> seedIfNeeded() async {
    final stored =
        await (_database.select(_database.mockRecords)..where(
              (row) =>
                  row.collection.equals('_meta') &
                  row.recordId.equals('seedVersion'),
            ))
            .getSingleOrNull();
    if (stored?.payload == seedVersion) return false;
    await seed(reset: stored == null);
    return true;
  }

  Future<void> seed({bool reset = false}) async {
    await _database.transaction(() async {
      if (reset) {
        await _database.delete(_database.mockRecords).go();
      }
      for (final entry in _files.entries) {
        final contents = await _assetBundle.loadString(entry.value);
        final items = jsonDecode(contents) as List<dynamic>;
        for (final item in items) {
          final data = (item as Map<String, dynamic>).cast<String, Object?>();
          final id = data['id'];
          if (id is! String || id.isEmpty) {
            throw FormatException(
              'Mock seed item in ${entry.value} must have a non-empty id.',
            );
          }
          final record = MockRecordsCompanion.insert(
            collection: entry.key,
            recordId: id,
            payload: jsonEncode(data),
          );
          final insert = _database.into(_database.mockRecords);
          if (reset) {
            await insert.insertOnConflictUpdate(record);
          } else {
            await insert.insert(record, mode: InsertMode.insertOrIgnore);
          }
        }
      }
      await _database
          .into(_database.mockRecords)
          .insertOnConflictUpdate(
            MockRecordsCompanion.insert(
              collection: '_meta',
              recordId: 'seedVersion',
              payload: seedVersion,
            ),
          );
    });
  }

  Future<void> reset() => seed(reset: true);
}
