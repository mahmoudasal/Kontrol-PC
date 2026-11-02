import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/api_result.dart';
import '../../../../core/time/clock.dart';
import '../../domain/entities/pairing_code.dart';
import '../../domain/usecases/get_pairing_code_usecase.dart';
import '../../domain/usecases/regenerate_pairing_code_usecase.dart';
import 'pairing_state.dart';

class PairingCubit extends Cubit<PairingState> {
  final GetPairingCodeUseCase _getCode;
  final RegeneratePairingCodeUseCase _regenerate;
  final Now _now;
  final Ticker _ticker;

  StreamSubscription<void>? _ticks;
  bool _regenerating = false;

  PairingCubit(
    this._getCode,
    this._regenerate, {
    required this._now,
    required this._ticker,
  }) : super(const PairingLoading());

  Future<void> start() async {
    emit(const PairingLoading());
    _show(await _getCode());
    _ticks ??= _ticker().listen((_) => _onTick());
  }

  /// "New code now", and retry after a failure.
  Future<void> regenerate() async {
    if (_regenerating) return;
    _regenerating = true;
    try {
      _show(await _regenerate());
    } finally {
      _regenerating = false;
    }
  }

  void _onTick() {
    final current = state;
    if (current is! PairingReady) return;
    final remaining = _remaining(current.code);
    if (remaining == Duration.zero) {
      regenerate();
    } else {
      emit(PairingReady(current.code, remaining));
    }
  }

  void _show(ApiResult<PairingCode> result) {
    if (isClosed) return;
    switch (result) {
      case ApiSuccess(data: final code):
        emit(PairingReady(code, _remaining(code)));
      case ApiError():
        emit(const PairingFailed('Could not create a pairing code.'));
    }
  }

  Duration _remaining(PairingCode code) {
    final left = code.expiresAt.difference(_now());
    return left.isNegative ? Duration.zero : left;
  }

  @override
  Future<void> close() async {
    await _ticks?.cancel();
    return super.close();
  }
}
