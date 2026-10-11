// Exposes the initialized local mock database and repositories to Riverpod.
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../local/mock_database.dart';
import '../mock/mock_data_store.dart';
import '../mock/drift_sems_repository.dart';
import '../mock/mock_json_repository.dart';
import '../repositories/sems_repository.dart';

final mockDatabaseProvider = Provider<MockDatabase>((ref) {
  final database = MockDatabase();
  ref.onDispose(() {
    unawaited(database.close());
  });
  return database;
});

final mockDataStoreProvider = FutureProvider<MockDataStore>((ref) async {
  final store = MockDataStore(ref.watch(mockDatabaseProvider));
  await store.seeder.seedIfNeeded();
  return store;
});

final mockRepositoriesProvider = FutureProvider<MockRepositories>((ref) async {
  return (await ref.watch(mockDataStoreProvider.future)).repositories;
});

final semsRepositoryProvider = FutureProvider<SemsRepository>((ref) async {
  final repositories = await ref.watch(mockRepositoriesProvider.future);
  return DriftSemsRepository.load(repositories: repositories);
});
