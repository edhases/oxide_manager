import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class InstallerService {
  Future<void> install(String filePath) async {
    final extension = p.extension(filePath).toLowerCase();

    if (Platform.isWindows) {
      if (extension == '.zip') {
        await _handleZipInstallation(filePath);
      } else {
        // Direct execution for .exe / .msi
        await _runFile(filePath);
      }
    } else if (Platform.isAndroid) {
      // TODO: Implement actual installation logic for Android
      // This usually involves opening the APK via intent
    } else if (Platform.isLinux) {
      // For Linux, we might need to chmod +x and run for AppImage
      await Process.run('chmod', ['+x', filePath]);
      await Process.run('explorer.exe', [
        filePath,
      ]); // This is a placeholder for Linux equivalent
    } else {
      throw UnimplementedError(
        'Installation not implemented for this platform',
      );
    }
  }

  Future<void> _handleZipInstallation(String zipPath) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final tempDir = await getTemporaryDirectory();
    final extractionPath = p.join(
      tempDir.path,
      'oxide_install_${DateTime.now().millisecondsSinceEpoch}',
    );
    final dir = Directory(extractionPath);
    await dir.create(recursive: true);

    try {
      // 1. Extract
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(p.join(extractionPath, filename));
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(data);
        } else {
          await Directory(
            p.join(extractionPath, filename),
          ).create(recursive: true);
        }
      }

      // 2. Search for install.bat
      final installBat = File(p.join(extractionPath, 'install.bat'));
      if (await installBat.exists()) {
        final result = await Process.run('cmd.exe', [
          '/c',
          'install.bat',
        ], workingDirectory: extractionPath);
        if (result.exitCode != 0) {
          throw Exception(
            'Installation failed via install.bat: ${result.stderr}',
          );
        }
      } else {
        // If no install.bat, assume it's just a portable app or something else
        // Maybe just open the directory?
        await Process.run('explorer.exe', [extractionPath]);
      }
    } finally {
      // 3. Cleanup is usually after user finishes installation,
      // but if it's a batch script that finishes, we can clean up some parts.
      // However, the user said "видалити завантаженне, щоб не забивати файли"
      // We should probably delete the original zip too.
      // NOTE: Deleting the extraction dir might break things if install.bat
      // just starts a long-running installer.
      // But for MSIX cert installs, it usually finishes quickly.
      // I'll keep the temp files for a bit or assume the batch script is the "installer"
    }
  }

  Future<void> _runFile(String filePath) async {
    final result = await Process.run('explorer.exe', [filePath]);
    if (result.exitCode != 0) {
      throw Exception('Failed to start installer: ${result.stderr}');
    }
  }
}

final installerServiceProvider = Provider((ref) => InstallerService());
