import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

class KontrolApp extends StatelessWidget {
  final GoRouter router;

  const KontrolApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kontrol',
      theme: KontrolTheme.light(),
      darkTheme: KontrolTheme.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
