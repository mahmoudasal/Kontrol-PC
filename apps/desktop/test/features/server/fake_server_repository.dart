import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/server/domain/entities/host_info.dart';
import 'package:kontrol_desktop/features/server/domain/entities/server_controls.dart';
import 'package:kontrol_desktop/features/server/domain/repos/server_repository.dart';

const sampleHost = HostInfo(
  pcName: 'LIVING-ROOM-PC',
  address: '192.168.1.24',
  port: 7531,
  networkName: 'Wi-Fi',
);

class FakeServerRepository implements ServerRepository {
  ApiResult<HostInfo> hostResult = const ApiSuccess(sampleHost);
  ServerControls controls = const ServerControls(
    paused: false,
    requireApproval: true,
  );
  bool failWrites = false;

  @override
  Future<ApiResult<HostInfo>> getHostInfo() async => hostResult;

  @override
  Future<ApiResult<ServerControls>> getControls() async => ApiSuccess(controls);

  @override
  Future<ApiResult<void>> setPaused(bool paused) async =>
      _write(() => controls = controls.copyWith(paused: paused));

  @override
  Future<ApiResult<void>> setRequireApproval(bool value) async =>
      _write(() => controls = controls.copyWith(requireApproval: value));

  ApiResult<void> _write(void Function() apply) {
    if (failWrites) return const ApiError(CacheFailure('write failed'));
    apply();
    return const ApiSuccess(null);
  }
}
