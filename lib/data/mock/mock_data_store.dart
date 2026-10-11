// Bundles repositories, seeding, and scenarios around one local database.
import 'package:flutter/services.dart';

import '../local/mock_database.dart';
import 'mock_json_repository.dart';
import 'mock_scenario.dart';
import 'mock_seeder.dart';

class MockDataStore {
  MockDataStore(this.database, {AssetBundle? assetBundle})
    : repositories = MockRepositories(database),
      seeder = MockSeeder(database, assetBundle: assetBundle),
      scenarios = MockScenarioController(database, assetBundle: assetBundle);

  final MockDatabase database;
  final MockRepositories repositories;
  final MockSeeder seeder;
  final MockScenarioController scenarios;
}
