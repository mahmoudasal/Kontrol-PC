import 'package:flutter/widgets.dart';

/// The 40x24 dotted connector between phone and PC: a horizontal line at
/// y=12 from x=2 to x=38, dashed 2 on / 5 off, 2dp stroke, round caps.
class DashedLinePainter extends CustomPainter {
  const DashedLinePainter({required this.color});

  final Color color;

  static const Size canvasSize = Size(40, 24);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    const end = 38.0;
    for (var x = 2.0; x < end; x += 7) {
      final dashEnd = x + 2 > end ? end : x + 2;
      canvas.drawLine(Offset(x, 12), Offset(dashEnd, 12), paint);
    }
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
