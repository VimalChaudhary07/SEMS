// Activates deterministic mock-data presets for demos and tests.
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/json_record.dart';
import '../local/mock_database.dart';
import 'mock_json_repository.dart';
import 'mock_seeder.dart';

enum MockScenario {
  normal,
  socketOffline,
  safetyTrip,
  learning2Days,
  basic5Days,
  good10Days,
  strong45Days,
  emptyNoSockets,
  emptyNoAppliances,
  driveNotConnected,
  driveFailed,
  commandFails,
  commandExpires,
  familyUser,
  ownerUser,
}

class MockScenarioController {
  MockScenarioController(this._database, {AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle,
      _seeder = MockSeeder(_database, assetBundle: assetBundle);

  final MockDatabase _database;
  final AssetBundle _assetBundle;
  final MockSeeder _seeder;

  Future<void> activate(MockScenario scenario) async {
    await _seeder.reset();
    final overrides = jsonDecode(
      await _assetBundle.loadString('assets/mock/scenario_overrides.json'),
    ) as Map<String, dynamic>;
    final scenarioData = overrides[scenario.name] as Map<String, dynamic>?;
    if (scenarioData == null) {
      throw StateError(
        'No mock override data for scenario "${scenario.name}".',
      );
    }

    for (final collectionEntry in scenarioData.entries) {
      final repository = DriftJsonRepository(_database, collectionEntry.key);
      final records = collectionEntry.value as Map<String, dynamic>;
      for (final recordEntry in records.entries) {
        final payload = recordEntry.value;
        if (payload == null) {
          await repository.delete(recordEntry.key);
        } else {
          final data = (payload as Map<String, dynamic>)
              .cast<String, Object?>();
          await repository.put(JsonRecord(id: recordEntry.key, data: data));
        }
      }
    }
  }
}
