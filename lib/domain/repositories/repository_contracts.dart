// Defines local-mock repository contracts used by the SEMS domain.
import '../models/json_record.dart';

abstract interface class JsonCollectionRepository {
  Stream<List<JsonRecord>> watchAll();
  Future<List<JsonRecord>> getAll();
  Future<JsonRecord?> getById(String id);
  Future<void> put(JsonRecord record);
  Future<void> delete(String id);
}

abstract interface class AuthRepository extends JsonCollectionRepository {}

abstract interface class SocketRepository extends JsonCollectionRepository {}

abstract interface class ApplianceRepository extends JsonCollectionRepository {}

abstract interface class SessionRepository extends JsonCollectionRepository {}

abstract interface class TelemetryRepository extends JsonCollectionRepository {}

abstract interface class CommandRepository extends JsonCollectionRepository {}

abstract interface class ScheduleRepository extends JsonCollectionRepository {}

abstract interface class AlertRepository extends JsonCollectionRepository {}

abstract interface class BillingRepository extends JsonCollectionRepository {}

abstract interface class AiRepository extends JsonCollectionRepository {}

abstract interface class BackupRepository extends JsonCollectionRepository {}

abstract interface class FamilyRepository extends JsonCollectionRepository {}

abstract interface class SettingsRepository extends JsonCollectionRepository {}

abstract interface class DeveloperIdentityRepository
    extends JsonCollectionRepository {}
