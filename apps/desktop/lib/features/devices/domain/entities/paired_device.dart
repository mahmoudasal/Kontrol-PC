enum DevicePlatform { android, ios }

/// Whether a paired phone is connected right now.
sealed class DevicePresence {
  const DevicePresence();
}

final class DeviceConnected extends DevicePresence {
  const DeviceConnected();

  @override
  bool operator ==(Object other) => other is DeviceConnected;

  @override
  int get hashCode => (DeviceConnected).hashCode;
}

final class DeviceLastSeen extends DevicePresence {
  final DateTime at;

  const DeviceLastSeen(this.at);

  @override
  bool operator ==(Object other) => other is DeviceLastSeen && other.at == at;

  @override
  int get hashCode => Object.hash(DeviceLastSeen, at);
}

/// A phone that has paired with this PC.
class PairedDevice {
  final String id;
  final String name;
  final DevicePlatform platform;
  final DevicePresence presence;

  const PairedDevice({
    required this.id,
    required this.name,
    required this.platform,
    required this.presence,
  });

  PairedDevice copyWith({DevicePresence? presence}) {
    return PairedDevice(
      id: id,
      name: name,
      platform: platform,
      presence: presence ?? this.presence,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PairedDevice &&
      other.id == id &&
      other.name == name &&
      other.platform == platform &&
      other.presence == presence;

  @override
  int get hashCode => Object.hash(id, name, platform, presence);
}
