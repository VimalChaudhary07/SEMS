// Simulates acknowledged local socket command lifecycles without a server.
import 'dart:async';

import '../../core/services/id_generator.dart';
import '../../core/services/clock.dart';
import '../../domain/models/command_progress.dart';
import '../../domain/models/json_record.dart';
import '../../domain/repositories/repository_contracts.dart';

enum CommandSimulationMode { success, fail, expire }

class CommandSimulator {
  CommandSimulator({
    required this.sockets,
    required this.commands,
    required this.idGenerator,
    required this.clock,
    this.scenarioState,
    this.stepDelay = const Duration(milliseconds: 300),
  });

  final SocketRepository sockets;
  final CommandRepository commands;
  final IdGenerator idGenerator;
  final Clock clock;
  final JsonCollectionRepository? scenarioState;
  final Duration stepDelay;

  Stream<CommandProgress> run({
    required String socketId,
    required bool targetRelay,
    CommandSimulationMode? mode,
    bool emergency = false,
  }) async* {
    final socket = await sockets.getById(socketId);
    if (socket == null) {
      throw StateError('Cannot send a command to unknown socket "$socketId".');
    }
    final commandId = idGenerator.nextId();
    final resolvedMode = mode ?? await _scenarioMode();
    final socketData = socket.data;
    if (socketData['status'] != 'online') {
      yield CommandProgress(
        commandId: commandId,
        socketId: socketId,
        targetRelay: targetRelay,
        state: CommandState.failed,
        message: 'Socket is offline.',
      );
      return;
    }
    if (targetRelay && socketData['safetyTrip'] == true) {
      yield CommandProgress(
        commandId: commandId,
        socketId: socketId,
        targetRelay: targetRelay,
        state: CommandState.blocked,
        message:
            socketData['tripReason'] as String? ??
            'Blocked by the socket safety limit.',
      );
      return;
    }

    Future<void> saveState(CommandState state) => commands.put(
      JsonRecord(
        id: commandId,
        data: {
          'id': commandId,
          'socketId': socketId,
          'targetRelay': targetRelay,
          'emergency': emergency,
          'priority': emergency ? 'high' : 'normal',
          'state': state.name,
          'createdAt': clock.now().toUtc().toIso8601String(),
        },
      ),
    );

    await saveState(CommandState.pending);
    yield CommandProgress(
      commandId: commandId,
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.pending,
      message: 'Control locked until the socket confirms.',
    );
    await Future<void>.delayed(stepDelay);
    await saveState(CommandState.acknowledged);
    yield CommandProgress(
      commandId: commandId,
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.acknowledged,
    );
    await Future<void>.delayed(stepDelay);

    if (resolvedMode != CommandSimulationMode.success) {
      final state = resolvedMode == CommandSimulationMode.fail
          ? CommandState.failed
          : CommandState.expired;
      await saveState(state);
      yield CommandProgress(
        commandId: commandId,
        socketId: socketId,
        targetRelay: targetRelay,
        state: state,
        message: resolvedMode == CommandSimulationMode.fail
            ? 'The socket did not execute the command. Retry.'
            : 'The command expired before execution. Retry.',
      );
      return;
    }

    await sockets.put(
      JsonRecord(
        id: socketId,
        data: {
          ...socketData,
          'relay': targetRelay,
          'powerW': targetRelay ? socketData['usualPowerW'] ?? 0 : 0,
        },
      ),
    );
    await saveState(CommandState.executed);
    yield CommandProgress(
      commandId: commandId,
      socketId: socketId,
      targetRelay: targetRelay,
      state: CommandState.executed,
    );
  }

  Future<CommandSimulationMode> _scenarioMode() async {
    final setting = await scenarioState?.getById('commandMode');
    return switch (setting?.data['value']) {
      'failed' => CommandSimulationMode.fail,
      'expired' => CommandSimulationMode.expire,
      _ => CommandSimulationMode.success,
    };
  }
}
