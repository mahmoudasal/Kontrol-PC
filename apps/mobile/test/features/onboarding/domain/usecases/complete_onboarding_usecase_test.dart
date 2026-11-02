import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/features/onboarding/domain/repos/onboarding_repository.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';

class _FakeRepo implements OnboardingRepository {
  int calls = 0;

  @override
  Future<ApiResult<bool>> isCompleted() => throw UnimplementedError();

  @override
  Future<ApiResult<void>> markCompleted() async {
    calls++;
    return const ApiSuccess(null);
  }
}

void main() {
  test('delegates to repository', () async {
    final repo = _FakeRepo();

    final result = await CompleteOnboardingUseCase(repo)();

    expect(repo.calls, 1);
    expect(result, isA<ApiSuccess<void>>());
  });
}
