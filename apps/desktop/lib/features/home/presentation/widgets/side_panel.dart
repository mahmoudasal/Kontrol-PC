import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/theme/server_colors.dart';
import '../../../pairing/presentation/widgets/pairing_panel.dart';
import '../../../server/presentation/widgets/host_info_card.dart';
import '../../../server/presentation/widgets/server_status_chip.dart';

/// Left 330 px column: status, pairing code, help text, host info.
class SidePanel extends StatelessWidget {
  const SidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final sc = context.serverColors;
    final helper = KontrolTypography.callout.copyWith(color: c.text2);
    return Container(
      width: 330,
      padding: const EdgeInsets.symmetric(
        horizontal: KontrolSpacing.s24,
        vertical: KontrolSpacing.s22,
      ),
      decoration: BoxDecoration(
        color: sc.sidePanel,
        border: BorderDirectional(end: BorderSide(color: sc.hairline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: KontrolSpacing.s16,
        children: [
          const ServerStatusChip(),
          const PairingPanel(),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Open Kontrol on your phone and tap '),
                TextSpan(
                  text: 'Find my PC',
                  style: TextStyle(color: c.text, fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ', or scan this code.'),
              ],
            ),
            style: helper,
          ),
          const Spacer(),
          const HostInfoCard(),
        ],
      ),
    );
  }
}
