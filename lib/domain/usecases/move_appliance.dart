// Moves an appliance by closing its current meter session before opening the next.
import '../../core/services/clock.dart';
import '../../core/services/id_generator.dart';
import '../models/json_record.dart';
import '../repositories/repository_contracts.dart';

class MoveAppliance {
  const MoveAppliance({
    required SessionRepository sessions,
    required ApplianceRepository appliances,
    required SocketRepository sockets,
    required IdGenerator idGenerator,
    required Clock clock,
  }) : this._(
         sessions: sessions,
         appliances: appliances,
         sockets: sockets,
         idGenerator: idGenerator,
         clock: clock,
       );

  const MoveAppliance._({
    required this._sessions,
    required this._appliances,
    required this._sockets,
    required this._idGenerator,
    required this._clock,
  });

  final SessionRepository _sessions;
  final ApplianceRepository _appliances;
  final SocketRepository _sockets;
  final IdGenerator _idGenerator;
  final Clock _clock;

  Future<void> call({
    required String applianceId,
    required String destinationSocketId,
  }) async {
    final appliance = await _appliances.getById(applianceId);
    if (appliance == null) {
      throw StateError('Cannot move unknown appliance "$applianceId".');
    }
    final destination = await _sockets.getById(destinationSocketId);
    if (destination == null || destination.data['status'] != 'online') {
      throw StateError('Destination socket is missing or offline.');
    }
    final sessions = await _sessions.getAll();
    final active = sessions.where(
      (session) =>
          session.data['applianceId'] == applianceId &&
          session.data['endedAt'] == null,
    );
    if (active.length > 1) {
      throw StateError('Appliance has multiple active sessions.');
    }

    final now = _clock.now().toIso8601String();
    if (active.isNotEmpty &&
        active.single.data['socketId'] == destinationSocketId) {
      throw StateError('Appliance is already assigned to this socket.');
    }
    final destinationApplianceId = destination.data['applianceId'];
    final displacedId =
        destinationApplianceId is String &&
            destinationApplianceId != 'Unassigned'
        ? destinationApplianceId
        : null;
    final displaced = displacedId == null
        ? null
        : await _appliances.getById(displacedId);
    if (displacedId != null && displaced == null) {
      throw StateError(
        'Destination appliance "$displacedId" no longer exists.',
      );
    }
    if (displacedId != null && displacedId != applianceId) {
      final displacedSessions = sessions.where(
        (session) =>
            session.data['applianceId'] == displacedId &&
            session.data['endedAt'] == null,
      );
      if (displacedSessions.length > 1) {
        throw StateError('Destination appliance has multiple active sessions.');
      }
      if (displacedSessions.isNotEmpty) {
        final displacedSession = displacedSessions.single;
        await _sessions.put(
          JsonRecord(
            id: displacedSession.id,
            data: {
              ...displacedSession.data,
              'currentMeterKwh': _number(destination.data['meterKwh']),
              'endedAt': now,
            },
          ),
        );
      }
      await _appliances.put(
        JsonRecord(
          id: displacedId,
          data: {...displaced!.data, 'socketId': null},
        ),
      );
    }

    final current = active.isEmpty ? null : active.single;
    if (current != null) {
      final sourceSocket = await _sockets.getById(
        current.data['socketId'] as String,
      );
      if (sourceSocket == null) {
        throw StateError('The appliance’s current socket no longer exists.');
      }
      final currentMeter = _number(sourceSocket.data['meterKwh']);
      await _sessions.put(
        JsonRecord(
          id: current.id,
          data: {
            ...current.data,
            'currentMeterKwh': currentMeter,
            'endedAt': now,
          },
        ),
      );
    }
    final destinationMeter = _number(destination.data['meterKwh']);
    final newSessionId = _idGenerator.nextId();
    await _sessions.put(
      JsonRecord(
        id: newSessionId,
        data: {
          'id': newSessionId,
          'applianceId': applianceId,
          'socketId': destinationSocketId,
          'startedAt': now,
          'startMeterKwh': destinationMeter,
          'currentMeterKwh': destinationMeter,
          'endedAt': null,
        },
      ),
    );
    await _appliances.put(
      JsonRecord(
        id: applianceId,
        data: {
          ...appliance.data,
          'socketId': destinationSocketId,
          'room': destination.data['room'] ?? appliance.data['room'],
        },
      ),
    );
  }

  double _number(Object? value) => value is num ? value.toDouble() : 0;
}
