import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../onboarding_copy.dart';
import 'hero/phone_to_pc_hero.dart';
import 'slide_layout.dart';

class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideLayout(
      hero: const PhoneToPcHero(),
      title: OnboardingCopy.welcomeTitle,
      children: [
        Text(
          OnboardingCopy.welcomeBody,
          style: KontrolTypography.body.copyWith(color: context.kColors.text2),
        ),
      ],
    );
  }
}
