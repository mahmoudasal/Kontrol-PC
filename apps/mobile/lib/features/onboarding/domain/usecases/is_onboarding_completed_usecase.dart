import '../../../../core/result/api_result.dart';
import '../repos/onboarding_repository.dart';

class IsOnboardingCompletedUseCase {
  final OnboardingRepository _repository;

  IsOnboardingCompletedUseCase(this._repository);

  Future<ApiResult<bool>> call() => _repository.isCompleted();
}
