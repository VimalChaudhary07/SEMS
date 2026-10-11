// Loads local developer identities and validates a pairing claim code.
import '../models/developer_identity_record.dart';
import '../repositories/repository_contracts.dart';
import 'qr_claim_validator.dart';

class QrClaimService {
  const QrClaimService({
    required this.identities,
    this.validator = const QrClaimValidator(),
  });

  final DeveloperIdentityRepository identities;
  final QrClaimValidator validator;

  Future<QrClaimStatus> validate(String claimCode) async {
    final records = await identities.getAll();
    final identityRecords = [
      for (final record in records)
        DeveloperIdentityRecord.fromJson(record.data.cast<String, dynamic>()),
    ];
    return validator.validate(claimCode, identityRecords);
  }
}
