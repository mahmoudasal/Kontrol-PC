import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../onboarding_copy.dart';

/// Step indicator. The active dot is a 24x8 pill, the rest are 8x8.
class PageDots extends StatelessWidget {
  const PageDots({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingCubit, OnboardingState, int>(
      selector: (state) => state.page,
      builder: (context, page) {
        return Semantics(
          label: OnboardingCopy.stepLabel(page, OnboardingCubit.pageCount),
          container: true,
          excludeSemantics: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: KontrolSpacing.s6,
            children: [
              for (var i = 0; i < OnboardingCubit.pageCount; i++)
                _Dot(active: i == page),
            ],
          ),
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? colors.accent : colors.outline,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
