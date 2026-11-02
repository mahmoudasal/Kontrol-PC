import '../../domain/entities/pairing_code.dart';

sealed class PairingState {
  const PairingState();
}

final class PairingLoading extends PairingState {
  const PairingLoading();
}

final class PairingReady extends PairingState {
  final PairingCode code;

  /// Time until [code] expires, never negative.
  final Duration remaining;

  const PairingReady(this.code, this.remaining);

  @override
  bool operator ==(Object other) =>
      other is PairingReady &&
      other.code == code &&
      other.remaining == remaining;

  @override
  int get hashCode => Object.hash(code, remaining);
}

final class PairingFailed extends PairingState {
  final String message;

  const PairingFailed(this.message);

  @override
  bool operator ==(Object other) =>
      other is PairingFailed && other.message == message;

  @override
  int get hashCode => Object.hash(PairingFailed, message);
}
