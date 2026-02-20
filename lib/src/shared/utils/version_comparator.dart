import 'package:pub_semver/pub_semver.dart';

class VersionComparator {
  /// Returns 1 if v1 > v2 (update available)
  /// Returns 0 if v1 == v2
  /// Returns -1 if v1 < v2
  static int compare(String v1, String v2) {
    try {
      final version1 = Version.parse(_normalize(v1));
      final version2 = Version.parse(_normalize(v2));
      return version1.compareTo(version2);
    } catch (e) {
      // Fallback to string comparison if not semver
      return v1.compareTo(v2);
    }
  }

  static bool isUpdateAvailable(String? current, String? latest) {
    if (current == null || latest == null) return false;
    // remote > local
    return compare(latest, current) > 0;
  }

  static String _normalize(String v) {
    var version = v.trim();
    if (version.startsWith('v')) {
      version = version.substring(1);
    }
    // Handle Windows 4-part versions (1.0.0.0 -> 1.0.0)
    final parts = version.split('.');
    if (parts.length > 3) {
      return parts.take(3).join('.');
    }
    return version;
  }
}
