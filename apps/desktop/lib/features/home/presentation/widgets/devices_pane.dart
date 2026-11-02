import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/time/clock.dart';
import '../../../devices/presentation/widgets/device_list.dart';
import '../../../server/presentation/widgets/approval_card.dart';
import '../../../server/presentation/widgets/pause_button.dart';
import 'server_footer.dart';

/// Right column: paired devices, approval toggle, footer.
class DevicesPane extends StatelessWidget {
  const DevicesPane({super.key, this.now = DateTime.now});

  final Now now;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: KontrolSpacing.s24,
        vertical: KontrolSpacing.s22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: KontrolSpacing.s14,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: KontrolSpacing.s12,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Paired devices',
                  style: KontrolTypography.title.copyWith(color: c.text),
                ),
              ),
              const PauseButton(),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: DeviceList(now: now),
            ),
          ),
          const ApprovalCard(),
          const ServerFooter(),
        ],
      ),
    );
  }
}
