import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result/api_result.dart';
import '../../domain/entities/server_controls.dart';
import '../../domain/usecases/get_host_info_usecase.dart';
import '../../domain/usecases/get_server_controls_usecase.dart';
import '../../domain/usecases/set_paused_usecase.dart';
import '../../domain/usecases/set_require_approval_usecase.dart';
import 'server_state.dart';

class ServerCubit extends Cubit<ServerState> {
  final GetHostInfoUseCase _getHostInfo;
  final GetServerControlsUseCase _getControls;
  final SetPausedUseCase _setPaused;
  final SetRequireApprovalUseCase _setRequireApproval;

  ServerCubit(
    this._getHostInfo,
    this._getControls,
    this._setPaused,
    this._setRequireApproval,
  ) : super(const ServerLoading());

  Future<void> load() async {
    emit(const ServerLoading());
    final host = await _getHostInfo();
    final controls = await _getControls();
    switch ((host, controls)) {
      case (ApiSuccess(data: final h), ApiSuccess(data: final c)):
        emit(ServerRunning(h, c));
      case (ApiError(:final failure), _) || (_, ApiError(:final failure)):
        emit(ServerFailed(_message(failure)));
    }
  }

  Future<void> togglePaused() async {
    final current = state;
    if (current is! ServerRunning) return;
    final paused = !current.controls.paused;
    await _apply(
      (controls) => controls.copyWith(paused: paused),
      () => _setPaused(paused),
    );
  }

  Future<void> setRequireApproval(bool value) async {
    final current = state;
    if (current is! ServerRunning) return;
    if (current.controls.requireApproval == value) return;
    await _apply(
      (controls) => controls.copyWith(requireApproval: value),
      () => _setRequireApproval(value),
    );
  }

  /// Applies [change] to the state as it is after [action] completes, so
  /// overlapping writes don't overwrite each other.
  Future<void> _apply(
    ServerControls Function(ServerControls) change,
    Future<ApiResult<void>> Function() action,
  ) async {
    final result = await action();
    if (isClosed) return;
    final latest = state;
    if (latest is! ServerRunning) return;
    switch (result) {
      case ApiSuccess():
        emit(ServerRunning(latest.host, change(latest.controls)));
      case ApiError(:final failure):
        emit(
          ServerActionFailed(latest.host, latest.controls, _message(failure)),
        );
        emit(ServerRunning(latest.host, latest.controls));
    }
  }

  String _message(Failure failure) => switch (failure) {
    NetworkFailure() => 'No network connection. Connect this PC to Wi-Fi.',
    CacheFailure() => 'Could not save that setting. Try again.',
    UnexpectedFailure() => 'Something went wrong. Restart Kontrol Server.',
  };
}
