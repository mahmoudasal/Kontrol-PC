import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

import '../../domain/entities/server_controls.dart';
import '../cubit/server_cubit.dart';
import '../cubit/server_state.dart';

typedef _ChipStatus = (String label, StatusTone tone, StatusDotShape shape);

/// "Ready to pair" chip at the top of the side panel.
class ServerStatusChip extends StatelessWidget {
  const ServerStatusChip({super.key});

  static _ChipStatus _status(ServerState state) => switch (state) {
    ServerLoading() => ('Starting…', StatusTone.neutral, StatusDotShape.ring),
    ServerRunning(controls: ServerControls(paused: true)) => (
      'Control paused',
      StatusTone.warning,
      StatusDotShape.arc,
    ),
    ServerRunning() => (
      'Ready to pair',
      StatusTone.success,
      StatusDotShape.filled,
    ),
    ServerFailed() => (
      'Server stopped',
      StatusTone.danger,
      StatusDotShape.ring,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ServerCubit, ServerState, _ChipStatus>(
      selector: _status,
      builder: (context, status) {
        final (label, tone, shape) = status;
        return StatusChip(label: label, tone: tone, shape: shape);
      },
    );
  }
}
