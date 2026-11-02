import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../di/injection.dart';
import 'app_routes.dart';
import 'placeholder_screen.dart';

GoRouter createRouter({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<OnboardingCubit>(),
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.devices,
        builder: (context, state) => const PlaceholderScreen(title: 'Devices'),
      ),
      GoRoute(
        path: AppRoutes.pair,
        builder: (context, state) => const PlaceholderScreen(title: 'Pair'),
      ),
    ],
  );
}
