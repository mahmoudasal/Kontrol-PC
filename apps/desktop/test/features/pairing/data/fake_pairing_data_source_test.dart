import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/features/pairing/data/datasources/fake_pairing_data_source.dart';

void main() {
  late DateTime now;
  late FakePairingDataSource source;

  setUp(() {
    now = DateTime(2026, 11, 1, 12);
    source = FakePairingDataSource(random: Random(7), now: () => now);
  });

  test('PIN is six digits', () {
    expect(source.getCode().pin, matches(RegExp(r'^\d{6}$')));
  });

  test('code expires five minutes from now', () {
    expect(source.getCode().expiresAt, now.add(const Duration(minutes: 5)));
  });

  test('getCode returns the same code while it is valid', () {
    final first = source.getCode();
    now = now.add(const Duration(minutes: 4));
    expect(source.getCode(), first);
  });

  test('getCode issues a new code after expiry', () {
    final first = source.getCode();
    now = now.add(const Duration(minutes: 5));
    expect(source.getCode(), isNot(first));
  });

  test('regenerate replaces the live code', () {
    final first = source.getCode();
    final second = source.regenerate();
    expect(second, isNot(first));
    expect(source.getCode(), second);
  });

  test('QR payload carries the PIN', () {
    final code = source.getCode();
    expect(code.qrPayload, contains(code.pin));
  });
}
