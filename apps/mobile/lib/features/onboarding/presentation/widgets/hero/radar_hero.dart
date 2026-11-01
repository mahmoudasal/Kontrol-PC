import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';

/// Slide 3: concentric rings around a Wi-Fi tile, with a PC badge.
class RadarHero extends StatelessWidget {
  const RadarHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const _Ring(inset: 0, alpha: 0.14),
          const _Ring(inset: 40, alpha: 0.24),
          const _Ring(inset: 80, alpha: 0.40),
          Container(
            width: 64,
            height: 64,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: colors.accent,
              borderRadius: BorderRadius.circular(KontrolRadii.r20),
            ),
            child: Icon(LucideIcons400.wifi, size: 30, color: colors.onAccent),
          ),
          PositionedDirectional(
            end: 6,
            top: 38,
            // The design's 40dp box has no border-box sizing, so the 1dp
            // border adds to it: 42dp outer.
            child: Container(
              width: 42,
              height: 42,
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(KontrolRadii.r12),
                border: Border.all(color: colors.borderStrong),
              ),
              child: Icon(LucideIcons400.monitor, size: 20, color: colors.text),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.inset, required this.alpha});

  final double inset;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsetsDirectional.all(inset),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.kColors.accent.withValues(alpha: alpha),
            ),
          ),
        ),
      ),
    );
  }
}
