import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/server/data/datasources/host_info_data_source.dart';
import 'package:kontrol_desktop/features/server/data/datasources/server_settings_local_data_source.dart';
import 'package:kontrol_desktop/features/server/data/repos/server_repository_impl.dart';
import 'package:kontrol_desktop/features/server/domain/entities/server_controls.dart';
import 'package:shared_preferences/shared_preferences.dart';

ServerRepositoryImpl _repo({
  InterfaceLister? lister,
  Future<SharedPreferences> Function()? prefs,
}) {
  return ServerRepositoryImpl(
    HostInfoDataSource(
      listInterfaces: lister ?? () async => [],
      hostname: () => 'PC',
      port: 7531,
    ),
    ServerSettingsLocalDataSource(prefs ?? SharedPreferences.getInstance),
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('no interface maps to NetworkFailure', () async {
    final result = await _repo().getHostInfo();
    expect(result, isA<ApiError<dynamic>>());
    expect((result as ApiError).failure, isA<NetworkFailure>());
  });

  test('unexpected lister error maps to UnexpectedFailure', () async {
    final result = await _repo(lister: () async => throw Exception('boom'))
        .getHostInfo();
    expect((result as ApiError).failure, isA<UnexpectedFailure>());
  });

  test('controls default to not paused and approval required', () async {
    final result = await _repo().getControls();
    expect(
      (result as ApiSuccess<ServerControls>).data,
      const ServerControls(paused: false, requireApproval: true),
    );
  });

  test('setRequireApproval persists across repository instances', () async {
    await _repo().setRequireApproval(false);
    final result = await _repo().getControls();
    expect((result as ApiSuccess<ServerControls>).data.requireApproval, false);
  });

  test('setPaused is reflected in getControls', () async {
    final repo = _repo();
    await repo.setPaused(true);
    final result = await repo.getControls();
    expect((result as ApiSuccess<ServerControls>).data.paused, true);
  });

  test('settings read error maps to CacheFailure', () async {
    final result = await _repo(prefs: () async => throw Exception('disk'))
        .getControls();
    expect((result as ApiError).failure, isA<CacheFailure>());
  });

  test('settings write error maps to CacheFailure', () async {
    final result = await _repo(prefs: () async => throw Exception('disk'))
        .setRequireApproval(false);
    expect((result as ApiError).failure, isA<CacheFailure>());
  });
}
