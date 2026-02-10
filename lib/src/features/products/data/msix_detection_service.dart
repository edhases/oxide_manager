import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MSIXDetectionService {
  Future<bool> isInstalled(String packageFamilyName) async {
    if (!Platform.isWindows) return false;

    try {
      // Use Get-AppxPackage to check if the package exists
      final result = await Process.run('powershell', [
        '-Command',
        'Get-AppxPackage -Name "$packageFamilyName"',
      ]);

      // If the output is not empty, it means the package is found
      return result.stdout.toString().trim().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<Set<String>> getInstalledPackageFamilies() async {
    if (!Platform.isWindows) return {};

    try {
      final result = await Process.run('powershell', [
        '-Command',
        'Get-AppxPackage | Select-Object -ExpandProperty PackageFamilyName',
      ]);

      return result.stdout
          .toString()
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toSet();
    } catch (e) {
      return {};
    }
  }
}

final msixDetectionServiceProvider = Provider((ref) => MSIXDetectionService());
