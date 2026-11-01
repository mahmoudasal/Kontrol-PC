import '../../../../core/result/api_result.dart';

abstract class OnboardingRepository {
  Future<ApiResult<bool>> isCompleted();
  Future<ApiResult<void>> markCompleted();
}
