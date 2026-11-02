import 'package:flutter/widgets.dart';

/// The mouse-cursor arrow: `M5 3 l14 7 -6 2 -2 6 z` in a 24 viewBox, filled
/// with [fill] and outlined with a 1.2 [stroke].
class CursorPainter extends CustomPainter {
  const CursorPainter({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final path = Path()
      ..moveTo(5, 3)
      ..relativeLineTo(14, 7)
      ..relativeLineTo(-6, 2)
      ..relativeLineTo(-2, 6)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(CursorPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}
