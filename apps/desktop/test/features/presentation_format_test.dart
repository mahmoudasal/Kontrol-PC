import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/features/devices/domain/entities/paired_device.dart';
import 'package:kontrol_desktop/features/devices/presentation/widgets/device_status_text.dart';
import 'package:kontrol_desktop/features/pairing/presentation/widgets/pairing_panel.dart';

PairedDevice _device(DevicePresence presence) => PairedDevice(
  id: 'id',
  name: 'Phone',
  platform: DevicePlatform.ios,
  presence: presence,
);

void main() {
  final now = DateTime(2026, 11, 1, 12);

  group('formatCountdown', () {
    test('full five minutes reads 5:00', () {
      expect(formatCountdown(const Duration(minutes: 5)), '5:00');
    });

    test('rounds partial seconds up', () {
      expect(formatCountdown(const Duration(milliseconds: 271500)), '4:32');
    });

    test('zero reads 0:00', () {
      expect(formatCountdown(Duration.zero), '0:00');
    });
  });

  group('deviceStatusText', () {
    test('connected android phone', () {
      final d = PairedDevice(
        id: 'id',
        name: 'Pixel',
        platform: DevicePlatform.android,
        presence: const DeviceConnected(),
      );
      expect(deviceStatusText(d, now), 'Connected now · Android');
    });

    test('seen three days ago', () {
      final at = now.subtract(const Duration(days: 3));
      expect(
        deviceStatusText(_device(DeviceLastSeen(at)), now),
        'Last seen 3 days ago · iOS',
      );
    });

    test('seen yesterday', () {
      final at = now.subtract(const Duration(hours: 30));
      expect(
        deviceStatusText(_device(DeviceLastSeen(at)), now),
        'Last seen yesterday · iOS',
      );
    });

    test('seen one hour ago is singular', () {
      final at = now.subtract(const Duration(minutes: 61));
      expect(
        deviceStatusText(_device(DeviceLastSeen(at)), now),
        'Last seen 1 hour ago · iOS',
      );
    });

    test('seen seconds ago reads just now', () {
      final at = now.subtract(const Duration(seconds: 20));
      expect(
        deviceStatusText(_device(DeviceLastSeen(at)), now),
        'Last seen just now · iOS',
      );
    });
  });
}
