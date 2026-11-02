import 'dart:async';

import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/features/onboarding/domain/repos/onboarding_repository.dart';

/// Hand-written fake with a configurable [result] and a call counter.
///
/// Set [pending] to hold `markCompleted` open until the test completes it.
class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.result = const ApiSuccess<void>(null)});

  ApiResult<void> result;
  Completer<ApiResult<void>>? pending;
  int markCompletedCalls = 0;

  @override
  Future<ApiResult<bool>> isCompleted() => throw UnimplementedError();

  @override
  Future<ApiResult<void>> markCompleted() {
    markCompletedCalls++;
    return pending?.future ?? Future.value(result);
  }
}
