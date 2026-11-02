import 'package:flutter/material.dart';

/// Kontrol color tokens, exposed as a [ThemeExtension].
///
/// Light values for [borderStrong], [outline], [accentText], [danger],
/// [onDanger], [dangerText], [surfaceSunken] and [warning] are derived (not in
/// the design handoff) and need design review.
@immutable
class KontrolColors extends ThemeExtension<KontrolColors> {
  const KontrolColors({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.surfaceSunken,
    required this.border,
    required this.borderStrong,
    required this.outline,
    required this.text,
    required this.text2,
    required this.text3,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentText,
    required this.success,
    required this.successText,
    required this.successSoft,
    required this.warning,
    required this.warningText,
    required this.warningSoft,
    required this.danger,
    required this.dangerText,
    required this.onDanger,
  });

  final Color bg;
  final Color surface;
  final Color surface2;

  /// Recessed surface: touchpad pad, inactive list rows.
  final Color surfaceSunken;
  final Color border;
  final Color borderStrong;
  final Color outline;
  final Color text;
  final Color text2;
  final Color text3;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color accentText;

  /// Status dot / icon color.
  final Color success;

  /// Status label color.
  final Color successText;

  /// Status chip background.
  final Color successSoft;
  final Color warning;
  final Color warningText;
  final Color warningSoft;
  final Color danger;
  final Color dangerText;
  final Color onDanger;

  static const KontrolColors dark = KontrolColors(
    bg: Color(0xFF0B0C0E),
    surface: Color(0xFF15171B),
    surface2: Color(0xFF1E2127),
    surfaceSunken: Color(0xFF121418),
    border: Color(0xFF262A31),
    borderStrong: Color(0xFF2E333B),
    outline: Color(0xFF3A404A),
    text: Color(0xFFF2F4F7),
    text2: Color(0xFFA3AAB6),
    text3: Color(0xFF8A919E),
    accent: Color(0xFF4C8DFF),
    onAccent: Color(0xFF05101F),
    accentSoft: Color(0x1F4C8DFF),
    accentText: Color(0xFF8DB6FF),
    success: Color(0xFF3DDC97),
    successText: Color(0xFF5BE3A8),
    successSoft: Color(0x1F3DDC97),
    warning: Color(0xFFF5B544),
    warningText: Color(0xFFF7C66B),
    warningSoft: Color(0x24F5B544),
    danger: Color(0xFFFF6B5E),
    dangerText: Color(0xFFFF8A80),
    onDanger: Color(0xFF1A0505),
  );

  static const KontrolColors light = KontrolColors(
    bg: Color(0xFFF4F5F7),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEBEDF1),
    surfaceSunken: Color(0xFFF0F2F5),
    border: Color(0xFFDCE0E6),
    borderStrong: Color(0xFFCDD2DA),
    outline: Color(0xFFB8BEC8),
    text: Color(0xFF0E1116),
    text2: Color(0xFF4A5260),
    text3: Color(0xFF5F6775),
    accent: Color(0xFF1F5FD6),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0x1F1F5FD6),
    accentText: Color(0xFF1F5FD6),
    success: Color(0xFF12A867),
    successText: Color(0xFF0B6E44),
    successSoft: Color(0x1A0B7A4B),
    warning: Color(0xFFB46E00),
    warningText: Color(0xFF7A4A00),
    warningSoft: Color(0x1FB46E00),
    danger: Color(0xFFC4352B),
    dangerText: Color(0xFFC4352B),
    onDanger: Color(0xFFFFFFFF),
  );

  @override
  KontrolColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
    Color? surfaceSunken,
    Color? border,
    Color? borderStrong,
    Color? outline,
    Color? text,
    Color? text2,
    Color? text3,
    Color? accent,
    Color? onAccent,
    Color? accentSoft,
    Color? accentText,
    Color? success,
    Color? successText,
    Color? successSoft,
    Color? warning,
    Color? warningText,
    Color? warningSoft,
    Color? danger,
    Color? dangerText,
    Color? onDanger,
  }) {
    return KontrolColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      outline: outline ?? this.outline,
      text: text ?? this.text,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      accentText: accentText ?? this.accentText,
      success: success ?? this.success,
      successText: successText ?? this.successText,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerText: dangerText ?? this.dangerText,
      onDanger: onDanger ?? this.onDanger,
    );
  }

  @override
  KontrolColors lerp(ThemeExtension<KontrolColors>? other, double t) {
    if (other is! KontrolColors) return this;
    return KontrolColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surface2: Color.lerp(surface2, other.surface2, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      text: Color.lerp(text, other.text, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      accentSoft: Color.lerp(accentSoft, other.accentSoft, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      success: Color.lerp(success, other.success, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
    );
  }
}
