import 'package:flutter/material.dart';

import '../theme/kontrol_theme.dart';

/// The Kontrol app mark, painted from the design's 32x32 SVG.
class KontrolLogo extends StatelessWidget {
  const KontrolLogo({super.key, this.size = 28, this.excludeSemantics = false});

  final double size;

  /// Set when the brand text sits next to the logo, so it is not announced twice.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    final paint = SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _KontrolLogoPainter(
          background: colors.accent,
          foreground: colors.onAccent,
        ),
      ),
    );
    if (excludeSemantics) return ExcludeSemantics(child: paint);
    return Semantics(label: 'Kontrol', image: true, child: paint);
  }
}

class _KontrolLogoPainter extends CustomPainter {
  const _KontrolLogoPainter({
    required this.background,
    required this.foreground,
  });

  final Color background;
  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 32, size.height / 32);
    final fill = Paint()..color = foreground;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, 32, 32),
        const Radius.circular(9),
      ),
      Paint()..color = background,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(9, 7, 3.6, 18),
        const Radius.circular(1.8),
      ),
      fill,
    );
    canvas.drawPath(
      Path()
        ..moveTo(14, 16.2)
        ..lineTo(23.5, 7.5)
        ..lineTo(21.6, 17.6)
        ..close(),
      fill,
    );
    canvas.drawLine(
      const Offset(16.5, 17.5),
      const Offset(23, 25),
      Paint()
        ..color = foreground
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_KontrolLogoPainter old) =>
      old.background != background || old.foreground != foreground;
}
