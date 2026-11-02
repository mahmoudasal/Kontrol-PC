import 'package:flutter/services.dart';

/// Loads the bundled Inter and JetBrains Mono so widget tests lay out with
/// real glyph widths instead of the square test font.
Future<void> loadKontrolFonts() async {
  const base = 'packages/kontrol_ui/fonts';
  final families = {
    'packages/kontrol_ui/Inter': [
      'Inter-Regular',
      'Inter-Medium',
      'Inter-SemiBold',
      'Inter-Bold',
    ],
    'packages/kontrol_ui/JetBrainsMono': [
      'JetBrainsMono-Medium',
      'JetBrainsMono-SemiBold',
    ],
  };
  for (final MapEntry(key: family, value: files) in families.entries) {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load('$base/$file.ttf'));
    }
    await loader.load();
  }
}
