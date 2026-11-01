import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/constants/links.dart';
import '../onboarding_copy.dart';
import 'download_link_pill.dart';
import 'hero/install_hero.dart';
import 'slide_layout.dart';

class InstallSlide extends StatelessWidget {
  const InstallSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideLayout(
      hero: const InstallHero(),
      title: OnboardingCopy.installTitle,
      children: [
        Text(
          OnboardingCopy.installBody,
          style: KontrolTypography.body.copyWith(color: context.kColors.text2),
        ),
        // Design: margin-top 6 on top of the 12 column gap.
        const Padding(
          padding: EdgeInsetsDirectional.only(top: KontrolSpacing.s6),
          child: DownloadLinkPill(url: AppLinks.serverDownloadUrl),
        ),
      ],
    );
  }
}
