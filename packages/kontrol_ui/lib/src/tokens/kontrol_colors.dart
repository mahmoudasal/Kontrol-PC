import 'package:flutter/material.dart';

/// Kontrol color tokens, exposed as a [ThemeExtension].
///
/// Light values for [borderStrong], [outline], [accentText], [danger] and
/// [onDanger] are derived (not in the design handoff) and need design review.
@immutable
class KontrolColors extends ThemeExtension<KontrolColors> {
  const KontrolColors({
    required this.bg,
    required this.surface,
    required this.surface2,
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
    required this.danger,
    required this.onDanger,
  });

  final Color bg;
  final Color surface;
  final Color surface2;
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
  final Color danger;
  final Color onDanger;

  static const KontrolColors dark = KontrolColors(
    bg: Color(0xFF0B0C0E),
    surface: Color(0xFF15171B),
    surface2: Color(0xFF1E2127),
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
    danger: Color(0xFFFF6B5E),
    onDanger: Color(0xFF1A0505),
  );

  static const KontrolColors light = KontrolColors(
    bg: Color(0xFFF4F5F7),
    surface: Color(0xFFFFFFFF),
    surface2: Color(0xFFEBEDF1),
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
    danger: Color(0xFFC4352B),
    onDanger: Color(0xFFFFFFFF),
  );

  @override
  KontrolColors copyWith({
    Color? bg,
    Color? surface,
    Color? surface2,
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
    Color? danger,
    Color? onDanger,
  }) {
    return KontrolColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surface2: surface2 ?? this.surface2,
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
      danger: danger ?? this.danger,
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
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
    );
  }
}
