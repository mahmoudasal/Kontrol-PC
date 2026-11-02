import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons_weights.dart';
import 'package:share_plus/share_plus.dart';

import '../onboarding_copy.dart';

/// The server download URL with copy and share actions.
///
/// The design draws 44dp buttons. Each [IconButton] pads its tap target to
/// 48dp, and the surrounding paddings shrink by the same amount, so the pill
/// keeps the design's size and spacing.
class DownloadLinkPill extends StatelessWidget {
  const DownloadLinkPill({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(KontrolRadii.r14),
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        // Design 6/6/6/14, minus the 2dp the 48dp tap targets add per side.
        padding: const EdgeInsetsDirectional.fromSTEB(14, 4, 4, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: KontrolTypography.mono.copyWith(color: colors.text),
              ),
            ),
            const SizedBox(width: 6),
            _PillButton(
              tooltip: OnboardingCopy.copyLink,
              icon: LucideIcons400.copy,
              onPressed: () => _copy(context),
            ),
            const SizedBox(width: 4),
            _PillButton(
              tooltip: OnboardingCopy.shareLink,
              icon: LucideIcons400.share,
              onPressed: () => _share(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await Clipboard.setData(ClipboardData(text: url));
      _showMessage(messenger, OnboardingCopy.linkCopied);
    } on Exception {
      _showMessage(messenger, OnboardingCopy.copyFailed);
    }
  }

  Future<void> _share(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await SharePlus.instance.share(ShareParams(uri: Uri.parse(url)));
    } on Exception {
      _showMessage(messenger, OnboardingCopy.shareFailed);
    }
  }

  void _showMessage(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.kColors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        fixedSize: const Size(44, 44),
        tapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: colors.surface2,
        foregroundColor: colors.text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(KontrolRadii.r10),
        ),
      ),
    );
  }
}
