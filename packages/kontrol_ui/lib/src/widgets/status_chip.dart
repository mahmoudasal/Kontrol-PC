import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/kontrol_theme.dart';
import '../tokens/kontrol_colors.dart';
import '../tokens/kontrol_dimens.dart';
import '../tokens/kontrol_typography.dart';

/// Dot shape that carries status meaning, so status is never color-only.
enum StatusDotShape {
  /// Solid dot: connected / ready.
  filled,

  /// Three-quarter ring: in progress (reconnecting, paused).
  arc,

  /// Hollow ring: offline / idle.
  ring,
}

/// Color family of a [StatusChip].
enum StatusTone { success, warning, neutral, danger }

/// A small status dot painted in one of the [StatusDotShape]s.
class StatusDot extends StatelessWidget {
  const StatusDot({
    super.key,
    required this.shape,
    required this.color,
    this.size = 8,
    this.strokeWidth = 2,
  });

  final StatusDotShape shape;
  final Color color;
  final double size;

  /// Stroke for [StatusDotShape.arc] and [StatusDotShape.ring].
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _StatusDotPainter(shape, color, strokeWidth),
      ),
    );
  }
}

class _StatusDotPainter extends CustomPainter {
  const _StatusDotPainter(this.shape, this.color, this.strokeWidth);

  final StatusDotShape shape;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    if (shape == StatusDotShape.filled) {
      canvas.drawCircle(center, radius, Paint()..color = color);
      return;
    }
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final inner = radius - strokeWidth / 2;
    if (shape == StatusDotShape.ring) {
      canvas.drawCircle(center, inner, stroke);
      return;
    }
    // Arc: the right quarter is open, like a CSS border with a transparent
    // right side.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: inner),
      math.pi / 4,
      math.pi * 1.5,
      false,
      stroke,
    );
  }

  @override
  bool shouldRepaint(_StatusDotPainter old) =>
      old.shape != shape ||
      old.color != color ||
      old.strokeWidth != strokeWidth;
}

/// Pill-shaped status label with a shaped dot, announced as a live region.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.tone,
    required this.shape,
  });

  final String label;
  final StatusTone tone;
  final StatusDotShape shape;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = _colors(context.kColors);
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        height: 26,
        padding: const EdgeInsetsDirectional.only(
          start: KontrolSpacing.s8,
          end: KontrolSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(KontrolRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: KontrolSpacing.s6,
          children: [
            StatusDot(shape: shape, color: dot),
            Text(
              label,
              style: KontrolTypography.caption.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// (background, label, dot). Filled dots use the vivid dot color; outlined
  /// dots follow the label color, as in the design.
  (Color, Color, Color) _colors(KontrolColors c) {
    final (bg, fg, vivid) = switch (tone) {
      StatusTone.success => (c.successSoft, c.successText, c.success),
      StatusTone.warning => (c.warningSoft, c.warningText, c.warning),
      StatusTone.danger => (
        c.danger.withValues(alpha: 0.10),
        c.dangerText,
        c.danger,
      ),
      StatusTone.neutral => (c.text.withValues(alpha: 0.07), c.text2, c.text2),
    };
    return (bg, fg, shape == StatusDotShape.filled ? vivid : fg);
  }
}
