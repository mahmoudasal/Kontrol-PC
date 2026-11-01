import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/app.dart';
import 'package:kontrol_mobile/core/router/app_router.dart';
import 'package:kontrol_mobile/core/router/app_routes.dart';

void main() {
  testWidgets('devices location shows the Devices placeholder', (tester) async {
    await tester.pumpWidget(
      KontrolApp(router: createRouter(initialLocation: AppRoutes.devices)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Devices'), findsOneWidget);
  });
}
