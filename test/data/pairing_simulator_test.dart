import 'package:flutter_test/flutter_test.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/data/simulators/pairing_simulator.dart';
import 'package:sems/domain/models/simulation_results.dart';

void main() {
  final repository = MockSemsRepository();
  final simulator = PairingSimulator(
    stepDelay: Duration.zero,
    validateClaimCode: repository.validateClaimCode,
  );

  test('runs all local pairing steps for a valid seeded claim code', () async {
    final progress = await simulator
        .run(claimCode: repository.pendingClaimCode)
        .toList();

    expect(progress.map((item) => item.step).toList(), PairingStep.values);
    expect(progress.every((item) => item.error == null), isTrue);
  });

  test('rejects an invalid claim code before pairing starts', () async {
    final progress = await simulator.run(claimCode: '000000').toList();

    expect(progress, hasLength(1));
    expect(progress.single.step, PairingStep.scanQr);
    expect(progress.single.error, PairingError.invalidQr);
  });

  test('emits each previewed pairing error at its simulated step', () async {
    for (final expectedError in PairingError.values) {
      final progress = await simulator
          .run(claimCode: repository.pendingClaimCode, failAt: expectedError)
          .toList();

      expect(
        progress.last.error,
        expectedError,
        reason: 'Failed to emit $expectedError',
      );
    }
  });
}
