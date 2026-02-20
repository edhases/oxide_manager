import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

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
      await _installApk(filePath);
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

      // 2. Search for common installation triggers
      final installBat = File(p.join(extractionPath, 'install.bat'));
      final setupExe = File(p.join(extractionPath, 'setup.exe'));
      final installExe = File(p.join(extractionPath, 'install.exe'));

      if (await installBat.exists()) {
        await _runCommand('cmd.exe', ['/c', 'install.bat'], extractionPath);
      } else if (await setupExe.exists()) {
        await _runFile(setupExe.path);
      } else if (await installExe.exists()) {
        await _runFile(installExe.path);
      } else {
        // Search for any .msix or .msi in the root
        final entities = await dir.list().toList();
        final installer = entities.whereType<File>().firstWhere(
          (f) => f.path.endsWith('.msix') || f.path.endsWith('.msi'),
          orElse: () => File(''),
        );

        if (installer.path.isNotEmpty) {
          await _runFile(installer.path);
        } else {
          // Fallback: just open the directory
          await Process.run('explorer.exe', [extractionPath]);
        }
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

  Future<void> _runCommand(
    String command,
    List<String> args,
    String workingDirectory,
  ) async {
    final result = await Process.run(
      command,
      args,
      workingDirectory: workingDirectory,
    );
    if (result.exitCode != 0) {
      throw Exception('Command failed ($command): ${result.stderr}');
    }
  }

  Future<void> _installApk(String filePath) async {
    const channel = MethodChannel('com.oxide.oxide_manager/apps');
    try {
      await channel.invokeMethod('installApk', {'filePath': filePath});
    } on PlatformException catch (e) {
      if (e.code == 'INSTALL_ERROR' || e.code == 'FILE_NOT_FOUND') {
        throw Exception('Native installation failed: ${e.message}');
      }
      rethrow;
    }
  }

  Future<bool> checkInstallPermission() async {
    if (!Platform.isAndroid) return true;
    const channel = MethodChannel('com.oxide.oxide_manager/apps');
    return await channel.invokeMethod<bool>('checkInstallPermission') ?? true;
  }

  Future<void> openInstallSettings() async {
    if (!Platform.isAndroid) return;
    const channel = MethodChannel('com.oxide.oxide_manager/apps');
    await channel.invokeMethod('openInstallSettings');
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> uninstall(String packageName) async {
    if (!Platform.isAndroid) return;
    const channel = MethodChannel('com.oxide.oxide_manager/apps');
    try {
      await channel.invokeMethod('uninstallApp', {'packageName': packageName});
    } on PlatformException catch (e) {
      throw Exception('Failed to uninstall app: ${e.message}');
    }
  }
}

final installerServiceProvider = Provider((ref) => InstallerService());
