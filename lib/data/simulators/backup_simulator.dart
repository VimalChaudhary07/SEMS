// Simulates optional backup and restore progress on the local mock dataset.
import '../../domain/models/simulation_results.dart';

class BackupSimulator {
  BackupSimulator({this.stepDelay = const Duration(milliseconds: 300)});

  final Duration stepDelay;

  Stream<BackupProgress> backup({
    int pendingCount = 0,
    BackupError failure = BackupError.none,
  }) async* {
    if (pendingCount < 0) {
      throw ArgumentError.value(
        pendingCount,
        'pendingCount',
        'Must not be negative.',
      );
    }
    if (failure == BackupError.none && pendingCount == 0) {
      yield const BackupProgress(
        stage: BackupStage.complete,
        progress: 1,
        pendingCount: 0,
      );
      return;
    }
    if (failure == BackupError.accountUnavailable) {
      yield BackupProgress(
        stage: BackupStage.failed,
        progress: 0,
        error: failure,
        pendingCount: pendingCount,
      );
      return;
    }
    for (final step in [0.2, 0.45, 0.7]) {
      await Future<void>.delayed(stepDelay);
      yield BackupProgress(
        stage: BackupStage.uploading,
        progress: step,
        pendingCount: pendingCount,
      );
    }
    if (failure == BackupError.uploadFailure) {
      yield BackupProgress(
        stage: BackupStage.failed,
        progress: 0.7,
        error: failure,
        pendingCount: pendingCount,
      );
      return;
    }
    await Future<void>.delayed(stepDelay);
    yield BackupProgress(
      stage: BackupStage.verifying,
      progress: 0.9,
      pendingCount: pendingCount,
    );
    await Future<void>.delayed(stepDelay);
    yield BackupProgress(
      stage: BackupStage.reviewing,
      progress: 0.95,
      pendingCount: pendingCount,
    );
    if (failure == BackupError.schemaMismatch ||
        failure == BackupError.checksumFailure) {
      yield BackupProgress(
        stage: BackupStage.failed,
        progress: 0.9,
        error: failure,
        pendingCount: pendingCount,
      );
      return;
    }
    yield BackupProgress(
      stage: BackupStage.complete,
      progress: 1,
      pendingCount: 0,
    );
  }

  Stream<BackupProgress> restore({
    BackupError failure = BackupError.none,
  }) async* {
    yield BackupProgress(
      stage: BackupStage.finding,
      progress: 0,
      error: failure == BackupError.noBackup ? failure : BackupError.none,
    );
    if (failure == BackupError.noBackup ||
        failure == BackupError.accountUnavailable) {
      yield BackupProgress(
        stage: BackupStage.failed,
        progress: 0,
        error: failure,
      );
      return;
    }
    await Future<void>.delayed(stepDelay);
    yield BackupProgress(stage: BackupStage.verifying, progress: 0.35);
    if (failure == BackupError.schemaMismatch ||
        failure == BackupError.checksumFailure) {
      yield BackupProgress(
        stage: BackupStage.failed,
        progress: 0.35,
        error: failure,
      );
      return;
    }
    await Future<void>.delayed(stepDelay);
    yield BackupProgress(stage: BackupStage.restoring, progress: 0.7);
    await Future<void>.delayed(stepDelay);
    yield BackupProgress(stage: BackupStage.complete, progress: 1);
  }
}
