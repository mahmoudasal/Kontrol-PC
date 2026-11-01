import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/core/error/failures.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/core/router/app_routes.dart';
import 'package:kontrol_mobile/core/router/initial_location.dart';
import 'package:kontrol_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:kontrol_mobile/features/onboarding/data/repos/onboarding_repository_impl.dart';
import 'package:kontrol_mobile/features/onboarding/domain/repos/onboarding_repository.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart';

class _FakeRepo implements OnboardingRepository {
  _FakeRepo(this.result);

  final ApiResult<bool> result;

  @override
  Future<ApiResult<bool>> isCompleted() async => result;

  @override
  Future<ApiResult<void>> markCompleted() => throw UnimplementedError();
}

Future<String> _resolve(OnboardingRepository repo) =>
    resolveInitialLocation(IsOnboardingCompletedUseCase(repo));

void main() {
  test('completed onboarding starts on Devices', () async {
    expect(
      await _resolve(_FakeRepo(const ApiSuccess(true))),
      AppRoutes.devices,
    );
  });

  test('pending onboarding starts on Onboarding', () async {
    expect(
      await _resolve(_FakeRepo(const ApiSuccess(false))),
      AppRoutes.onboarding,
    );
  });

  test('a failed read falls back to Onboarding', () async {
    expect(
      await _resolve(_FakeRepo(const ApiError(CacheFailure('read failed')))),
      AppRoutes.onboarding,
    );
  });

  test('a SharedPreferences load failure falls back to Onboarding', () async {
    final repo = OnboardingRepositoryImpl(
      OnboardingLocalDataSource(
        () => Future.error(StateError('prefs unavailable')),
      ),
    );

    expect(await _resolve(repo), AppRoutes.onboarding);
  });
}
