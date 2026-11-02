import '../../../../core/error/failures.dart';
import '../../../../core/result/api_result.dart';
import '../../domain/entities/host_info.dart';
import '../../domain/entities/server_controls.dart';
import '../../domain/repos/server_repository.dart';
import '../datasources/host_info_data_source.dart';
import '../datasources/server_settings_local_data_source.dart';

class ServerRepositoryImpl implements ServerRepository {
  final HostInfoDataSource _hostInfo;
  final ServerSettingsLocalDataSource _settings;

  /// Runtime only: a restart always resumes control.
  bool _paused = false;

  ServerRepositoryImpl(this._hostInfo, this._settings);

  @override
  Future<ApiResult<HostInfo>> getHostInfo() async {
    try {
      return ApiSuccess(await _hostInfo.getHostInfo());
    } on StateError {
      return const ApiError(NetworkFailure('No network connection.'));
    } catch (_) {
      return const ApiError(UnexpectedFailure('Could not read network info.'));
    }
  }

  @override
  Future<ApiResult<ServerControls>> getControls() async {
    try {
      final requireApproval = await _settings.getRequireApproval();
      return ApiSuccess(
        ServerControls(paused: _paused, requireApproval: requireApproval),
      );
    } catch (_) {
      return const ApiError(CacheFailure('Could not read settings.'));
    }
  }

  @override
  Future<ApiResult<void>> setPaused(bool paused) async {
    _paused = paused;
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<void>> setRequireApproval(bool value) async {
    try {
      await _settings.setRequireApproval(value);
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(CacheFailure('Could not save settings.'));
    }
  }
}
