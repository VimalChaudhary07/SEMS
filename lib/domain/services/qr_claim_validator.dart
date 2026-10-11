// Validates pairing claim codes against locally seeded developer identities.
import '../models/developer_identity_record.dart';

enum QrClaimStatus { valid, invalidQr, alreadyClaimed, claimUsed }

class QrClaimValidator {
  const QrClaimValidator();

  QrClaimStatus validate(
    String claimCode,
    Iterable<DeveloperIdentityRecord> identities,
  ) {
    if (!RegExp(r'^\d{6}$').hasMatch(claimCode)) {
      return QrClaimStatus.invalidQr;
    }
    DeveloperIdentityRecord? identity;
    for (final candidate in identities) {
      if (candidate.claimCode == claimCode) {
        identity = candidate;
        break;
      }
    }
    if (identity == null) return QrClaimStatus.invalidQr;
    return switch (identity.status) {
      'unclaimed' => QrClaimStatus.valid,
      'claimed' => QrClaimStatus.alreadyClaimed,
      'used' => QrClaimStatus.claimUsed,
      _ => QrClaimStatus.invalidQr,
    };
  }
}
