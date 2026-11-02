import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/theme/server_colors.dart';
import '../../domain/entities/host_info.dart';
import '../cubit/server_cubit.dart';
import '../cubit/server_state.dart';

/// PC name, address and network, at the bottom of the side panel.
class HostInfoCard extends StatelessWidget {
  const HostInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KontrolSpacing.s14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(KontrolRadii.r12),
        border: Border.all(color: context.serverColors.cardBorder),
      ),
      // Pause and approval toggles do not change this card.
      child: BlocSelector<ServerCubit, ServerState, (HostInfo?, String?)>(
        selector: (state) => switch (state) {
          ServerRunning(:final host) => (host, null),
          ServerFailed(:final message) => (null, message),
          ServerLoading() => (null, null),
        },
        builder: (context, value) => switch (value) {
          (_, final String message) => Text(
            message,
            style: KontrolTypography.callout.copyWith(color: c.dangerText),
          ),
          (final host, _) => _HostRows(host: host),
        },
      ),
    );
  }
}

class _HostRows extends StatelessWidget {
  const _HostRows({required this.host});

  final HostInfo? host;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final host = this.host;
    final label = KontrolTypography.callout.copyWith(
      color: c.text3,
      height: 1.2,
    );
    final value = KontrolTypography.callout.copyWith(
      color: c.text,
      height: 1.2,
    );
    const placeholder = '—';
    final rows = [
      (
        'PC name',
        host?.pcName ?? placeholder,
        value.copyWith(fontWeight: FontWeight.w600),
      ),
      (
        'Address',
        host == null ? placeholder : '${host.address}:${host.port}',
        KontrolTypography.mono.copyWith(
          fontSize: 12,
          color: c.text,
          height: 1.2,
        ),
      ),
      ('Network', host?.networkName ?? placeholder, value),
    ];
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        for (final (i, (name, text, style)) in rows.indexed)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  end: KontrolSpacing.s14,
                  top: i == 0 ? 0 : KontrolSpacing.s8,
                ),
                child: Text(name, style: label),
              ),
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : KontrolSpacing.s8),
                child: Text(
                  text,
                  style: style,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
