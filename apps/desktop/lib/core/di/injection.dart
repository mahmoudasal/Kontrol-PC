import 'dart:io';
import 'dart:math';

import 'package:get_it/get_it.dart';
import 'package:kontrol_protocol/kontrol_protocol.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/devices/data/datasources/fake_devices_data_source.dart';
import '../../features/devices/data/repos/devices_repository_impl.dart';
import '../../features/devices/domain/repos/devices_repository.dart';
import '../../features/devices/domain/usecases/disconnect_device_usecase.dart';
import '../../features/devices/domain/usecases/revoke_device_usecase.dart';
import '../../features/devices/domain/usecases/watch_paired_devices_usecase.dart';
import '../../features/devices/presentation/cubit/devices_cubit.dart';
import '../../features/pairing/data/datasources/fake_pairing_data_source.dart';
import '../../features/pairing/data/repos/pairing_repository_impl.dart';
import '../../features/pairing/domain/repos/pairing_repository.dart';
import '../../features/pairing/domain/usecases/get_pairing_code_usecase.dart';
import '../../features/pairing/domain/usecases/regenerate_pairing_code_usecase.dart';
import '../../features/pairing/presentation/cubit/pairing_cubit.dart';
import '../../features/server/data/datasources/host_info_data_source.dart';
import '../../features/server/data/datasources/server_settings_local_data_source.dart';
import '../../features/server/data/repos/server_repository_impl.dart';
import '../../features/server/domain/repos/server_repository.dart';
import '../../features/server/domain/usecases/get_host_info_usecase.dart';
import '../../features/server/domain/usecases/get_server_controls_usecase.dart';
import '../../features/server/domain/usecases/set_paused_usecase.dart';
import '../../features/server/domain/usecases/set_require_approval_usecase.dart';
import '../../features/server/presentation/cubit/server_cubit.dart';
import '../time/clock.dart';
import '../window/window_shell.dart';

final getIt = GetIt.instance;

void configureDependencies({required WindowShell windowShell}) {
  getIt
    ..registerSingleton<WindowShell>(windowShell)
    ..registerLazySingleton<Now>(() => DateTime.now)
    ..registerLazySingleton<Ticker>(() => everySecond);

  // Server: host info + controls.
  getIt
    ..registerLazySingleton(
      () => HostInfoDataSource(
        listInterfaces: listIpv4Interfaces,
        hostname: () => Platform.localHostname,
        port: kDefaultPort,
      ),
    )
    ..registerLazySingleton(
      () => ServerSettingsLocalDataSource(SharedPreferences.getInstance),
    )
    ..registerLazySingleton<ServerRepository>(
      () => ServerRepositoryImpl(
        getIt<HostInfoDataSource>(),
        getIt<ServerSettingsLocalDataSource>(),
      ),
    )
    ..registerLazySingleton(() => GetHostInfoUseCase(getIt()))
    ..registerLazySingleton(() => GetServerControlsUseCase(getIt()))
    ..registerLazySingleton(() => SetPausedUseCase(getIt()))
    ..registerLazySingleton(() => SetRequireApprovalUseCase(getIt()))
    ..registerFactory(() => ServerCubit(getIt(), getIt(), getIt(), getIt()));

  // Pairing.
  getIt
    ..registerLazySingleton(
      () => FakePairingDataSource(random: Random.secure(), now: getIt<Now>()),
    )
    ..registerLazySingleton<PairingRepository>(
      () => PairingRepositoryImpl(getIt<FakePairingDataSource>()),
    )
    ..registerLazySingleton(() => GetPairingCodeUseCase(getIt()))
    ..registerLazySingleton(() => RegeneratePairingCodeUseCase(getIt()))
    ..registerFactory(
      () => PairingCubit(
        getIt(),
        getIt(),
        now: getIt<Now>(),
        ticker: getIt<Ticker>(),
      ),
    );

  // Paired devices.
  getIt
    ..registerLazySingleton(() => FakeDevicesDataSource(now: getIt<Now>()))
    ..registerLazySingleton<DevicesRepository>(
      () => DevicesRepositoryImpl(getIt<FakeDevicesDataSource>()),
    )
    ..registerLazySingleton(() => WatchPairedDevicesUseCase(getIt()))
    ..registerLazySingleton(() => DisconnectDeviceUseCase(getIt()))
    ..registerLazySingleton(() => RevokeDeviceUseCase(getIt()))
    ..registerFactory(() => DevicesCubit(getIt(), getIt(), getIt()));
}
