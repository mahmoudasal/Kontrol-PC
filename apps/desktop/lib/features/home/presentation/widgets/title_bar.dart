import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/server_colors.dart';
import '../../../../core/window/window_shell.dart';

/// 40 px custom title bar: logo, title, drag area and caption buttons.
class TitleBar extends StatelessWidget {
  const TitleBar({super.key, required this.windowShell});

  final WindowShell windowShell;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final sc = context.serverColors;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: sc.titleBar,
        border: Border(bottom: BorderSide(color: sc.hairline)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (_) => windowShell.startDragging(),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: KontrolSpacing.s14,
                ),
                child: Row(
                  spacing: KontrolSpacing.s10,
                  children: [
                    const KontrolLogo(size: 18, excludeSemantics: true),
                    Text(
                      'Kontrol Server',
                      style: KontrolTypography.callout.copyWith(
                        color: c.text,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Interim labels: these become "Minimize to tray" / "Close to tray"
          // when the tray ships.
          _CaptionButton(
            icon: LucideIcons.minus,
            tooltip: 'Minimize',
            onPressed: windowShell.minimize,
          ),
          _CaptionButton(
            icon: LucideIcons.x,
            tooltip: 'Quit',
            onPressed: windowShell.close,
          ),
        ],
      ),
    );
  }
}

class _CaptionButton extends StatelessWidget {
  const _CaptionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: InkWell(
          onTap: onPressed,
          hoverColor: c.surface2,
          child: SizedBox(
            width: 46,
            height: 40,
            child: Icon(icon, size: 14, color: c.text2),
          ),
        ),
      ),
    );
  }
}
