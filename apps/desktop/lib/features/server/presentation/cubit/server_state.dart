import '../../domain/entities/host_info.dart';
import '../../domain/entities/server_controls.dart';

sealed class ServerState {
  const ServerState();
}

final class ServerLoading extends ServerState {
  const ServerLoading();
}

class ServerRunning extends ServerState {
  final HostInfo host;
  final ServerControls controls;

  const ServerRunning(this.host, this.controls);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is ServerRunning &&
      other.host == host &&
      other.controls == controls;

  @override
  int get hashCode => Object.hash(runtimeType, host, controls);
}

/// One-shot: a toggle failed. The cubit re-emits [ServerRunning] right after.
final class ServerActionFailed extends ServerRunning {
  final String message;

  const ServerActionFailed(super.host, super.controls, this.message);

  @override
  bool operator ==(Object other) =>
      other is ServerActionFailed && super == other && other.message == message;

  @override
  int get hashCode => Object.hash(super.hashCode, message);
}

final class ServerFailed extends ServerState {
  final String message;

  const ServerFailed(this.message);

  @override
  bool operator ==(Object other) =>
      other is ServerFailed && other.message == message;

  @override
  int get hashCode => Object.hash(ServerFailed, message);
}
