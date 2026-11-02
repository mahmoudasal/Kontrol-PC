import '../../../../core/result/api_result.dart';
import '../entities/host_info.dart';
import '../entities/server_controls.dart';

abstract class ServerRepository {
  Future<ApiResult<HostInfo>> getHostInfo();
  Future<ApiResult<ServerControls>> getControls();
  Future<ApiResult<void>> setPaused(bool paused);
  Future<ApiResult<void>> setRequireApproval(bool value);
}
