import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/core/theme/server_theme.dart';
import 'package:kontrol_desktop/features/server/presentation/widgets/compact_switch.dart';

Future<void> _pumpSwitch(WidgetTester tester, {required bool value}) =>
    tester.pumpWidget(
      MaterialApp(
        theme: buildServerTheme(),
        home: Center(
          child: CompactSwitch(
            value: value,
            onChanged: (_) {},
            semanticLabel: 'Require approval',
          ),
        ),
      ),
    );

Size _thumbSize(WidgetTester tester) => tester.getSize(
  find
      .descendant(
        of: find.byType(CompactSwitch),
        matching: find.byType(Container),
      )
      .last,
);

void main() {
  for (final value in [true, false]) {
    testWidgets('thumb is a 20×20 circle when value is $value', (tester) async {
      await _pumpSwitch(tester, value: value);
      expect(_thumbSize(tester), const Size(20, 20));
    });
  }

  testWidgets('track is 40×24', (tester) async {
    await _pumpSwitch(tester, value: false);
    expect(tester.getSize(find.byType(AnimatedContainer)), const Size(40, 24));
  });
}
