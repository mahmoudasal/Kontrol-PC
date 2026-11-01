import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import 'cursor_painter.dart';
import 'dashed_line_painter.dart';

/// Slide 1: a phone, a dotted connector and a monitor with a cursor.
class PhoneToPcHero extends StatelessWidget {
  const PhoneToPcHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 22,
      children: [_Phone(), _Connector(), _Monitor()],
    );
  }
}

class _Phone extends StatelessWidget {
  const _Phone();

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return Container(
      width: 84,
      height: 156,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(KontrolRadii.r20),
        border: Border.all(color: colors.outline, width: 2),
      ),
      child: Column(
        spacing: KontrolSpacing.s6,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(KontrolRadii.r10),
              ),
              child: Stack(
                children: [
                  PositionedDirectional(
                    start: 22,
                    top: 40,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.accent.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Row(
            spacing: KontrolSpacing.s4,
            children: [
              Expanded(child: _Key()),
              Expanded(child: _Key()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.kColors.border,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const SizedBox(height: 14),
    );
  }
}

class _Connector extends StatelessWidget {
  const _Connector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 64),
      child: CustomPaint(
        size: DashedLinePainter.canvasSize,
        painter: DashedLinePainter(color: context.kColors.accent),
      ),
    );
  }
}

class _Monitor extends StatelessWidget {
  const _Monitor();

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: KontrolSpacing.s8,
      children: [
        Container(
          width: 168,
          height: 112,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(KontrolRadii.r12),
            border: Border.all(color: colors.outline, width: 2),
          ),
          child: Stack(
            children: [
              PositionedDirectional(
                start: 70,
                top: 38,
                child: CustomPaint(
                  size: const Size.square(22),
                  painter: CursorPainter(fill: colors.text, stroke: colors.bg),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            color: colors.outline,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
