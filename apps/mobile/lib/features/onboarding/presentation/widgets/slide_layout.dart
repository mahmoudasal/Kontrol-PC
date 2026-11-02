import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

/// Shared slide frame: a 330dp hero, the title, then the body widgets.
///
/// Scrolls so large text or short screens never overflow.
class SlideLayout extends StatelessWidget {
  const SlideLayout({
    super.key,
    required this.hero,
    required this.title,
    this.children = const [],
  });

  final Widget hero;
  final String title;

  /// Body widgets. Each one is preceded by a 12dp gap.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: KontrolSpacing.s12),
          SizedBox(
            height: 330,
            child: Center(
              child: ExcludeSemantics(
                // Heroes are drawn at the 390dp design width; shrink them on
                // narrower phones instead of overflowing.
                child: FittedBox(fit: BoxFit.scaleDown, child: hero),
              ),
            ),
          ),
          const SizedBox(height: KontrolSpacing.s20),
          Semantics(
            header: true,
            child: Text(
              title,
              style: KontrolTypography.display.copyWith(
                color: context.kColors.text,
              ),
            ),
          ),
          for (final child in children) ...[
            const SizedBox(height: KontrolSpacing.s12),
            child,
          ],
        ],
      ),
    );
  }
}
