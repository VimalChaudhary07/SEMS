// Adapts JSON-backed mock records to immutable domain model types.
import '../../domain/models/json_record.dart';
import '../../domain/repositories/repository_contracts.dart';

typedef JsonDecoder<T> = T Function(Map<String, dynamic> json);
typedef JsonEncoder<T> = Map<String, dynamic> Function(T value);

class TypedJsonRepository<T> {
  const TypedJsonRepository({
    required this.records,
    required this.decode,
    required this.encode,
  });

  final JsonCollectionRepository records;
  final JsonDecoder<T> decode;
  final JsonEncoder<T> encode;

  Stream<List<T>> watchAll() => records.watchAll().map(_decodeRecords);

  Future<List<T>> getAll() async => _decodeRecords(await records.getAll());

  Future<T?> getById(String id) async {
    final record = await records.getById(id);
    return record == null ? null : decode(record.data.cast<String, dynamic>());
  }

  Future<void> put(T value, {required String id}) => records.put(
    JsonRecord(id: id, data: encode(value).cast<String, Object?>()),
  );

  Future<void> delete(String id) => records.delete(id);

  List<T> _decodeRecords(List<JsonRecord> records) => [
    for (final record in records) decode(record.data.cast<String, dynamic>()),
  ];
}
