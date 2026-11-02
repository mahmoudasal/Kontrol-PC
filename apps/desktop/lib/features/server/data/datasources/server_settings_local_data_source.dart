import 'package:shared_preferences/shared_preferences.dart';

class ServerSettingsLocalDataSource {
  static const _requireApprovalKey = 'server.requireApproval';

  final Future<SharedPreferences> Function() _prefs;

  ServerSettingsLocalDataSource(this._prefs);

  /// Defaults to `true`: new phones need approval unless the user opts out.
  Future<bool> getRequireApproval() async =>
      (await _prefs()).getBool(_requireApprovalKey) ?? true;

  Future<void> setRequireApproval(bool value) async {
    await (await _prefs()).setBool(_requireApprovalKey, value);
  }
}
