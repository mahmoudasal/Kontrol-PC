import 'dart:async';

import '../../../../core/time/clock.dart';
import '../../domain/entities/paired_device.dart';

/// In-memory paired phones until the real server keeps a device store.
class FakeDevicesDataSource {
  final Now _now;
  final _changes = StreamController<List<PairedDevice>>.broadcast();
  late List<PairedDevice> _devices;

  FakeDevicesDataSource({required Now now, List<PairedDevice>? seed})
    : _now = now {
    _devices = List.unmodifiable(seed ?? _sample(now()));
  }

  static List<PairedDevice> _sample(DateTime now) => [
    const PairedDevice(
      id: 'pixel-8',
      name: 'Pixel 8',
      platform: DevicePlatform.android,
      presence: DeviceConnected(),
    ),
    PairedDevice(
      id: 'iphone-15',
      name: 'iPhone 15',
      platform: DevicePlatform.ios,
      presence: DeviceLastSeen(now.subtract(const Duration(days: 3))),
    ),
  ];

  /// Emits the current list on listen, then every change. Subscribing and
  /// reading the current list happen together, so no change is missed.
  Stream<List<PairedDevice>> watch() {
    StreamSubscription<List<PairedDevice>>? changes;
    late final StreamController<List<PairedDevice>> controller;
    controller = StreamController(
      onListen: () {
        controller.add(_devices);
        changes = _changes.stream.listen(controller.add);
      },
      onCancel: () => changes?.cancel(),
    );
    return controller.stream;
  }

  /// Throws [StateError] for an unknown [id].
  void disconnect(String id) {
    _update(
      _devices.map(
        (d) => d.id == id ? d.copyWith(presence: DeviceLastSeen(_now())) : d,
      ),
      id,
    );
  }

  /// Throws [StateError] for an unknown [id].
  void revoke(String id) {
    _update(_devices.where((d) => d.id != id), id);
  }

  void _update(Iterable<PairedDevice> next, String id) {
    if (!_devices.any((d) => d.id == id)) {
      throw StateError('Unknown device.');
    }
    _devices = List.unmodifiable(next);
    _changes.add(_devices);
  }
}
