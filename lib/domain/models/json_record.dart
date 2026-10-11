// Represents a JSON-backed domain record in the local mock data store.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'json_record.freezed.dart';

typedef JsonMap = Map<String, Object?>;

@freezed
abstract class JsonRecord with _$JsonRecord {
  const factory JsonRecord({required String id, required JsonMap data}) =
      _JsonRecord;
}
