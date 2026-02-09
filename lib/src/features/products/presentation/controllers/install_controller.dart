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

      // 2. Download
      final fileName = asset.name;
      await for (final progress in downloadService.downloadFile(
        asset.downloadUrl,
        fileName,
      )) {
        state = state.copyWith(progress: progress);
      }

      state = state.copyWith(status: InstallStatus.installing);

      // 3. Install
      final filePath = await downloadService.getDownloadPath(fileName);
      await installerService.install(filePath);

      // 4. Record as installed
      await trackingService.setInstalledTag(productId, release.tag);

      state = state.copyWith(status: InstallStatus.success);
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
