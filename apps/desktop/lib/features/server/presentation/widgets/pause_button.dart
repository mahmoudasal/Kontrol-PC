import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../cubit/server_cubit.dart';
import '../cubit/server_state.dart';

/// "Pause control" toggle in the devices header. Hidden until the server runs.
class PauseButton extends StatelessWidget {
  const PauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ServerCubit, ServerState, bool?>(
      selector: (state) => switch (state) {
        ServerRunning(:final controls) => controls.paused,
        _ => null,
      },
      builder: (context, paused) {
        if (paused == null) return const SizedBox(height: 34);
        final c = context.kColors;
        return Semantics(
          toggled: paused,
          child: OutlinedButton.icon(
            onPressed: () => context.read<ServerCubit>().togglePaused(),
            icon: Icon(paused ? LucideIcons.play : LucideIcons.pause, size: 14),
            label: Text(paused ? 'Resume control' : 'Pause control'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(0, 34),
              fixedSize: const Size.fromHeight(34),
              padding: const EdgeInsets.symmetric(
                horizontal: KontrolSpacing.s12,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: paused ? c.accentSoft : c.surface,
              foregroundColor: paused ? c.accentText : c.text,
              side: BorderSide(color: paused ? c.accent : c.borderStrong),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(KontrolRadii.r10),
              ),
              textStyle: KontrolTypography.callout.copyWith(
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ).copyWith(iconSize: const WidgetStatePropertyAll(14)),
          ),
        );
      },
    );
  }
}
