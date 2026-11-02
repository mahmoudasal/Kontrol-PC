import 'package:flutter/material.dart';

/// Desktop-only shades from the Server designs that are not part of the
/// shared [KontrolColors] palette. Dark only: the server ships dark.
@immutable
class ServerColors extends ThemeExtension<ServerColors> {
  const ServerColors({
    required this.titleBar,
    required this.sidePanel,
    required this.hairline,
    required this.cardBorder,
    required this.textSoft,
  });

  final Color titleBar;
  final Color sidePanel;

  /// Title-bar and panel dividers.
  final Color hairline;

  /// Card and list borders.
  final Color cardBorder;

  /// Body text one step softer than `text`.
  final Color textSoft;

  static const ServerColors dark = ServerColors(
    titleBar: Color(0xFF101215),
    sidePanel: Color(0xFF0E1013),
    hairline: Color(0xFF1E2127),
    cardBorder: Color(0xFF23272E),
    textSoft: Color(0xFFC9CED6),
  );

  @override
  ServerColors copyWith({
    Color? titleBar,
    Color? sidePanel,
    Color? hairline,
    Color? cardBorder,
    Color? textSoft,
  }) {
    return ServerColors(
      titleBar: titleBar ?? this.titleBar,
      sidePanel: sidePanel ?? this.sidePanel,
      hairline: hairline ?? this.hairline,
      cardBorder: cardBorder ?? this.cardBorder,
      textSoft: textSoft ?? this.textSoft,
    );
  }

  @override
  ServerColors lerp(ThemeExtension<ServerColors>? other, double t) {
    if (other is! ServerColors) return this;
    return ServerColors(
      titleBar: Color.lerp(titleBar, other.titleBar, t)!,
      sidePanel: Color.lerp(sidePanel, other.sidePanel, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      textSoft: Color.lerp(textSoft, other.textSoft, t)!,
    );
  }
}

extension ServerColorsContext on BuildContext {
  ServerColors get serverColors => Theme.of(this).extension<ServerColors>()!;
}
