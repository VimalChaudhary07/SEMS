// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_database.dart';

// ignore_for_file: type=lint
class $MockRecordsTable extends MockRecords
    with TableInfo<$MockRecordsTable, MockRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MockRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _collectionMeta = const VerificationMeta(
    'collection',
  );
  @override
  late final GeneratedColumn<String> collection = GeneratedColumn<String>(
    'collection',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [collection, recordId, payload];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mock_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MockRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('collection')) {
      context.handle(
        _collectionMeta,
        collection.isAcceptableOrUnknown(data['collection']!, _collectionMeta),
      );
    } else if (isInserting) {
      context.missing(_collectionMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {collection, recordId};
  @override
  MockRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MockRecord(
      collection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
    );
  }

  @override
  $MockRecordsTable createAlias(String alias) {
    return $MockRecordsTable(attachedDatabase, alias);
  }
}

class MockRecord extends DataClass implements Insertable<MockRecord> {
  final String collection;
  final String recordId;
  final String payload;
  const MockRecord({
    required this.collection,
    required this.recordId,
    required this.payload,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['collection'] = Variable<String>(collection);
    map['record_id'] = Variable<String>(recordId);
    map['payload'] = Variable<String>(payload);
    return map;
  }

  MockRecordsCompanion toCompanion(bool nullToAbsent) {
    return MockRecordsCompanion(
      collection: Value(collection),
      recordId: Value(recordId),
      payload: Value(payload),
    );
  }

  factory MockRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MockRecord(
      collection: serializer.fromJson<String>(json['collection']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'collection': serializer.toJson<String>(collection),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String>(payload),
    };
  }

  MockRecord copyWith({
    String? collection,
    String? recordId,
    String? payload,
  }) => MockRecord(
    collection: collection ?? this.collection,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
  );
  MockRecord copyWithCompanion(MockRecordsCompanion data) {
    return MockRecord(
      collection: data.collection.present
          ? data.collection.value
          : this.collection,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MockRecord(')
          ..write('collection: $collection, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(collection, recordId, payload);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MockRecord &&
          other.collection == this.collection &&
          other.recordId == this.recordId &&
          other.payload == this.payload);
}

class MockRecordsCompanion extends UpdateCompanion<MockRecord> {
  final Value<String> collection;
  final Value<String> recordId;
  final Value<String> payload;
  final Value<int> rowid;
  const MockRecordsCompanion({
    this.collection = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MockRecordsCompanion.insert({
    required String collection,
    required String recordId,
    required String payload,
    this.rowid = const Value.absent(),
  }) : collection = Value(collection),
       recordId = Value(recordId),
       payload = Value(payload);
  static Insertable<MockRecord> custom({
    Expression<String>? collection,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (collection != null) 'collection': collection,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MockRecordsCompanion copyWith({
    Value<String>? collection,
    Value<String>? recordId,
    Value<String>? payload,
    Value<int>? rowid,
  }) {
    return MockRecordsCompanion(
      collection: collection ?? this.collection,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (collection.present) {
      map['collection'] = Variable<String>(collection.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MockRecordsCompanion(')
          ..write('collection: $collection, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MockDatabase extends GeneratedDatabase {
  _$MockDatabase(QueryExecutor e) : super(e);
  $MockDatabaseManager get managers => $MockDatabaseManager(this);
  late final $MockRecordsTable mockRecords = $MockRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [mockRecords];
}

typedef $$MockRecordsTableCreateCompanionBuilder =
    MockRecordsCompanion Function({
      required String collection,
      required String recordId,
      required String payload,
      Value<int> rowid,
    });
typedef $$MockRecordsTableUpdateCompanionBuilder =
    MockRecordsCompanion Function({
      Value<String> collection,
      Value<String> recordId,
      Value<String> payload,
      Value<int> rowid,
    });

class $$MockRecordsTableFilterComposer
    extends Composer<_$MockDatabase, $MockRecordsTable> {
  $$MockRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MockRecordsTableOrderingComposer
    extends Composer<_$MockDatabase, $MockRecordsTable> {
  $$MockRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MockRecordsTableAnnotationComposer
    extends Composer<_$MockDatabase, $MockRecordsTable> {
  $$MockRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get collection => $composableBuilder(
    column: $table.collection,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);
}

class $$MockRecordsTableTableManager
    extends
        RootTableManager<
          _$MockDatabase,
          $MockRecordsTable,
          MockRecord,
          $$MockRecordsTableFilterComposer,
          $$MockRecordsTableOrderingComposer,
          $$MockRecordsTableAnnotationComposer,
          $$MockRecordsTableCreateCompanionBuilder,
          $$MockRecordsTableUpdateCompanionBuilder,
          (
            MockRecord,
            BaseReferences<_$MockDatabase, $MockRecordsTable, MockRecord>,
          ),
          MockRecord,
          PrefetchHooks Function()
        > {
  $$MockRecordsTableTableManager(_$MockDatabase db, $MockRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MockRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MockRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MockRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> collection = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MockRecordsCompanion(
                collection: collection,
                recordId: recordId,
                payload: payload,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String collection,
                required String recordId,
                required String payload,
                Value<int> rowid = const Value.absent(),
              }) => MockRecordsCompanion.insert(
                collection: collection,
                recordId: recordId,
                payload: payload,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MockRecordsTable, MockRecord>(table),
                  BaseReferences<_$MockDatabase, $MockRecordsTable, MockRecord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MockRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$MockDatabase,
      $MockRecordsTable,
      MockRecord,
      $$MockRecordsTableFilterComposer,
      $$MockRecordsTableOrderingComposer,
      $$MockRecordsTableAnnotationComposer,
      $$MockRecordsTableCreateCompanionBuilder,
      $$MockRecordsTableUpdateCompanionBuilder,
      (
        MockRecord,
        BaseReferences<_$MockDatabase, $MockRecordsTable, MockRecord>,
      ),
      MockRecord,
      PrefetchHooks Function()
    >;

class $MockDatabaseManager {
  final _$MockDatabase _db;
  $MockDatabaseManager(this._db);
  $$MockRecordsTableTableManager get mockRecords =>
      $$MockRecordsTableTableManager(_db, _db.mockRecords);
}
