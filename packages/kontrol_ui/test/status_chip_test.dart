import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

Widget _host(Widget child) => MaterialApp(
  theme: KontrolTheme.dark(),
  home: Scaffold(body: Center(child: child)),
);

StatusDot _dot(WidgetTester tester) =>
    tester.widget<StatusDot>(find.byType(StatusDot));

void main() {
  test('dark success tokens match the design handoff', () {
    expect(KontrolColors.dark.success, const Color(0xFF3DDC97));
    expect(KontrolColors.dark.successText, const Color(0xFF5BE3A8));
  });

  test('lerp at t=1 returns the end status colors', () {
    final r = KontrolColors.dark.lerp(KontrolColors.light, 1);
    expect(r.success, KontrolColors.light.success);
    expect(r.warningText, KontrolColors.light.warningText);
    expect(r.surfaceSunken, KontrolColors.light.surfaceSunken);
  });

  testWidgets('StatusChip shows its label', (tester) async {
    await tester.pumpWidget(
      _host(
        const StatusChip(
          label: 'Ready to pair',
          tone: StatusTone.success,
          shape: StatusDotShape.filled,
        ),
      ),
    );
    expect(find.text('Ready to pair'), findsOneWidget);
  });

  testWidgets('StatusChip is 26 px tall', (tester) async {
    await tester.pumpWidget(
      _host(
        const StatusChip(
          label: 'Ready to pair',
          tone: StatusTone.success,
          shape: StatusDotShape.filled,
        ),
      ),
    );
    expect(tester.getSize(find.byType(StatusChip)).height, 26);
  });

  testWidgets('filled success dot uses the vivid success color', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const StatusChip(
          label: 'Ready',
          tone: StatusTone.success,
          shape: StatusDotShape.filled,
        ),
      ),
    );
    expect(_dot(tester).color, KontrolColors.dark.success);
  });

  testWidgets('arc dot follows the label color', (tester) async {
    await tester.pumpWidget(
      _host(
        const StatusChip(
          label: 'Paused',
          tone: StatusTone.warning,
          shape: StatusDotShape.arc,
        ),
      ),
    );
    expect(_dot(tester).color, KontrolColors.dark.warningText);
  });

  testWidgets('StatusChip is a live region', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _host(
        const StatusChip(
          label: 'Offline',
          tone: StatusTone.neutral,
          shape: StatusDotShape.ring,
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(StatusChip)),
      matchesSemantics(isLiveRegion: true, label: 'Offline'),
    );
    handle.dispose();
  });

  for (final shape in StatusDotShape.values) {
    testWidgets('StatusDot paints ${shape.name} without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(StatusDot(shape: shape, color: Colors.green)),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(StatusDot)), const Size(8, 8));
    });
  }
}
