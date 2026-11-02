import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/server_colors.dart';
import '../cubit/server_cubit.dart';
import '../cubit/server_state.dart';
import 'compact_switch.dart';

/// "New devices need your approval" toggle.
class ApprovalCard extends StatelessWidget {
  const ApprovalCard({super.key});

  static const _label = 'New devices need your approval';

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final sc = context.serverColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KontrolSpacing.s14,
        vertical: KontrolSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KontrolRadii.r12),
        border: Border.all(color: sc.cardBorder),
      ),
      child: Row(
        spacing: KontrolSpacing.s12,
        children: [
          Icon(LucideIcons.shieldCheck, size: 18, color: c.accentText),
          Expanded(
            child: Text(
              _label,
              style: KontrolTypography.callout.copyWith(
                color: sc.textSoft,
                height: 1.2,
              ),
            ),
          ),
          BlocSelector<ServerCubit, ServerState, bool?>(
            selector: (state) => switch (state) {
              ServerRunning(:final controls) => controls.requireApproval,
              _ => null,
            },
            builder: (context, requireApproval) => CompactSwitch(
              value: requireApproval ?? true,
              semanticLabel: 'Require approval for new devices',
              onChanged: requireApproval == null
                  ? null
                  : (v) => context.read<ServerCubit>().setRequireApproval(v),
            ),
          ),
        ],
      ),
    );
  }
}
