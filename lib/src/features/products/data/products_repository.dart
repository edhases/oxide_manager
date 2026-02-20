import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/version_service.dart';
import 'package:path/path.dart' as p_path;
import '../domain/product.dart';
import '../../settings/data/settings_service.dart';
import 'msix_detection_service.dart';
import 'android_detection_service.dart';
import 'release_fetcher.dart';
import '../utils/version_utils.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  try {
    final msixService = ref.watch(msixDetectionServiceProvider);
    final androidService = ref.watch(androidDetectionServiceProvider);
    final fetcher = ref.watch(releaseFetcherProvider);
    final settings = ref.watch(settingsServiceProvider);
    final installPath = settings.installPath;

    final rawProducts = [
      const Product(
        id: 'oxide-manager',
        name: 'Oxide Manager',
        description: 'Управління продуктами Oxide',
        iconUrl: 'assets/products/om_icon.png',
        channels: ['stable'],
        repoOwner: 'edhases',
        repoName: 'oxide_manager',
        androidPackageName: 'com.oxide.oxide_manager',
      ),
      const Product(
        id: 'oxide-player',
        name: 'Oxide Player',
        description: 'Продвинутий медіаплеєр для Oxide OS',
        iconUrl: 'assets/products/oxide_player.png',
        channels: ['stable', 'beta'],
        repoOwner: 'edhases',
        repoName: 'a_player',
        executableName: 'Oxide Player.exe',
        packageFamilyName:
            'Oxide.Player_fxkeb4dgdm144', // Prediction based on others
        androidPackageName: 'com.example.vor_player',
      ),
      const Product(
        id: 'oxide-film',
        name: 'Oxide Film',
        description: 'Перегляд фільмів та серіалів',
        iconUrl: 'assets/products/oxide_film.png',
        channels: ['stable'],
        repoOwner: 'edhases',
        repoName: 'oxide_film',
        executableName: 'Oxide Film.exe',
        packageFamilyName: 'com.oxide.film_fxkeb4dgdm144',
        androidPackageName: 'com.oxidefilm.oxide_film',
      ),
    ];

    // Get installed versions
    final installedFamilies = await msixService.getInstalledVersions();
    final androidPackageNames = rawProducts
        .map((p) => p.androidPackageName)
        .where((n) => n != null)
        .cast<String>()
        .toList();
    final installedAndroidApps = await androidService.getInstalledVersions(
      androidPackageNames,
    );

    final products = await Future.wait(
      rawProducts.map((p) async {
        String? installedVersion;

        // 1. MSIX Detection
        if (installedFamilies.containsKey(p.packageFamilyName)) {
          installedVersion = installedFamilies[p.packageFamilyName];
        }

        // 2. Android Detection
        if (installedVersion == null &&
            p.androidPackageName != null &&
            Platform.isAndroid) {
          if (installedAndroidApps.containsKey(p.androidPackageName)) {
            final androidVer = installedAndroidApps[p.androidPackageName]!;
            installedVersion = VersionUtils.normalize(androidVer);
          }
        }

        // 3. File System Detection (Windows/Linux)
        if (installedVersion == null &&
            installPath.isNotEmpty &&
            p.executableName != null) {
          final possiblePaths = [
            p_path.join(installPath, p.repoName, p.executableName),
            p_path.join(installPath, p.id, p.executableName),
            p_path.join(installPath, p.executableName!),
          ];

          for (final path in possiblePaths) {
            if (File(path).existsSync()) {
              installedVersion = 'installed';
              break;
            }
          }
        }

        // Handle self version
        if (p.id == 'oxide-manager') {
          installedVersion = VersionService.versionName;
        }

        // Fetch latest version from GitHub
        String? latestVersion;
        try {
          final releases = await fetcher.fetchReleases(p.repoOwner, p.repoName);
          if (releases.isNotEmpty) {
            latestVersion = releases.first.tag;
          }
        } catch (e) {
          // Log error or ignore
        }

        return p.copyWith(
          installedTag: installedVersion,
          latestTag: latestVersion,
        );
      }),
    );

    return products;
  } catch (e) {
    throw 'Error during products loading: $e';
  }
});
