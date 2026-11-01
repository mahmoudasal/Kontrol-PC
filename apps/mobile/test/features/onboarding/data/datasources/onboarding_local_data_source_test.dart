import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_mobile/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late OnboardingLocalDataSource dataSource;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dataSource = OnboardingLocalDataSource(SharedPreferences.getInstance);
  });

  test('defaults to not completed', () async {
    expect(await dataSource.isCompleted(), isFalse);
  });

  test('is completed after markCompleted', () async {
    await dataSource.markCompleted();

    expect(await dataSource.isCompleted(), isTrue);
  });

  test('propagates a SharedPreferences load failure', () {
    final failing = OnboardingLocalDataSource(
      () => Future.error(StateError('prefs unavailable')),
    );

    expect(failing.isCompleted(), throwsStateError);
  });
}
