import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';

import '../onboarding_copy.dart';

class LocalNetworkCard extends StatelessWidget {
  const LocalNetworkCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(KontrolRadii.r16),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: KontrolSpacing.s12,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 1),
              child: Icon(
                LucideIcons400.shieldCheck,
                size: 22,
                color: colors.accentText,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KontrolSpacing.s4,
                children: [
                  Text(
                    OnboardingCopy.networkCardTitle,
                    style: KontrolTypography.label.copyWith(color: colors.text),
                  ),
                  Text(
                    OnboardingCopy.networkCardBody,
                    style: KontrolTypography.bodySmall.copyWith(
                      color: colors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
