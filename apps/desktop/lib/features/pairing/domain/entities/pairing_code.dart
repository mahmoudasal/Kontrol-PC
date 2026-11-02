/// A short-lived code a phone uses to pair, by QR scan or by typing the PIN.
class PairingCode {
  /// Six digits. Never log this.
  final String pin;

  /// Encoded into the QR code.
  final String qrPayload;
  final DateTime expiresAt;

  const PairingCode({
    required this.pin,
    required this.qrPayload,
    required this.expiresAt,
  });

  @override
  bool operator ==(Object other) =>
      other is PairingCode &&
      other.pin == pin &&
      other.qrPayload == qrPayload &&
      other.expiresAt == expiresAt;

  @override
  int get hashCode => Object.hash(pin, qrPayload, expiresAt);

  @override
  String toString() => 'PairingCode(expiresAt: $expiresAt)';
}
