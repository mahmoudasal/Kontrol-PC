import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../domain/entities/paired_device.dart';
import 'device_status_text.dart';

/// One paired phone: icon, name, status line and its action.
class DeviceRow extends StatelessWidget {
  const DeviceRow({
    super.key,
    required this.device,
    required this.now,
    required this.onDisconnect,
    required this.onRevoke,
  });

  final PairedDevice device;
  final DateTime now;
  final VoidCallback onDisconnect;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final connected = device.presence is DeviceConnected;
    final statusColor = connected ? c.successText : c.text2;
    return ColoredBox(
      color: connected ? c.surface : c.surfaceSunken,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: KontrolSpacing.s14,
          vertical: KontrolSpacing.s12,
        ),
        child: Row(
          spacing: KontrolSpacing.s12,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: c.surface2,
                borderRadius: BorderRadius.circular(KontrolRadii.r10),
              ),
              child: Icon(
                LucideIcons.smartphone,
                size: 18,
                color: connected ? c.text : c.text2,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: KontrolSpacing.s2,
                children: [
                  Text(
                    device.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: KontrolTypography.bodySmall.copyWith(
                      color: c.text,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  Row(
                    spacing: KontrolSpacing.s6,
                    children: [
                      StatusDot(
                        shape: connected
                            ? StatusDotShape.filled
                            : StatusDotShape.ring,
                        color: connected ? c.success : statusColor,
                        size: 7,
                        strokeWidth: 1.5,
                      ),
                      Flexible(
                        child: Text(
                          deviceStatusText(device, now),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: KontrolTypography.caption.copyWith(
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            connected
                ? _RowButton(
                    label: 'Disconnect',
                    semanticLabel: 'Disconnect ${device.name}',
                    color: c.text,
                    border: c.borderStrong,
                    onPressed: onDisconnect,
                  )
                : _RowButton(
                    label: 'Revoke',
                    semanticLabel: 'Revoke ${device.name}',
                    color: c.dangerText,
                    border: c.danger.withValues(alpha: 0.4),
                    onPressed: onRevoke,
                  ),
          ],
        ),
      ),
    );
  }
}

class _RowButton extends StatelessWidget {
  const _RowButton({
    required this.label,
    required this.semanticLabel,
    required this.color,
    required this.border,
    required this.onPressed,
  });

  final String label;
  final String semanticLabel;
  final Color color;
  final Color border;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 32),
          fixedSize: const Size.fromHeight(32),
          padding: const EdgeInsets.symmetric(horizontal: KontrolSpacing.s12),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: color,
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KontrolRadii.r8),
          ),
          textStyle: KontrolTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
