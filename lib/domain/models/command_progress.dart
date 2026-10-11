// Describes each local state emitted by a simulated socket command.
enum CommandState { pending, acknowledged, executed, failed, expired, blocked }

class CommandProgress {
  const CommandProgress({
    required this.commandId,
    required this.socketId,
    required this.targetRelay,
    required this.state,
    this.message,
  });

  final String commandId;
  final String socketId;
  final bool targetRelay;
  final CommandState state;
  final String? message;
}
