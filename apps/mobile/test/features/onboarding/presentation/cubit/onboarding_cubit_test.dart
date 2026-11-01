import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/core/error/failures.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/features/onboarding/domain/entities/onboarding_exit.dart';
import 'package:kontrol_mobile/features/onboarding/domain/repos/onboarding_repository.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/cubit/onboarding_state.dart';

class _FakeRepo implements OnboardingRepository {
  final Completer<ApiResult<void>> completer = Completer();
  int calls = 0;

  @override
  Future<ApiResult<bool>> isCompleted() => throw UnimplementedError();

  @override
  Future<ApiResult<void>> markCompleted() {
    calls++;
    return completer.future;
  }
}

void main() {
  late _FakeRepo repo;
  late OnboardingCubit cubit;

  setUp(() {
    repo = _FakeRepo();
    cubit = OnboardingCubit(CompleteOnboardingUseCase(repo));
  });

  tearDown(() => cubit.close());

  test('initial state is Viewing(0)', () {
    expect(cubit.state, const OnboardingViewing(0));
  });

  test('pageChanged updates the page', () {
    cubit.pageChanged(2);

    expect(cubit.state, const OnboardingViewing(2));
  });

  test('finish success emits Finishing then Finished persisted', () async {
    cubit.pageChanged(2);
    final emitted = <OnboardingState>[];
    final sub = cubit.stream.listen(emitted.add);

    final future = cubit.finish(OnboardingExit.devices);
    repo.completer.complete(const ApiSuccess(null));
    await future;
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(emitted, [
      const OnboardingFinishing(2, OnboardingExit.devices),
      const OnboardingFinished(2, OnboardingExit.devices, persisted: true),
    ]);
  });

  test('finish failure emits Finished not persisted', () async {
    final future = cubit.finish(OnboardingExit.pair);
    repo.completer.complete(const ApiError(CacheFailure('save failed')));
    await future;

    expect(
      cubit.state,
      const OnboardingFinished(0, OnboardingExit.pair, persisted: false),
    );
  });

  test('second finish while Finishing is ignored', () async {
    final first = cubit.finish(OnboardingExit.devices);
    await cubit.finish(OnboardingExit.pair);

    expect(repo.calls, 1);
    expect(cubit.state, const OnboardingFinishing(0, OnboardingExit.devices));

    repo.completer.complete(const ApiSuccess(null));
    await first;
  });

  test('pageChanged after Finished is ignored', () async {
    final future = cubit.finish(OnboardingExit.devices);
    repo.completer.complete(const ApiSuccess(null));
    await future;

    cubit.pageChanged(1);

    expect(cubit.state, isA<OnboardingFinished>());
    expect(cubit.state.page, 0);
  });

  test('finish completing after close does not throw', () async {
    final future = cubit.finish(OnboardingExit.devices);
    await cubit.close();

    repo.completer.complete(const ApiSuccess(null));

    await expectLater(future, completes);
  });
}
