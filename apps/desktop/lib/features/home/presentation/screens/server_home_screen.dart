import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/time/clock.dart';
import '../../../../core/window/window_shell.dart';
import '../../../devices/presentation/cubit/devices_cubit.dart';
import '../../../devices/presentation/cubit/devices_state.dart';
import '../../../server/presentation/cubit/server_cubit.dart';
import '../../../server/presentation/cubit/server_state.dart';
import '../widgets/devices_pane.dart';
import '../widgets/side_panel.dart';
import '../widgets/title_bar.dart';

/// The 820×560 Kontrol Server main window.
class ServerHomeScreen extends StatelessWidget {
  const ServerHomeScreen({
    super.key,
    required this.windowShell,
    this.now = DateTime.now,
  });

  final WindowShell windowShell;
  final Now now;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ServerCubit, ServerState>(
          listenWhen: (_, s) => s is ServerActionFailed,
          listener: (context, s) =>
              _showError(context, (s as ServerActionFailed).message),
        ),
        BlocListener<DevicesCubit, DevicesState>(
          listenWhen: (_, s) => s is DevicesActionFailed,
          listener: (context, s) =>
              _showError(context, (s as DevicesActionFailed).message),
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            TitleBar(windowShell: windowShell),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SidePanel(),
                  Expanded(child: DevicesPane(now: now)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
