import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/window/native_window_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final windowShell = NativeWindowShell.current()..configure();
  configureDependencies(windowShell: windowShell);

  runApp(KontrolServerApp(windowShell: windowShell));
}
