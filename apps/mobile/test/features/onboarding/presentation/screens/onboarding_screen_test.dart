import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:kontrol_mobile/core/constants/links.dart';
import 'package:kontrol_mobile/core/error/failures.dart';
import 'package:kontrol_mobile/core/result/api_result.dart';
import 'package:kontrol_mobile/core/router/app_routes.dart';
import 'package:kontrol_mobile/core/router/placeholder_screen.dart';
import 'package:kontrol_mobile/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/onboarding_copy.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../fake_onboarding_repository.dart';

void main() {
  late FakeOnboardingRepository repo;

  setUp(() => repo = FakeOnboardingRepository());

  Future<void> pumpApp(
    WidgetTester tester, {
    double textScale = 1,
    TextDirection textDirection = TextDirection.ltr,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: AppRoutes.onboarding,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (_, _) => BlocProvider(
            create: (_) => OnboardingCubit(CompleteOnboardingUseCase(repo)),
            child: const OnboardingScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.devices,
          builder: (_, _) => const PlaceholderScreen(title: 'Devices'),
        ),
        GoRoute(
          path: AppRoutes.pair,
          builder: (_, _) => const PlaceholderScreen(title: 'Pair'),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(
        theme: KontrolTheme.dark(),
        routerConfig: router,
        builder: (context, child) => Directionality(
          textDirection: textDirection,
          child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> goToLastSlide(WidgetTester tester) async {
    await tester.tap(find.text(OnboardingCopy.next));
    await tester.pumpAndSettle();
    await tester.tap(find.text(OnboardingCopy.next));
    await tester.pumpAndSettle();
  }

  testWidgets('slide 1 shows title, Skip and Next', (tester) async {
    await pumpApp(tester);

    expect(find.text(OnboardingCopy.welcomeTitle), findsOneWidget);
    expect(find.text(OnboardingCopy.skip), findsOneWidget);
    expect(find.text(OnboardingCopy.next), findsOneWidget);
  });

  testWidgets('slide 1 announces "Step 1 of 3"', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester);

    expect(find.bySemanticsLabel('Step 1 of 3'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('Next twice reaches slide 3 with its two actions', (
    tester,
  ) async {
    await pumpApp(tester);
    await goToLastSlide(tester);

    expect(find.text(OnboardingCopy.connectTitle), findsOneWidget);
    expect(find.text(OnboardingCopy.findMyPc), findsOneWidget);
    expect(find.text(OnboardingCopy.scanQrInstead), findsOneWidget);
    expect(find.text(OnboardingCopy.next), findsNothing);
  });

  testWidgets('Skip is hidden from hit testing and semantics on slide 3', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpApp(tester);
    await goToLastSlide(tester);

    expect(find.text(OnboardingCopy.skip).hitTestable(), findsNothing);
    expect(find.semantics.byLabel(OnboardingCopy.skip), findsNothing);
    handle.dispose();
  });

  testWidgets('left swipe advances to slide 2', (tester) async {
    await pumpApp(tester);

    await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
    await tester.pumpAndSettle();

    expect(find.text(OnboardingCopy.installTitle), findsOneWidget);
  });

  testWidgets('system back on slide 2 returns to slide 1', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text(OnboardingCopy.next));
    await tester.pumpAndSettle();
    expect(find.text(OnboardingCopy.installTitle), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text(OnboardingCopy.welcomeTitle), findsOneWidget);
  });

  testWidgets('Skip goes to Devices and saves once', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text(OnboardingCopy.skip));
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsOneWidget);
    expect(repo.markCompletedCalls, 1);
  });

  testWidgets('Find my PC goes to Devices', (tester) async {
    await pumpApp(tester);
    await goToLastSlide(tester);

    await tester.tap(find.text(OnboardingCopy.findMyPc));
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsOneWidget);
  });

  testWidgets('Scan QR code instead goes to Pair', (tester) async {
    await pumpApp(tester);
    await goToLastSlide(tester);

    await tester.tap(find.text(OnboardingCopy.scanQrInstead));
    await tester.pumpAndSettle();

    expect(find.text('Pair'), findsOneWidget);
  });

  testWidgets('a failed save still lands on Devices and shows a SnackBar', (
    tester,
  ) async {
    repo.result = const ApiError<void>(CacheFailure('disk full'));
    await pumpApp(tester);

    await tester.tap(find.text(OnboardingCopy.skip));
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsOneWidget);
    expect(find.text(OnboardingCopy.saveFailed), findsOneWidget);
  });

  testWidgets('Copy puts the URL on the clipboard and shows a SnackBar', (
    tester,
  ) async {
    String? clipboardText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboardText = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpApp(tester);
    await tester.tap(find.text(OnboardingCopy.next));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip(OnboardingCopy.copyLink));
    await tester.pumpAndSettle();

    expect(clipboardText, AppLinks.serverDownloadUrl);
    expect(find.text(OnboardingCopy.linkCopied), findsOneWidget);
  });

  testWidgets('under RTL Skip sits left of the logo', (tester) async {
    await pumpApp(tester, textDirection: TextDirection.rtl);

    final skipX = tester.getTopLeft(find.text(OnboardingCopy.skip)).dx;
    final logoX = tester.getTopLeft(find.byType(KontrolLogo)).dx;

    expect(skipX, lessThan(logoX));
  });

  testWidgets('slide 1 does not overflow at 2.0 text scale', (tester) async {
    await pumpApp(tester, textScale: 2);

    expect(tester.takeException(), isNull);
  });

  group('on a 360x640 phone', () {
    const small = Size(360, 640);

    testWidgets('slide 1 does not overflow', (tester) async {
      await pumpApp(tester, size: small);

      expect(tester.takeException(), isNull);
    });

    testWidgets('slide 2 does not overflow', (tester) async {
      await pumpApp(tester, size: small);
      await tester.tap(find.text(OnboardingCopy.next));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('slide 3 does not overflow', (tester) async {
      await pumpApp(tester, size: small);
      await goToLastSlide(tester);

      expect(tester.takeException(), isNull);
    });
  });

  group('while the completion flag is saving', () {
    setUp(() => repo.pending = Completer());

    Future<void> startSavingOnSlide2(WidgetTester tester) async {
      await pumpApp(tester);
      await tester.tap(find.text(OnboardingCopy.next));
      await tester.pumpAndSettle();
      await tester.tap(find.text(OnboardingCopy.skip));
      await tester.pump();
    }

    testWidgets('system back keeps the current slide', (tester) async {
      await startSavingOnSlide2(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text(OnboardingCopy.installTitle), findsOneWidget);
    });

    testWidgets('swiping does not change the slide', (tester) async {
      await startSavingOnSlide2(tester);

      await tester.fling(find.byType(PageView), const Offset(-300, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.text(OnboardingCopy.installTitle), findsOneWidget);
    });
  });
}
