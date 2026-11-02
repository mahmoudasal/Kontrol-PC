import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/devices/data/datasources/fake_devices_data_source.dart';
import 'package:kontrol_desktop/features/devices/data/repos/devices_repository_impl.dart';
import 'package:kontrol_desktop/features/devices/domain/entities/paired_device.dart';

void main() {
  final now = DateTime(2026, 11, 1, 12);
  late DevicesRepositoryImpl repo;

  setUp(() {
    repo = DevicesRepositoryImpl(FakeDevicesDataSource(now: () => now));
  });

  Future<List<PairedDevice>> latest() async {
    final first = await repo.watchDevices().first;
    return (first as ApiSuccess<List<PairedDevice>>).data;
  }

  test('sample data has one connected and one offline phone', () async {
    final devices = await latest();
    expect(devices.map((d) => d.name), ['Pixel 8', 'iPhone 15']);
    expect(devices[0].presence, const DeviceConnected());
    expect(
      devices[1].presence,
      DeviceLastSeen(now.subtract(const Duration(days: 3))),
    );
  });

  test('revoke removes the phone', () async {
    await repo.revoke('iphone-15');
    expect((await latest()).map((d) => d.id), ['pixel-8']);
  });

  test('disconnect marks the phone last seen now', () async {
    await repo.disconnect('pixel-8');
    expect((await latest()).first.presence, DeviceLastSeen(now));
  });

  test('watch emits the new list after a change', () async {
    final next = repo.watchDevices().skip(1).first;
    await repo.revoke('pixel-8');
    final result = await next as ApiSuccess<List<PairedDevice>>;
    expect(result.data.map((d) => d.id), ['iphone-15']);
  });

  test('revoking an unknown phone returns ApiError', () async {
    expect(await repo.revoke('nope'), isA<ApiError<void>>());
  });

  test('disconnecting an unknown phone returns ApiError', () async {
    expect(await repo.disconnect('nope'), isA<ApiError<void>>());
  });
}
