import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/result/api_result.dart';
import '../../domain/entities/onboarding_exit.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  static const pageCount = 3;

  final CompleteOnboardingUseCase _completeOnboarding;

  OnboardingCubit(this._completeOnboarding) : super(const OnboardingViewing(0));

  void pageChanged(int page) {
    if (state is! OnboardingViewing) return;
    emit(OnboardingViewing(page));
  }

  Future<void> finish(OnboardingExit exit) async {
    if (state is! OnboardingViewing) return;
    final page = state.page;
    emit(OnboardingFinishing(page, exit));
    final result = await _completeOnboarding();
    if (isClosed) return;
    emit(OnboardingFinished(page, exit, persisted: result is ApiSuccess));
  }
}
