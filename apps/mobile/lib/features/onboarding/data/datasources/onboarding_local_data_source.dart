import 'package:shared_preferences/shared_preferences.dart';

class OnboardingLocalDataSource {
  static const _key = 'onboarding_completed_v1';

  /// Loads [SharedPreferences] on use, so a platform failure surfaces here
  /// (and is mapped by the repository) instead of crashing app startup.
  final Future<SharedPreferences> Function() _prefs;

  OnboardingLocalDataSource(this._prefs);

  Future<bool> isCompleted() async => (await _prefs()).getBool(_key) ?? false;

  Future<void> markCompleted() async {
    final saved = await (await _prefs()).setBool(_key, true);
    if (!saved) {
      throw StateError('Failed to persist onboarding completion flag.');
    }
  }
}
