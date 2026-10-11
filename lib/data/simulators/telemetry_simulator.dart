// Emits deterministic socket telemetry locally at the ten-second demo cadence.
import 'dart:async';

import '../../core/services/clock.dart';
import '../../core/services/id_generator.dart';
import '../../domain/models/json_record.dart';
import '../../domain/models/telemetry_sample.dart';
import '../../domain/repositories/repository_contracts.dart';

class TelemetrySimulator {
  TelemetrySimulator({
    required this.sockets,
    required this.telemetry,
    required this.clock,
    required this.idGenerator,
    this.interval = const Duration(seconds: 10),
  });

  final SocketRepository sockets;
  final TelemetryRepository telemetry;
  final Clock clock;
  final IdGenerator idGenerator;
  final Duration interval;
  final _samples = StreamController<TelemetrySample>.broadcast();
  Timer? _timer;
  final Map<String, int> _sequences = {};
  bool _isEmitting = false;

  Stream<TelemetrySample> get samples => _samples.stream;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(interval, (_) {
      unawaited(emitOnce());
    });
  }

  Future<List<TelemetrySample>> emitOnce() async {
    if (_isEmitting) return const [];
    _isEmitting = true;
    try {
      final records = await sockets.getAll();
      final emitted = <TelemetrySample>[];
      for (final socket in records) {
        if (socket.data['status'] != 'online') continue;
        final power = _number(socket.data['powerW']);
        final voltage = 230.0;
        final current = voltage == 0 ? 0.0 : power / voltage;
        final sample = TelemetrySample(
          id: idGenerator.nextId(),
          deviceId: socket.id,
          timestamp: clock.now(),
          sequence: _sequences.update(
            socket.id,
            (sequence) => sequence + 1,
            ifAbsent: () => 1,
          ),
          relay: socket.data['relay'] == true,
          voltageV: voltage,
          currentA: current,
          powerW: power,
          energyKwh: _number(socket.data['meterKwh']),
          frequencyHz: 50,
          powerFactor: power == 0 ? 0 : 0.99,
          quality: 'good',
        );
        await telemetry.put(JsonRecord(id: sample.id, data: sample.toJson()));
        emitted.add(sample);
        _samples.add(sample);
      }
      return emitted;
    } finally {
      _isEmitting = false;
    }
  }

  Future<void> dispose() async {
    _timer?.cancel();
    _timer = null;
    await _samples.close();
  }

  double _number(Object? value) => value is num ? value.toDouble() : 0;
}
