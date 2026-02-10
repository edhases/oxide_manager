import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AndroidDetectionService {
  static const _channel = MethodChannel('com.oxide.manager/detection');

  Future<String?> getPackageVersion(String packageName) async {
    try {
      final String? version = await _channel.invokeMethod('getPackageVersion', {
        'packageName': packageName,
      });
      return version;
    } on PlatformException catch (e) {
      print("Failed to get package version: '${e.message}'.");
      return null;
    }
  }
}

final androidDetectionServiceProvider = Provider(
  (ref) => AndroidDetectionService(),
);
