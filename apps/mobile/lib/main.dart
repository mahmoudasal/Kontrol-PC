import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/router/initial_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  final initialLocation = await resolveInitialLocation(getIt());

  runApp(KontrolApp(router: createRouter(initialLocation: initialLocation)));
}
