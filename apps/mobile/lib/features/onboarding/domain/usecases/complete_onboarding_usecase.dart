import '../../../../core/result/api_result.dart';
import '../repos/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  final OnboardingRepository _repository;

  CompleteOnboardingUseCase(this._repository);

  Future<ApiResult<void>> call() => _repository.markCompleted();
}
