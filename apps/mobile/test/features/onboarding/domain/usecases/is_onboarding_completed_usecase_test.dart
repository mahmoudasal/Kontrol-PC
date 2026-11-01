import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/features/onboarding/domain/repos/onboarding_repository.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart';

class _FakeRepo implements OnboardingRepository {
  int calls = 0;

  @override
  Future<ApiResult<bool>> isCompleted() async {
    calls++;
    return const ApiSuccess(true);
  }

  @override
  Future<ApiResult<void>> markCompleted() => throw UnimplementedError();
}

void main() {
  test('delegates to repository', () async {
    final repo = _FakeRepo();

    final result = await IsOnboardingCompletedUseCase(repo)();

    expect(repo.calls, 1);
    expect((result as ApiSuccess<bool>).data, isTrue);
  });
}
