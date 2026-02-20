import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/download_service.dart';
import '../../data/installer_service.dart';
import '../../data/installation_tracking_service.dart';
import '../../domain/models/release.dart';

enum InstallStatus { idle, downloading, installing, success, error }

class InstallState {
  InstallState({
    this.status = InstallStatus.idle,
    this.progress = 0.0,
    this.activeReleaseTag,
    this.error,
  });

  final InstallStatus status;
  final double progress;
  final String? activeReleaseTag;
  final String? error;

  InstallState copyWith({
    InstallStatus? status,
    double? progress,
    String? activeReleaseTag,
    String? error,
  }) {
    return InstallState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      activeReleaseTag: activeReleaseTag ?? this.activeReleaseTag,
      error: error ?? this.error,
    );
  }
}

class ProductInstallController extends StateNotifier<InstallState> {
  ProductInstallController({
    required this.productId,
    required this.downloadService,
    required this.installerService,
    required this.trackingService,
  }) : super(InstallState());

  final String productId;
  final DownloadService downloadService;
  final InstallerService installerService;
  final InstallationTrackingService trackingService;

  Future<void> installRelease(
    Release release, {
    ReleaseAsset? specificAsset,
  }) async {
    // 1. Find correct asset
    final asset = specificAsset ?? _findBestAsset(release);
    if (asset == null) {
      state = state.copyWith(
        status: InstallStatus.error,
        error: 'No compatible package found for this operating system.',
      );
      return;
    }

    try {
      state = state.copyWith(
        status: InstallStatus.downloading,
        progress: 0.0,
        activeReleaseTag: release.tag,
        error: null,
      );

      // 2. Download (or reuse)
      final fileName = asset.name;
      final filePath = await downloadService.getDownloadPath(fileName);
      final file = File(filePath);

      if (await file.exists()) {
        state = state.copyWith(progress: 1.0);
      } else {
        await for (final progress in downloadService.downloadFile(
          asset.downloadUrl,
          fileName,
        )) {
          state = state.copyWith(progress: progress);
        }
      }

      state = state.copyWith(status: InstallStatus.installing);

      // 3. Install
      if (Platform.isAndroid) {
        final hasPermission = await installerService.checkInstallPermission();
        if (!hasPermission) {
          state = state.copyWith(
            status: InstallStatus.error,
            error:
                'Для встановлення потрібно надати дозвіл "Встановлення невідомих додатків".',
          );
          await installerService.openInstallSettings();
          return;
        }
      }

      await installerService.install(filePath);

      // 4. Handle confirmation/recording
      if (Platform.isAndroid) {
        // On Android, the system installer takes over. We don't know if they finished.
        // We reset to initial state and let ProductsRepository's package detection
        // handle the "Installed" state when the user comes back.
        state = state.copyWith(status: InstallStatus.idle);
      } else {
        // For Windows/others where we track manually (or for ZIP installs)
        await trackingService.setInstalledTag(productId, release.tag);
        state = state.copyWith(status: InstallStatus.success);

        // 5. Cleanup
        await installerService.deleteFile(filePath);
      }
    } catch (e) {
      state = state.copyWith(status: InstallStatus.error, error: e.toString());
    }
  }

  Future<void> uninstall(String packageName) async {
    try {
      await installerService.uninstall(packageName);
    } catch (e) {
      state = state.copyWith(status: InstallStatus.error, error: e.toString());
    }
  }

  ReleaseAsset? _findBestAsset(Release release) {
    if (Platform.isWindows) {
      final windowsAssets = release.windowsAssets;
      if (windowsAssets.isEmpty) return null;
      // Prefer installer over portable/archive
      try {
        return windowsAssets.firstWhere(
          (a) => a.windowsType == WindowsAssetType.installer,
        );
      } catch (_) {
        return windowsAssets.first;
      }
    } else if (Platform.isAndroid) {
      final androidAssets = release.androidAssets;
      if (androidAssets.isEmpty) return null;
      return androidAssets.first;
    } else if (Platform.isLinux) {
      final linuxAssets = release.linuxAssets;
      if (linuxAssets.isEmpty) return null;
      return linuxAssets.first;
    }
    return null;
  }
}

final installControllerProvider =
    StateNotifierProvider.family<
      ProductInstallController,
      InstallState,
      String
    >((ref, productId) {
      final downloadService = ref.watch(downloadServiceProvider);
      final installerService = ref.watch(installerServiceProvider);
      final trackingService = ref.watch(installationTrackingServiceProvider);
      return ProductInstallController(
        productId: productId,
        downloadService: downloadService,
        installerService: installerService,
        trackingService: trackingService,
      );
    });
