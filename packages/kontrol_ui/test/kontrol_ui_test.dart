import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

void main() {
  test('dark theme exposes dark KontrolColors accent', () {
    final c = KontrolTheme.dark().extension<KontrolColors>()!;
    expect(c.accent, const Color(0xFF4C8DFF));
  });

  test('dark theme exposes dark KontrolColors background', () {
    final c = KontrolTheme.dark().extension<KontrolColors>()!;
    expect(c.bg, const Color(0xFF0B0C0E));
  });

  test('light theme exposes light KontrolColors accent', () {
    final c = KontrolTheme.light().extension<KontrolColors>()!;
    expect(c.accent, const Color(0xFF1F5FD6));
  });

  test('light theme exposes light KontrolColors background', () {
    final c = KontrolTheme.light().extension<KontrolColors>()!;
    expect(c.bg, const Color(0xFFF4F5F7));
  });

  test('theme scaffold background is the bg token', () {
    expect(KontrolTheme.dark().scaffoldBackgroundColor, KontrolColors.dark.bg);
  });

  test('dark theme error color is the design danger token', () {
    expect(KontrolTheme.dark().colorScheme.error, const Color(0xFFFF6B5E));
  });

  test('lerp at t=0 returns the start colors', () {
    final r = KontrolColors.dark.lerp(KontrolColors.light, 0);
    expect(r.bg, KontrolColors.dark.bg);
    expect(r.accent, KontrolColors.dark.accent);
  });

  test('lerp at t=1 returns the end colors', () {
    final r = KontrolColors.dark.lerp(KontrolColors.light, 1);
    expect(r.bg, KontrolColors.light.bg);
    expect(r.accent, KontrolColors.light.accent);
  });

  test('copyWith replaces only the given field', () {
    final r = KontrolColors.dark.copyWith(accent: const Color(0xFF000000));
    expect(r.accent, const Color(0xFF000000));
    expect(r.bg, KontrolColors.dark.bg);
  });

  testWidgets('KontrolLogo pumps at size 28 without errors', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: KontrolTheme.dark(),
        home: const Center(child: KontrolLogo()),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(KontrolLogo)), const Size(28, 28));
  });

  testWidgets('KontrolLogo has the Kontrol semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(theme: KontrolTheme.dark(), home: const KontrolLogo()),
    );
    expect(find.bySemanticsLabel('Kontrol'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('KontrolLogo excludes semantics when asked', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: KontrolTheme.dark(),
        home: const KontrolLogo(excludeSemantics: true),
      ),
    );
    expect(find.bySemanticsLabel('Kontrol'), findsNothing);
    handle.dispose();
  });
}
