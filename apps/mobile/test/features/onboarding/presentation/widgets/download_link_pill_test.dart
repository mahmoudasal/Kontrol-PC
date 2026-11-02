import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/onboarding_copy.dart';
import 'package:kontrol_mobile/features/onboarding/presentation/widgets/download_link_pill.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

void main() {
  Future<void> pumpPill(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        theme: KontrolTheme.dark(),
        home: const Scaffold(
          body: Center(child: DownloadLinkPill(url: 'https://example.com/k')),
        ),
      ),
    );
  }

  testWidgets('copy and share hit targets are at least 48dp', (tester) async {
    await pumpPill(tester);

    for (final tooltip in [OnboardingCopy.copyLink, OnboardingCopy.shareLink]) {
      final size = tester.getSize(
        find.ancestor(
          of: find.byTooltip(tooltip),
          matching: find.byType(IconButton),
        ),
      );
      expect(size.width, greaterThanOrEqualTo(48), reason: tooltip);
      expect(size.height, greaterThanOrEqualTo(48), reason: tooltip);
    }
  });

  testWidgets('pill is 58dp tall: 44dp buttons, 6dp padding, 1dp border', (
    tester,
  ) async {
    await pumpPill(tester);

    final size = tester.getSize(find.byType(DownloadLinkPill));

    expect(size.height, 58);
  });

  testWidgets('shows an error when copying to the clipboard fails', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => call.method == 'Clipboard.setData'
          ? throw PlatformException(code: 'unavailable')
          : null,
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await pumpPill(tester);

    await tester.tap(find.byTooltip(OnboardingCopy.copyLink));
    await tester.pumpAndSettle();

    expect(find.text(OnboardingCopy.copyFailed), findsOneWidget);
  });

  testWidgets('shows an error when the share sheet fails to open', (
    tester,
  ) async {
    const shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      shareChannel,
      (_) async => throw PlatformException(code: 'unavailable'),
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        shareChannel,
        null,
      ),
    );
    await pumpPill(tester);

    await tester.tap(find.byTooltip(OnboardingCopy.shareLink));
    await tester.pumpAndSettle();

    expect(find.text(OnboardingCopy.shareFailed), findsOneWidget);
  });
}
