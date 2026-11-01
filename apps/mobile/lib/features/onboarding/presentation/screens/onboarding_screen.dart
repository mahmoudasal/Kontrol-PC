import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/entities/onboarding_exit.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../onboarding_copy.dart';
import '../widgets/connect_slide.dart';
import '../widgets/install_slide.dart';
import '../widgets/onboarding_footer.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/welcome_slide.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageDuration = Duration(milliseconds: 300);
  static const _pageCurve = Curves.easeOutCubic;

  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() =>
      _controller.nextPage(duration: _pageDuration, curve: _pageCurve);

  void _previous() =>
      _controller.previousPage(duration: _pageDuration, curve: _pageCurve);

  void _onFinished(BuildContext context, OnboardingState state) {
    if (state is! OnboardingFinished) return;
    // Show before navigating: the app-level messenger carries it over.
    if (!state.persisted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(OnboardingCopy.saveFailed)));
    }
    context.go(switch (state.exit) {
      OnboardingExit.devices => AppRoutes.devices,
      OnboardingExit.pair => AppRoutes.pair,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 12, 24, 32),
          child: Column(
            children: [
              const OnboardingHeader(),
              Expanded(
                child: _Pager(
                  controller: _controller,
                  onPageChanged: context.read<OnboardingCubit>().pageChanged,
                ),
              ),
              OnboardingFooter(onNext: _next),
            ],
          ),
        ),
      ),
    );

    return BlocListener<OnboardingCubit, OnboardingState>(
      listenWhen: (_, current) => current is OnboardingFinished,
      listener: _onFinished,
      // Only PopScope rebuilds on page/busy changes; the scaffold is reused.
      child:
          BlocSelector<
            OnboardingCubit,
            OnboardingState,
            ({bool firstPage, bool busy})
          >(
            selector: (state) =>
                (firstPage: state.page == 0, busy: state is! OnboardingViewing),
            builder: (context, nav) => PopScope(
              canPop: nav.firstPage && !nav.busy,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop && !nav.busy) _previous();
              },
              child: scaffold,
            ),
          ),
    );
  }
}

/// The slides. Swiping is locked once an exit is chosen, so the visible slide
/// can't drift from the cubit's page while the flag is being saved.
class _Pager extends StatelessWidget {
  const _Pager({required this.controller, required this.onPageChanged});

  final PageController controller;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingCubit, OnboardingState, bool>(
      selector: (state) => state is! OnboardingViewing,
      builder: (context, busy) => PageView(
        controller: controller,
        physics: busy ? const NeverScrollableScrollPhysics() : null,
        onPageChanged: onPageChanged,
        children: const [WelcomeSlide(), InstallSlide(), ConnectSlide()],
      ),
    );
  }
}
