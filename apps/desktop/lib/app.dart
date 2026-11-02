import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/theme/server_theme.dart';
import 'core/window/window_shell.dart';
import 'features/devices/presentation/cubit/devices_cubit.dart';
import 'features/home/presentation/screens/server_home_screen.dart';
import 'features/pairing/presentation/cubit/pairing_cubit.dart';
import 'features/server/presentation/cubit/server_cubit.dart';

class KontrolServerApp extends StatelessWidget {
  final WindowShell windowShell;

  const KontrolServerApp({super.key, required this.windowShell});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kontrol Server',
      darkTheme: buildServerTheme(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ServerCubit>()..load()),
          BlocProvider(create: (_) => getIt<PairingCubit>()..start()),
          BlocProvider(create: (_) => getIt<DevicesCubit>()..start()),
        ],
        child: ServerHomeScreen(windowShell: windowShell),
      ),
    );
  }
}
