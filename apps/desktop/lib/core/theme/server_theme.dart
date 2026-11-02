import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import 'server_colors.dart';

/// The shared dark theme plus the desktop-only [ServerColors].
ThemeData buildServerTheme() {
  final base = KontrolTheme.dark();
  return base.copyWith(
    extensions: [...base.extensions.values, ServerColors.dark],
  );
}
