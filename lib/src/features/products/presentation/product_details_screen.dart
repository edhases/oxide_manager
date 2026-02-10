import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';
import '../data/products_repository.dart';
import '../data/release_fetcher.dart';
import '../domain/models/release.dart';
import '../domain/product.dart';
import 'controllers/install_controller.dart';
import 'widgets/install_button.dart';

class ProductDetailsScreen extends ConsumerWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return productsAsync.when(
      data: (products) {
        final product = products.firstWhere(
          (p) => p.id == productId,
          orElse: () => throw Exception('Product not found'),
        );

        final releasesAsync = ref.watch(productReleasesProvider(product));
        final installState = ref.watch(installControllerProvider(productId));

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                pinned: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withOpacity(
                              0.5,
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: product.iconUrl.startsWith('http')
                              ? Image.network(
                                  product.iconUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.apps,
                                        size: 72,
                                        color: theme.colorScheme.primary,
                                      ),
                                )
                              : Image.asset(
                                  product.iconUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.apps,
                                        size: 72,
                                        color: theme.colorScheme.primary,
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(title: l10n.about),
                      const SizedBox(height: 12),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${l10n.repository}: ${product.repoOwner}/${product.repoName}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 48),
                      _SectionHeader(title: l10n.releases),
                      const SizedBox(height: 16),
                      releasesAsync.when(
                        data: (releases) {
                          if (releases.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 48,
                                ),
                                child: Text(l10n.noReleasesFound),
                              ),
                            );
                          }
                          return ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: releases.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final release = releases[index];
                              final isCompatible = _checkCompatibility(release);
                              final bool isInstalled =
                                  product.installedTag == release.tag;

                              return _ReleaseCard(
                                release: release,
                                productId: productId,
                                isCompatible: isCompatible,
                                installState: installState,
                                isInstalled: isInstalled,
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (err, stack) =>
                            Center(child: Text('${l10n.error}: $err')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }

  bool _checkCompatibility(Release release) {
    if (Platform.isWindows) return release.hasWindowsAsset;
    if (Platform.isAndroid) return release.hasAndroidAsset;
    if (Platform.isLinux) return release.hasLinuxAsset;
    return false;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ReleaseCard extends StatelessWidget {
  const _ReleaseCard({
    required this.release,
    required this.productId,
    required this.isCompatible,
    required this.installState,
    required this.isInstalled,
  });

  final Release release;
  final String productId;
  final bool isCompatible;
  final InstallState installState;
  final bool isInstalled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final isDownloading =
        installState.status == InstallStatus.downloading &&
        installState.activeReleaseTag == release.tag;
    final isInstalling =
        installState.status == InstallStatus.installing &&
        installState.activeReleaseTag == release.tag;
    final isError =
        installState.status == InstallStatus.error &&
        installState.activeReleaseTag == release.tag;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          release.tag,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isInstalled) ...[
                          const SizedBox(width: 8),
                          _SmallBadge(
                            label: l10n.installed,
                            color: Colors.green,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.publishedAt}: ${release.publishedAt.toLocal().toString().split(' ')[0]}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              InstallButton(
                productId: productId,
                release: release,
                isCompatible: isCompatible,
                compatibilityMessage: !isCompatible ? l10n.incompatible : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...release.supportedPlatforms.map((platform) {
                final bool isCurrentPlatform =
                    (platform == 'Windows' && Platform.isWindows) ||
                    (platform == 'Android' && Platform.isAndroid) ||
                    (platform == 'Linux' && Platform.isLinux);

                return _SmallBadge(
                  label: platform,
                  color: isCurrentPlatform ? Colors.blue : Colors.grey,
                );
              }),
              if (!isCompatible)
                _SmallBadge(
                  label: l10n.incompatible,
                  color: Colors.orange,
                  icon: Icons.warning_amber_rounded,
                ),
            ],
          ),
          if (isDownloading || isInstalling) ...[
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: isInstalling ? null : installState.progress,
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isInstalling ? l10n.installing : l10n.downloading,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isInstalling)
                  Text(
                    '${(installState.progress * 100).toInt()}%',
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
          ] else if (isError) ...[
            const SizedBox(height: 12),
            Text(
              '${l10n.error}: ${installState.error}',
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color, this.icon});

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
