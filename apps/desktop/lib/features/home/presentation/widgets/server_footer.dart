import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/constants/app_info.dart';

/// Version and Settings link. "Starts with Windows" returns with autostart;
/// Settings is disabled until the desktop Settings screen is designed.
class ServerFooter extends StatelessWidget {
  const ServerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final style = KontrolTypography.caption.copyWith(color: c.text3);
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('v$appVersion', style: style),
          Tooltip(
            message: 'Settings are coming soon',
            child: Semantics(
              link: true,
              enabled: false,
              child: Text(
                'Settings',
                style: style.copyWith(
                  color: c.accentText.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
