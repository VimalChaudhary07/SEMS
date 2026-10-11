// Merges mock restore batches idempotently using stable batch identifiers.
import '../models/json_record.dart';
import '../repositories/repository_contracts.dart';

class BackupBatch {
  const BackupBatch({
    required this.batchId,
    required this.records,
    required this.schemaVersion,
    required this.checksumValid,
  });

  final String batchId;
  final Map<String, List<JsonRecord>> records;
  final int schemaVersion;
  final bool checksumValid;
}

class BackupMergeResult {
  const BackupMergeResult({
    required this.imported,
    required this.skippedBatches,
    required this.conflicts,
  });

  final int imported;
  final int skippedBatches;
  final List<JsonRecord> conflicts;
}

class MergeBackup {
  const MergeBackup({
    required Map<String, JsonCollectionRepository> repositories,
    required BackupRepository backups,
    required int schemaVersion,
  }) : this._(
         repositories: repositories,
         backups: backups,
         schemaVersion: schemaVersion,
       );

  const MergeBackup._({
    required this._repositories,
    required this._backups,
    required this.schemaVersion,
  });

  final Map<String, JsonCollectionRepository> _repositories;
  final BackupRepository _backups;
  final int schemaVersion;

  Future<BackupMergeResult> call({
    required List<BackupBatch> batches,
    required bool importAsNew,
    required String Function(String originalId, String batchId) newId,
    required JsonRecord? Function(JsonRecord existing, JsonRecord incoming)
    resolveConflict,
  }) async {
    var imported = 0;
    var skippedBatches = 0;
    final conflicts = <JsonRecord>[];
    for (final batch in batches) {
      final existingBatch = await _backups.getById(batch.batchId);
      if (existingBatch != null) {
        skippedBatches++;
        continue;
      }
      if (batch.schemaVersion != schemaVersion) {
        throw FormatException(
          'Backup batch "${batch.batchId}" uses an unsupported schema.',
        );
      }
      if (!batch.checksumValid) {
        throw FormatException(
          'Backup batch "${batch.batchId}" failed checksum validation.',
        );
      }

      for (final collection in batch.records.entries) {
        final repository = _repositories[collection.key];
        if (repository == null) {
          throw StateError('No local repository for "${collection.key}".');
        }
        for (final record in collection.value) {
          final existing = await repository.getById(record.id);
          if (existing != null) {
            conflicts.add(existing);
            if (importAsNew) {
              final copiedId = newId(record.id, batch.batchId);
              await repository.put(
                JsonRecord(
                  id: copiedId,
                  data: {...record.data, 'id': copiedId},
                ),
              );
            } else {
              final merged = resolveConflict(existing, record);
              if (merged != null) await repository.put(merged);
            }
          } else {
            await repository.put(record);
          }
          imported++;
        }
      }
      await _backups.put(
        JsonRecord(
          id: batch.batchId,
          data: {'id': batch.batchId, 'schemaVersion': batch.schemaVersion},
        ),
      );
    }
    return BackupMergeResult(
      imported: imported,
      skippedBatches: skippedBatches,
      conflicts: List.unmodifiable(conflicts),
    );
  }
}
