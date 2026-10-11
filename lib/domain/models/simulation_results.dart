// Defines progress and outcomes shared by local SEMS simulators.
enum PairingStep {
  scanQr,
  confirmSocket,
  pairingSecurity,
  wifiDetails,
  pairingMode,
  connecting,
  claiming,
  nameSocket,
}

enum PairingError {
  invalidQr,
  bluetoothNotFound,
  wifiJoinFailed,
  claimUsed,
  alreadyClaimed,
  tooManyAttempts,
  pairingWindowClosed,
  claimFailed,
}

class PairingProgress {
  const PairingProgress({required this.step, this.error});

  final PairingStep step;
  final PairingError? error;
}

enum BackupStage {
  finding,
  uploading,
  verifying,
  reviewing,
  restoring,
  complete,
  failed,
}

enum BackupError {
  none,
  failure,
  noBackup,
  schemaMismatch,
  checksumFailure,
  accountUnavailable,
  uploadFailure,
}

class BackupProgress {
  const BackupProgress({
    required this.stage,
    required this.progress,
    this.error = BackupError.none,
    this.pendingCount = 0,
  });

  final BackupStage stage;
  final double progress;
  final BackupError error;
  final int pendingCount;
}
