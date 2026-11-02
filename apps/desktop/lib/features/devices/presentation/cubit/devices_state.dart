import '../../domain/entities/paired_device.dart';

sealed class DevicesState {
  const DevicesState();
}

final class DevicesLoading extends DevicesState {
  const DevicesLoading();
}

class DevicesLoaded extends DevicesState {
  final List<PairedDevice> devices;

  const DevicesLoaded(this.devices);

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is DevicesLoaded &&
      _listEquals(other.devices, devices);

  @override
  int get hashCode => Object.hash(runtimeType, Object.hashAll(devices));
}

/// One-shot: an action failed. The cubit re-emits [DevicesLoaded] right after.
final class DevicesActionFailed extends DevicesLoaded {
  final String message;

  const DevicesActionFailed(super.devices, this.message);

  @override
  bool operator ==(Object other) =>
      other is DevicesActionFailed &&
      super == other &&
      other.message == message;

  @override
  int get hashCode => Object.hash(super.hashCode, message);
}

final class DevicesFailed extends DevicesState {
  final String message;

  const DevicesFailed(this.message);

  @override
  bool operator ==(Object other) =>
      other is DevicesFailed && other.message == message;

  @override
  int get hashCode => Object.hash(DevicesFailed, message);
}

bool _listEquals(List<PairedDevice> a, List<PairedDevice> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
