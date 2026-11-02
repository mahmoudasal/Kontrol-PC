import 'dart:async';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/error/failures.dart';
import 'package:kontrol_desktop/core/result/api_result.dart';
import 'package:kontrol_desktop/features/pairing/data/datasources/fake_pairing_data_source.dart';
import 'package:kontrol_desktop/features/pairing/data/repos/pairing_repository_impl.dart';
import 'package:kontrol_desktop/features/pairing/domain/entities/pairing_code.dart';
import 'package:kontrol_desktop/features/pairing/domain/repos/pairing_repository.dart';
import 'package:kontrol_desktop/features/pairing/domain/usecases/get_pairing_code_usecase.dart';
import 'package:kontrol_desktop/features/pairing/domain/usecases/regenerate_pairing_code_usecase.dart';
import 'package:kontrol_desktop/features/pairing/presentation/cubit/pairing_cubit.dart';
import 'package:kontrol_desktop/features/pairing/presentation/cubit/pairing_state.dart';

class _FailingRepo implements PairingRepository {
  @override
  Future<ApiResult<PairingCode>> getCode() async =>
      const ApiError(UnexpectedFailure('x'));

  @override
  Future<ApiResult<PairingCode>> regenerate() async =>
      const ApiError(UnexpectedFailure('x'));
}

void main() {
  late DateTime now;
  late StreamController<void> ticks;
  late PairingCubit cubit;

  PairingCubit build(PairingRepository repo) => PairingCubit(
    GetPairingCodeUseCase(repo),
    RegeneratePairingCodeUseCase(repo),
    now: () => now,
    ticker: () => ticks.stream,
  );

  Future<void> tick(Duration elapsed) async {
    now = now.add(elapsed);
    ticks.add(null);
    await pumpEventQueue();
  }

  PairingReady ready() => cubit.state as PairingReady;

  setUp(() {
    now = DateTime(2026, 11, 1, 12);
    ticks = StreamController<void>.broadcast();
    cubit = build(
      PairingRepositoryImpl(
        FakePairingDataSource(random: Random(1), now: () => now),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
    await ticks.close();
  });

  test('initial state is PairingLoading', () {
    expect(cubit.state, const PairingLoading());
  });

  test('start emits Ready with the full five minutes', () async {
    await cubit.start();
    expect(ready().remaining, const Duration(minutes: 5));
  });

  test('a tick counts the remaining time down', () async {
    await cubit.start();
    await tick(const Duration(seconds: 1));
    expect(ready().remaining, const Duration(minutes: 4, seconds: 59));
  });

  test('a tick at expiry issues a new code', () async {
    await cubit.start();
    final first = ready().code;
    await tick(const Duration(minutes: 5));
    expect(ready().code, isNot(first));
    expect(ready().remaining, const Duration(minutes: 5));
  });

  test('regenerate replaces the code and resets the countdown', () async {
    await cubit.start();
    final first = ready().code;
    now = now.add(const Duration(minutes: 2));
    await cubit.regenerate();
    expect(ready().code, isNot(first));
    expect(ready().remaining, const Duration(minutes: 5));
  });

  test('repository failure emits PairingFailed', () async {
    await cubit.close();
    cubit = build(_FailingRepo());
    await cubit.start();
    expect(cubit.state, isA<PairingFailed>());
  });

  test('close stops listening to the ticker', () async {
    await cubit.start();
    expect(ticks.hasListener, isTrue);
    await cubit.close();
    expect(ticks.hasListener, isFalse);
  });
}
