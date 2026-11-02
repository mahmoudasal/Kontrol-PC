import 'package:flutter/material.dart';

import '../onboarding_copy.dart';
import 'hero/radar_hero.dart';
import 'local_network_card.dart';
import 'slide_layout.dart';

class ConnectSlide extends StatelessWidget {
  const ConnectSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SlideLayout(
      hero: RadarHero(),
      title: OnboardingCopy.connectTitle,
      children: [
        // Design: margin-top 4 on top of the 12 column gap.
        Padding(
          padding: EdgeInsetsDirectional.only(top: 4),
          child: LocalNetworkCard(),
        ),
      ],
    );
  }
}
