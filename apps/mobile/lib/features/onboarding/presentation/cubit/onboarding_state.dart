import '../../domain/entities/onboarding_exit.dart';

sealed class OnboardingState {
  final int page;
  const OnboardingState(this.page);
}

final class OnboardingViewing extends OnboardingState {
  const OnboardingViewing(super.page);

  @override
  bool operator ==(Object other) =>
      other is OnboardingViewing && other.page == page;

  @override
  int get hashCode => Object.hash(OnboardingViewing, page);
}

final class OnboardingFinishing extends OnboardingState {
  final OnboardingExit exit;
  const OnboardingFinishing(super.page, this.exit);

  @override
  bool operator ==(Object other) =>
      other is OnboardingFinishing && other.page == page && other.exit == exit;

  @override
  int get hashCode => Object.hash(OnboardingFinishing, page, exit);
}

final class OnboardingFinished extends OnboardingState {
  final OnboardingExit exit;
  final bool persisted;
  const OnboardingFinished(super.page, this.exit, {required this.persisted});

  @override
  bool operator ==(Object other) =>
      other is OnboardingFinished &&
      other.page == page &&
      other.exit == exit &&
      other.persisted == persisted;

  @override
  int get hashCode => Object.hash(OnboardingFinished, page, exit, persisted);
}
