import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:qr/qr.dart';

/// White 136 px tile with the QR code for [payload]. A null [payload] shows
/// the empty tile while a code loads.
class QrCodeView extends StatelessWidget {
  const QrCodeView({super.key, required this.payload});

  final String? payload;

  /// QR modules are dark on white regardless of theme, for scanner contrast.
  static const _module = Color(0xFF0B0C0E);

  @override
  Widget build(BuildContext context) {
    final payload = this.payload;
    return Semantics(
      label: 'Pairing QR code',
      image: true,
      child: Container(
        width: 136,
        height: 136,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KontrolRadii.r14),
        ),
        child: payload == null
            ? null
            : CustomPaint(painter: _QrPainter(payload, _module)),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  _QrPainter(this.payload, this.color);

  final String payload;
  final Color color;

  late final QrImage _image = QrImage(
    QrCode(payload: QrPayload.fromString(payload)),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final count = _image.moduleCount;
    final cell = size.shortestSide / count;
    final paint = Paint()..color = color;
    for (var row = 0; row < count; row++) {
      for (var col = 0; col < count; col++) {
        if (!_image.isDark(row, col)) continue;
        // Slight overlap hides hairline seams between adjacent modules.
        canvas.drawRect(
          Rect.fromLTWH(col * cell, row * cell, cell + 0.3, cell + 0.3),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) =>
      old.payload != payload || old.color != color;
}
