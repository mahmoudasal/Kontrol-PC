import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../../../core/theme/server_colors.dart';
import '../../../../core/time/clock.dart';
import '../cubit/devices_cubit.dart';
import '../cubit/devices_state.dart';
import 'device_row.dart';

/// Bordered list of paired phones, or its empty / error message.
class DeviceList extends StatelessWidget {
  const DeviceList({super.key, this.now = DateTime.now});

  /// Reference time for "Last seen …" labels.
  final Now now;

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final border = context.serverColors.cardBorder;
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        final child = switch (state) {
          DevicesLoading() => null,
          DevicesLoaded(:final devices) when devices.isEmpty => _Message(
            'No paired phones yet. Scan the code to pair.',
            color: c.text2,
          ),
          DevicesLoaded(:final devices) => ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: devices.length,
            separatorBuilder: (_, _) =>
                ColoredBox(color: border, child: const SizedBox(height: 1)),
            itemBuilder: (context, i) {
              final device = devices[i];
              final cubit = context.read<DevicesCubit>();
              return DeviceRow(
                key: ValueKey(device.id),
                device: device,
                now: now(),
                onDisconnect: () => cubit.disconnect(device.id),
                onRevoke: () => cubit.revoke(device.id),
              );
            },
          ),
          DevicesFailed(:final message) => _Message(
            message,
            color: c.dangerText,
          ),
        };
        if (child == null) return const SizedBox.shrink();
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KontrolRadii.r14),
            border: Border.all(color: border),
          ),
          child: child,
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.kColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(KontrolSpacing.s16),
        child: Text(
          text,
          style: KontrolTypography.callout.copyWith(color: color),
        ),
      ),
    );
  }
}
