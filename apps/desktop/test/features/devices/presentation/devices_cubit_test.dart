import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/devices/data/datasources/fake_devices_data_source.dart';
import 'package:kontrol_desktop/features/devices/data/repos/devices_repository_impl.dart';
import 'package:kontrol_desktop/features/devices/domain/entities/paired_device.dart';
import 'package:kontrol_desktop/features/devices/domain/repos/devices_repository.dart';
import 'package:kontrol_desktop/features/devices/domain/usecases/disconnect_device_usecase.dart';
import 'package:kontrol_desktop/features/devices/domain/usecases/revoke_device_usecase.dart';
import 'package:kontrol_desktop/features/devices/domain/usecases/watch_paired_devices_usecase.dart';
import 'package:kontrol_desktop/features/devices/presentation/cubit/devices_cubit.dart';
import 'package:kontrol_desktop/features/devices/presentation/cubit/devices_state.dart';

class _BrokenRepo implements DevicesRepository {
  @override
  Stream<ApiResult<List<PairedDevice>>> watchDevices() =>
      Stream.value(const ApiError(UnexpectedFailure('x')));

  @override
  Future<ApiResult<void>> disconnect(String id) async =>
      const ApiError(UnexpectedFailure('x'));

  @override
  Future<ApiResult<void>> revoke(String id) async =>
      const ApiError(UnexpectedFailure('x'));
}

DevicesCubit buildDevicesCubit(DevicesRepository repo) => DevicesCubit(
  WatchPairedDevicesUseCase(repo),
  DisconnectDeviceUseCase(repo),
  RevokeDeviceUseCase(repo),
);

void main() {
  final now = DateTime(2026, 11, 1, 12);
  late DevicesCubit cubit;

  setUp(() {
    cubit = buildDevicesCubit(
      DevicesRepositoryImpl(FakeDevicesDataSource(now: () => now)),
    );
  });

  tearDown(() => cubit.close());

  List<String> ids() =>
      (cubit.state as DevicesLoaded).devices.map((d) => d.id).toList();

  test('initial state is DevicesLoading', () {
    expect(cubit.state, const DevicesLoading());
  });

  test('start emits DevicesLoaded with the paired phones', () async {
    cubit.start();
    await pumpEventQueue();
    expect(ids(), ['pixel-8', 'iphone-15']);
  });

  test('revoke removes the phone from the list', () async {
    cubit.start();
    await pumpEventQueue();
    await cubit.revoke('iphone-15');
    await pumpEventQueue();
    expect(ids(), ['pixel-8']);
  });

  test('disconnect marks the phone offline', () async {
    cubit.start();
    await pumpEventQueue();
    await cubit.disconnect('pixel-8');
    await pumpEventQueue();
    final pixel = (cubit.state as DevicesLoaded).devices.first;
    expect(pixel.presence, DeviceLastSeen(now));
  });

  test('failed action emits ActionFailed then restores the list', () async {
    cubit.start();
    await pumpEventQueue();
    final states = <DevicesState>[];
    final sub = cubit.stream.listen(states.add);

    await cubit.revoke('unknown');
    await pumpEventQueue();
    await sub.cancel();

    expect(states, hasLength(2));
    expect(states[0], isA<DevicesActionFailed>());
    expect(states[1].runtimeType, DevicesLoaded);
  });

  test('stream error emits DevicesFailed', () async {
    await cubit.close();
    cubit = buildDevicesCubit(_BrokenRepo());
    cubit.start();
    await pumpEventQueue();
    expect(cubit.state, isA<DevicesFailed>());
  });
}
