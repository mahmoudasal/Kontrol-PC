import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/api_result.dart';
import '../../domain/entities/paired_device.dart';
import '../../domain/usecases/disconnect_device_usecase.dart';
import '../../domain/usecases/revoke_device_usecase.dart';
import '../../domain/usecases/watch_paired_devices_usecase.dart';
import 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  final WatchPairedDevicesUseCase _watch;
  final DisconnectDeviceUseCase _disconnect;
  final RevokeDeviceUseCase _revoke;

  StreamSubscription<ApiResult<List<PairedDevice>>>? _subscription;

  DevicesCubit(this._watch, this._disconnect, this._revoke)
    : super(const DevicesLoading());

  void start() {
    _subscription ??= _watch().listen((result) {
      switch (result) {
        case ApiSuccess(data: final devices):
          emit(DevicesLoaded(devices));
        case ApiError():
          emit(const DevicesFailed('Could not load paired devices.'));
      }
    });
  }

  Future<void> disconnect(String id) =>
      _run(() => _disconnect(id), 'Could not disconnect. Try again.');

  Future<void> revoke(String id) =>
      _run(() => _revoke(id), 'Could not revoke. Try again.');

  Future<void> _run(
    Future<ApiResult<void>> Function() action,
    String failureMessage,
  ) async {
    final result = await action();
    final current = state;
    if (isClosed || result is ApiSuccess || current is! DevicesLoaded) return;
    // Success needs no emit: the watch stream delivers the new list.
    emit(DevicesActionFailed(current.devices, failureMessage));
    emit(DevicesLoaded(current.devices));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
