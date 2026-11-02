import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';

/// Slide 2: a monitor showing a download tile.
class InstallHero extends StatelessWidget {
  const InstallHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: KontrolSpacing.s10,
      children: [
        Container(
          width: 220,
          height: 144,
          alignment: AlignmentDirectional.center,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(KontrolRadii.r14),
            border: Border.all(color: colors.outline, width: 2),
          ),
          child: Container(
            width: 72,
            height: 72,
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(KontrolRadii.r20),
            ),
            child: Icon(
              LucideIcons400.download,
              size: 34,
              color: colors.accentText,
            ),
          ),
        ),
        Container(
          width: 56,
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
