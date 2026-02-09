import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';
import '../../domain/models/release.dart';
import '../controllers/install_controller.dart';
import 'version_selection_dialog.dart';

class InstallButton extends ConsumerWidget {
  const InstallButton({
    super.key,
    required this.productId,
    required this.release,
    this.isCompatible = true,
    this.compatibilityMessage,
  });

  final String productId;
  final Release release;
  final bool isCompatible;
  final String? compatibilityMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final installState = ref.watch(installControllerProvider(productId));

    final isDownloading =
        installState.status == InstallStatus.downloading &&
        installState.activeReleaseTag == release.tag;
    final isInstalling =
        installState.status == InstallStatus.installing &&
        installState.activeReleaseTag == release.tag;
    final isSuccess =
        installState.status == InstallStatus.success &&
        installState.activeReleaseTag == release.tag;

    final isAnyActionInProgress =
        installState.status == InstallStatus.downloading ||
        installState.status == InstallStatus.installing;

    return FilledButton(
      key: ValueKey('install_${release.tag}'),
      onPressed: (isAnyActionInProgress || !isCompatible)
          ? null
          : () => _handleInstall(context, ref),
      child: Tooltip(
        message: !isCompatible
            ? (compatibilityMessage ?? l10n.incompatible)
            : '${l10n.install} ${release.tag}',
        child: Text(
          isSuccess
              ? l10n.installed
              : (isInstalling
                    ? l10n.installing
                    : (isDownloading ? l10n.downloading : l10n.install)),
        ),
      ),
    );
  }

  Future<void> _handleInstall(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(installControllerProvider(productId).notifier);

    // Check if we have multiple assets for Windows
    if (Platform.isWindows) {
      final assets = release.windowsAssets;
      if (assets.length > 1) {
        final selected = await showDialog<ReleaseAsset>(
          context: context,
          builder: (context) =>
              VersionSelectionDialog(release: release, assets: assets),
        );
        if (selected != null) {
          await controller.installRelease(release, specificAsset: selected);
        }
        return;
      }
    }

    // Default fallback
    await controller.installRelease(release);
  }
}
