import '../../features/onboarding/domain/usecases/is_onboarding_completed_usecase.dart';
import '../result/api_result.dart';
import 'app_routes.dart';

/// Picks the first route: Devices once onboarding is done, otherwise
/// onboarding. A failed read falls back to onboarding.
Future<String> resolveInitialLocation(
  IsOnboardingCompletedUseCase isOnboardingCompleted,
) async {
  return switch (await isOnboardingCompleted()) {
    ApiSuccess(data: true) => AppRoutes.devices,
    _ => AppRoutes.onboarding,
  };
}
