import 'package:flutter/painting.dart';

/// Kontrol text styles. Colors are intentionally unset: the theme (or the
/// caller) supplies them.
abstract final class KontrolTypography {
  static const String _inter = 'Inter';
  static const String _mono = 'JetBrainsMono';
  static const String _package = 'kontrol_ui';

  static const TextStyle display = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.75,
  );

  static const TextStyle brand = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.34,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: _mono,
    package: _package,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  /// Large monospace figures (pairing PIN). Tabular so digits never shift.
  static const TextStyle monoDisplay = TextStyle(
    fontFamily: _mono,
    package: _package,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Pane / dialog title (desktop).
  static const TextStyle title = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.18,
  );

  /// Dense body copy (13px).
  static const TextStyle callout = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Uppercase section label: 12/600, letter-spacing 0.06em. Callers
  /// uppercase the text.
  static const TextStyle sectionLabel = TextStyle(
    fontFamily: _inter,
    package: _package,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.72,
  );
}
