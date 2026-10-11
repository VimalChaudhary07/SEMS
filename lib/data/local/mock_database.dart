// Defines the SQLite database used by the local SEMS mock backend.
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'mock_database.g.dart';

class MockRecords extends Table {
  TextColumn get collection => text()();
  TextColumn get recordId => text()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {collection, recordId};
}

@DriftDatabase(tables: [MockRecords])
class MockDatabase extends _$MockDatabase {
  MockDatabase({QueryExecutor? executor})
    : super(
        executor ??
            driftDatabase(
              name: 'sems_mock',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 1 && to >= 1) {
        await migrator.createTable(mockRecords);
      }
    },
    beforeOpen: (_) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
