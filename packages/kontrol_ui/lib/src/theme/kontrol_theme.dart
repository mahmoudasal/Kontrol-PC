import 'package:flutter/material.dart';

import '../tokens/kontrol_colors.dart';
import '../tokens/kontrol_dimens.dart';
import '../tokens/kontrol_typography.dart';

/// Access to [KontrolColors] from a [BuildContext].
extension KontrolThemeContext on BuildContext {
  KontrolColors get kColors => Theme.of(this).extension<KontrolColors>()!;
}

/// Builds the Kontrol Material 3 themes.
abstract final class KontrolTheme {
  static ThemeData dark() => _build(Brightness.dark, KontrolColors.dark);

  static ThemeData light() => _build(Brightness.light, KontrolColors.light);

  static ThemeData _build(Brightness brightness, KontrolColors c) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      primaryContainer: c.accentSoft,
      onPrimaryContainer: c.accentText,
      secondary: c.accent,
      onSecondary: c.onAccent,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.text2,
      surfaceContainerHighest: c.surface2,
      outline: c.outline,
      outlineVariant: c.border,
      error: c.danger,
      onError: c.onDanger,
      inverseSurface: c.text,
      onInverseSurface: c.bg,
    );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(KontrolRadii.r16),
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      fontFamily: 'Inter',
      package: 'kontrol_ui',
      extensions: [c],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: c.text, displayColor: c.text),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: shape,
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          textStyle: KontrolTypography.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: shape,
          foregroundColor: c.text,
          textStyle: KontrolTypography.label,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.text,
        contentTextStyle: KontrolTypography.bodySmall.copyWith(color: c.bg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KontrolRadii.r12),
        ),
      ),
    );
  }
}
