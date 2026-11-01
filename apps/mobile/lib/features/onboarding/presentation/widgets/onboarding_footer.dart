import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';

import '../../domain/entities/onboarding_exit.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../onboarding_copy.dart';
import 'page_dots.dart';

/// Fixed footer: step dots, then the call-to-action(s) for the current slide.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key, required this.onNext});

  /// Advances to the next slide. The screen owns the page controller.
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: KontrolSpacing.s20,
      children: [
        const PageDots(),
        BlocSelector<
          OnboardingCubit,
          OnboardingState,
          ({bool isLast, bool busy})
        >(
          selector: (state) => (
            isLast: state.page == OnboardingCubit.pageCount - 1,
            busy: state is OnboardingFinishing,
          ),
          builder: (context, cta) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: AlignmentDirectional.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: cta.isLast
                    ? _FinalActions(
                        key: const ValueKey('final'),
                        busy: cta.busy,
                      )
                    : _NextButton(
                        key: const ValueKey('next'),
                        onPressed: cta.busy ? null : onNext,
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      child: const Text(OnboardingCopy.next),
    );
  }
}

class _FinalActions extends StatelessWidget {
  const _FinalActions({super.key, required this.busy});

  final bool busy;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: KontrolSpacing.s8,
      children: [
        FilledButton.icon(
          onPressed: busy ? null : () => cubit.finish(OnboardingExit.devices),
          icon: const Icon(LucideIcons400.search, size: 20),
          label: const Text(OnboardingCopy.findMyPc),
        ),
        TextButton(
          onPressed: busy ? null : () => cubit.finish(OnboardingExit.pair),
          child: const Text(OnboardingCopy.scanQrInstead),
        ),
      ],
    );
  }
}
