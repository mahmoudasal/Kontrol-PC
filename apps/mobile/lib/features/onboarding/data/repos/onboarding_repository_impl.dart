import '../../../../core/error/failures.dart';
import '../../../../core/result/api_result.dart';
import '../../domain/repos/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _dataSource;

  OnboardingRepositoryImpl(this._dataSource);

  @override
  Future<ApiResult<bool>> isCompleted() async {
    try {
      return ApiSuccess(await _dataSource.isCompleted());
    } catch (_) {
      return const ApiError(CacheFailure('Could not read onboarding state.'));
    }
  }

  @override
  Future<ApiResult<void>> markCompleted() async {
    try {
      await _dataSource.markCompleted();
      return const ApiSuccess(null);
    } catch (_) {
      return const ApiError(CacheFailure('Could not save onboarding state.'));
    }
  }
}
