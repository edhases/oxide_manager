import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AndroidDetectionService {
  static const _channel = MethodChannel('com.oxide.oxide_manager/apps');

  Future<String?> getAppVersion(String packageName) async {
    if (!Platform.isAndroid) return null;

    try {
      final String? version = await _channel.invokeMethod('getAppVersion', {
        'packageName': packageName,
      });
      return version;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, String>> getInstalledVersions(
    List<String> packageNames,
  ) async {
    if (!Platform.isAndroid) return {};

    final installed = <String, String>{};
    for (final name in packageNames) {
      final version = await getAppVersion(name);
      if (version != null) {
        installed[name] = version;
      }
    }
    return installed;
  }
}

final androidDetectionServiceProvider = Provider(
  (ref) => AndroidDetectionService(),
);
