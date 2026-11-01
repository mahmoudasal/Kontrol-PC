import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../domain/entities/onboarding_exit.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../onboarding_copy.dart';

/// Fixed header: brand on the start side, Skip on the end side.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(child: _Brand()),
          _SkipButton(),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: KontrolSpacing.s10,
      children: [
        const KontrolLogo(size: 28, excludeSemantics: true),
        Flexible(
          child: Text(
            OnboardingCopy.brand,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KontrolTypography.brand.copyWith(
              color: context.kColors.text,
            ),
          ),
        ),
      ],
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      OnboardingCubit,
      OnboardingState,
      ({bool visible, bool enabled})
    >(
      selector: (state) => (
        visible: state.page != OnboardingCubit.pageCount - 1,
        enabled: state is! OnboardingFinishing,
      ),
      builder: (context, skip) {
        return Visibility(
          visible: skip.visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 48),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
              foregroundColor: context.kColors.text2,
              textStyle: KontrolTypography.label,
            ),
            onPressed: skip.enabled
                ? () => context.read<OnboardingCubit>().finish(
                    OnboardingExit.devices,
                  )
                : null,
            child: const Text(OnboardingCopy.skip),
          ),
        );
      },
    );
  }
}
