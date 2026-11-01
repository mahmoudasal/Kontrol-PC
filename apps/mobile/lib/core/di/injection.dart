import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/onboarding/data/datasources/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repos/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repos/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton(
    () => OnboardingLocalDataSource(SharedPreferences.getInstance),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(getIt<OnboardingLocalDataSource>()),
  );
  getIt.registerLazySingleton(
    () => IsOnboardingCompletedUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteOnboardingUseCase(getIt<OnboardingRepository>()),
  );
  getIt.registerFactory(
    () => OnboardingCubit(getIt<CompleteOnboardingUseCase>()),
  );
}
