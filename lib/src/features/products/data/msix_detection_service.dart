import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MSIXDetectionService {
  Future<String?> getAppVersion(String packageFamilyName) async {
    if (!Platform.isWindows) return null;

    try {
      final result = await Process.run('powershell', [
        '-Command',
        'Get-AppxPackage -Name "$packageFamilyName" | Select-Object -ExpandProperty Version',
      ]);

      final version = result.stdout.toString().trim();
      return version.isNotEmpty ? version : null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>> getInstalledVersions() async {
    if (!Platform.isWindows) return {};

    try {
      // Return map of FamilyName -> Version
      // We'll use a custom format to specific output for easier parsing
      final resultText = await Process.run('powershell', [
        '-Command',
        r'Get-AppxPackage | ForEach-Object { $_.PackageFamilyName + "=" + $_.Version }',
      ]);

      final map = <String, String>{};
      final lines = resultText.stdout.toString().split('\n');
      for (final line in lines) {
        final parts = line.trim().split('=');
        if (parts.length == 2) {
          map[parts[0]] = parts[1];
        }
      }
      return map;
    } catch (e) {
      return {};
    }
  }
}

final msixDetectionServiceProvider = Provider((ref) => MSIXDetectionService());
