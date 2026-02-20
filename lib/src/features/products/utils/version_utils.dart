class VersionUtils {
  static String normalize(String version) {
    if (version.isEmpty) return '';

    // 1. Basic cleanup: remove 'v' prefix
    String v = version.toLowerCase().trim().replaceAll('v', '');

    // 2. Convert SemVer build '+' to '.' (e.g. 2026.2.10+1 -> 2026.2.10.1)
    v = v.replaceAll('+', '.');

    final parts = v.split('.');

    // 3. New Unified Format: YYYY.MM.DD[.Build]
    // If it's already perfectly formatted with dots, we ensure leading zeros for Month and Day
    if (parts.length >= 3 && parts[0].length == 4) {
      String y = parts[0];
      String m = parts[1].padLeft(2, '0');
      String d = parts[2].padLeft(2, '0');

      String result = '$y$m$d';

      // Append Build number if exists and > 0
      if (parts.length > 3) {
        String build = parts[3];
        if (int.tryParse(build) != 0) {
          result += build;
        }
      }
      return result;
    }

    // 4. Legacy Support A: First part is a full 8-digit date (e.g. 20260210 or 20260209.1)
    if (parts.isNotEmpty && parts[0].length == 8 && parts[0].startsWith('20')) {
      String result = parts[0];
      // Append extra parts if they exist (e.g. .1 -> 1)
      if (parts.length > 1) {
        result += parts.skip(1).join('');
      }
      return result;
    }

    // 5. Legacy Support B: Old YY.M.D format (e.g. 26.2.10)
    if (parts.length >= 2) {
      String y = parts[0];
      String m = parts[1].padLeft(2, '0');
      String d = parts.length > 2 ? parts[2].padLeft(2, '0') : '01';

      if (y.length == 2 && int.tryParse(y) != null) {
        final yearNum = int.parse(y);
        if (yearNum >= 24 && yearNum <= 30) {
          y = '20$y';
        }
      }

      String result = '$y$m$d';
      if (parts.length > 3) {
        String build = parts[3];
        if (int.tryParse(build) != 0) {
          result += build;
        }
      }
      return result;
    }

    // 6. Fallback: just return digits
    return v.replaceAll('.', '');
  }

  static bool isSameVersion(String? v1, String? v2) {
    if (v1 == null || v2 == null) return false;
    return normalize(v1) == normalize(v2);
  }
}
