import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p_path;
import '../domain/product.dart';
import '../../settings/data/settings_service.dart';
import 'installation_tracking_service.dart';
import 'msix_detection_service.dart';
import 'android_detection_service.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  try {
    final trackingService = ref.watch(installationTrackingServiceProvider);
    final msixService = ref.watch(msixDetectionServiceProvider);
    final androidService = ref.watch(androidDetectionServiceProvider);
    final settings = ref.watch(settingsServiceProvider);
    final installPath = settings.installPath;

    String appVersion = 'unknown';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (e) {
      // Fallback if PackageInfo fails
    }

    // MSIX detection: Get all installed families at once for efficiency
    final installedFamilies = await msixService.getInstalledPackageFamilies();

    // Mock data for now
    await Future.delayed(const Duration(milliseconds: 200));

    final rawProducts = [
      const Product(
        id: 'oxide-manager',
        name: 'Oxide Manager',
        description: 'The dashboard to manage all your Oxide apps.',
        iconUrl: 'assets/products/oxide_manager.png',
        channels: ['stable'],
        repoOwner: 'edhases',
        repoName: 'oxide_manager',
        executableName: 'oxide_manager.exe',
        androidPackageName: 'com.oxide.oxide_manager',
      ),
      const Product(
        id: 'oxide-player',
        name: 'Oxide Player',
        description: 'Modern media player for Oxide ecosystem.',
        iconUrl: 'assets/products/oxide_player.png',
        channels: ['stable', 'beta'],
        repoOwner: 'edhases',
        repoName: 'a_player',
        executableName: 'oxide_player.exe',
        packageFamilyName:
            'Edhases.OxidePlayer_fxkeb4dgdm144', // Assuming similar publisher
        androidPackageName: 'com.oxideplayer.app',
      ),
      const Product(
        id: 'oxide-film',
        name: 'Oxide Film',
        description: 'Movie catalog and streaming application.',
        iconUrl: 'assets/products/oxide_film.png',
        channels: ['stable'],
        repoOwner: 'edhases',
        repoName: 'oxide_film',
        executableName: 'oxide_film.exe',
        packageFamilyName: 'com.oxide.film_fxkeb4dgdm144',
        androidPackageName: 'com.oxide.film',
      ),
    ];

    final products = <Product>[];

    for (final p in rawProducts) {
      if (p.id == 'oxide-manager') {
        products.add(p.copyWith(installedTag: appVersion));
        continue;
      }

      var tag = trackingService.getInstalledTag(p.id);

      // 1. MSIX Smart Detection (Windows)
      if (tag == null && Platform.isWindows && p.packageFamilyName != null) {
        if (installedFamilies.contains(p.packageFamilyName)) {
          tag = 'installed';
        }
      }

      // 2. Android Smart Detection
      if (tag == null && Platform.isAndroid && p.androidPackageName != null) {
        final version = await androidService.getPackageVersion(
          p.androidPackageName!,
        );
        if (version != null) {
          tag = version;
        }
      }

      // 3. File System Smart Detection (Windows/Desktop)
      if (tag == null && installPath.isNotEmpty && p.executableName != null) {
        final possiblePaths = [
          p_path.join(installPath, p.repoName, p.executableName),
          p_path.join(installPath, p.id, p.executableName),
          p_path.join(installPath, p.executableName),
        ];

        for (final path in possiblePaths) {
          if (File(path).existsSync()) {
            tag = 'installed';
            break;
          }
        }
      }

      products.add(p.copyWith(installedTag: tag));
    }

    return products;
  } catch (e) {
    throw 'Error during products loading: $e';
  }
});
