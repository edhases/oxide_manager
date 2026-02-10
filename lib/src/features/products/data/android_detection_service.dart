import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AndroidDetectionService {
  static const _channel = MethodChannel('com.oxide.oxide_manager/apps');

  Future<bool> isInstalled(String packageName) async {
    if (!Platform.isAndroid) return false;

    try {
      final bool installed = await _channel.invokeMethod('isAppInstalled', {
        'packageName': packageName,
      });
      return installed;
    } catch (e) {
      return false;
    }
  }

  Future<Set<String>> getInstalledPackages(List<String> packageNames) async {
    if (!Platform.isAndroid) return {};

    final installed = <String>{};
    for (final name in packageNames) {
      if (await isInstalled(name)) {
        installed.add(name);
      }
    }
    return installed;
  }
}

final androidDetectionServiceProvider = Provider(
  (ref) => AndroidDetectionService(),
);
