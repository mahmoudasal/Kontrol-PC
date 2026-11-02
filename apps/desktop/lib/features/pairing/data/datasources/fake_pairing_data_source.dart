import 'dart:math';

import '../../../../core/time/clock.dart';
import '../../domain/entities/pairing_code.dart';

/// Issues pairing codes locally until the real pairing handshake exists.
class FakePairingDataSource {
  static const ttl = Duration(minutes: 5);

  final Random _random;
  final Now _now;
  PairingCode? _current;

  /// Pass [Random.secure] in production; a seeded [Random] in tests.
  FakePairingDataSource({required this._random, required this._now});

  PairingCode getCode() {
    final current = _current;
    if (current != null && current.expiresAt.isAfter(_now())) return current;
    return regenerate();
  }

  PairingCode regenerate() {
    final pin = List.generate(6, (_) => _random.nextInt(10)).join();
    // Placeholder until the QR payload is specified in kontrol_protocol.
    return _current = PairingCode(
      pin: pin,
      qrPayload: 'kontrol://pair?pin=$pin',
      expiresAt: _now().add(ttl),
    );
  }
}
