import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../settings/data/settings_service.dart';

class InstallationTrackingService {
  final SharedPreferences _prefs;

  InstallationTrackingService(this._prefs);

  static const _keyPrefix = 'installed_version_';

  String? getInstalledTag(String productId) {
    return _prefs.getString('$_keyPrefix$productId');
  }

  Future<void> setInstalledTag(String productId, String tag) async {
    await _prefs.setString('$_keyPrefix$productId', tag);
  }

  Future<void> removeInstalledTag(String productId) async {
    await _prefs.remove('$_keyPrefix$productId');
  }
}

final installationTrackingServiceProvider = Provider((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return InstallationTrackingService(prefs);
});
