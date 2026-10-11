// Simulates the eight local socket-pairing stages and their error cases.
import '../../domain/models/simulation_results.dart';
import '../../domain/services/qr_claim_service.dart';
import '../../domain/services/qr_claim_validator.dart';

class PairingSimulator {
  PairingSimulator({
    this.stepDelay = const Duration(milliseconds: 250),
    this.claimService,
    this.validateClaimCode,
  });

  final Duration stepDelay;
  final QrClaimService? claimService;
  final Future<QrClaimStatus> Function(String claimCode)? validateClaimCode;

  Stream<PairingProgress> run({
    PairingError? failAt,
    String? claimCode,
  }) async* {
    if (claimCode != null) {
      final validate = validateClaimCode;
      final service = claimService;
      if (validate == null && service == null) {
        throw StateError('A QR claim service is required to validate a code.');
      }
      final claimStatus = validate != null
          ? await validate(claimCode)
          : await service!.validate(claimCode);
      if (claimStatus != QrClaimStatus.valid) {
        final error = switch (claimStatus) {
          QrClaimStatus.invalidQr => PairingError.invalidQr,
          QrClaimStatus.alreadyClaimed => PairingError.alreadyClaimed,
          QrClaimStatus.claimUsed => PairingError.claimUsed,
          QrClaimStatus.valid => null,
        };
        yield PairingProgress(
          step: claimStatus == QrClaimStatus.invalidQr
              ? PairingStep.scanQr
              : PairingStep.claiming,
          error: error,
        );
        return;
      }
    }
    for (final step in PairingStep.values) {
      await Future<void>.delayed(stepDelay);
      final error = _errorFor(step, failAt);
      yield PairingProgress(step: step, error: error);
      if (error != null) return;
    }
  }

  PairingError? _errorFor(PairingStep step, PairingError? error) {
    if (error == null) return null;
    return switch (error) {
      PairingError.invalidQr => step == PairingStep.scanQr ? error : null,
      PairingError.bluetoothNotFound =>
        step == PairingStep.connecting ? error : null,
      PairingError.wifiJoinFailed =>
        step == PairingStep.connecting ? error : null,
      PairingError.claimUsed => step == PairingStep.claiming ? error : null,
      PairingError.alreadyClaimed =>
        step == PairingStep.claiming ? error : null,
      PairingError.tooManyAttempts =>
        step == PairingStep.claiming ? error : null,
      PairingError.pairingWindowClosed =>
        step == PairingStep.connecting ? error : null,
      PairingError.claimFailed => step == PairingStep.claiming ? error : null,
    };
  }
}
