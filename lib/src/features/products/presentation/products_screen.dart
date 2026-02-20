import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';
import '../../../shared/widgets/global_navigation_menu.dart';
import '../data/products_repository.dart';
import '../data/release_fetcher.dart';
import '../domain/product.dart';
import '../../../shared/utils/version_comparator.dart';
import '../data/installer_service.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissions();
    });
  }

  Future<void> _checkPermissions() async {
    if (!Platform.isAndroid) return;

    final installerService = ref.read(installerServiceProvider);
    final hasPermission = await installerService.checkInstallPermission();

    if (!hasPermission && mounted) {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Необхідний дозвіл'),
        content: const Text(
          'Oxide Manager потребує дозволу на встановлення додатків з невідомих джерел, щоб ви могли завантажувати та оновлювати продукти Oxide.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(installerServiceProvider).openInstallSettings();
            },
            child: Text(l10n.settings),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final navigationShell = StatefulNavigationShell.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            leadingWidth: 56,
            leading: GlobalNavigationMenu(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
            title: Text(
              l10n.store,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Text(
                l10n.availableProducts,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          productsAsync.when(
            data: (products) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 360,
                  mainAxisExtent: 180,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = products[index];
                  return _ProductCard(product: product);
                }, childCount: products.length),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) =>
                SliverFillRemaining(child: Center(child: Text('Error: $err'))),
          ),
          // Extra padding at the bottom
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }
}

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Check for updates
    final releasesAsync = ref.watch(productReleasesProvider(product));
    final String? latestTag = releasesAsync.when(
      data: (releases) => releases.isNotEmpty ? releases.first.tag : null,
      loading: () => null,
      error: (_, __) => null,
    );

    final bool isInstalled = product.installedTag != null;
    final bool hasUpdate = VersionComparator.isUpdateAvailable(
      product.installedTag,
      latestTag,
    );

    return _AnimatedProductCard(
      product: product,
      isInstalled: isInstalled,
      hasUpdate: hasUpdate,
      l10n: l10n,
    );
  }
}

class _AnimatedProductCard extends StatefulWidget {
  const _AnimatedProductCard({
    required this.product,
    required this.isInstalled,
    required this.hasUpdate,
    required this.l10n,
  });

  final Product product;
  final bool isInstalled;
  final bool hasUpdate;
  final AppLocalizations l10n;

  @override
  State<_AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<_AnimatedProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          elevation: _isHovered ? 4 : 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: _isHovered
                  ? colorScheme.primary.withOpacity(0.5)
                  : colorScheme.outlineVariant,
              width: _isHovered ? 2 : 1,
            ),
          ),
          color: _isHovered
              ? colorScheme.surfaceContainer
              : colorScheme.surfaceContainerLow,
          child: InkWell(
            onTap: () => context.go('/products/${widget.product.id}'),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.product.iconUrl.startsWith('assets/')
                              ? Image.asset(
                                  widget.product.iconUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.apps,
                                        size: 28,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                )
                              : Image.network(
                                  widget.product.iconUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        Icons.apps,
                                        size: 28,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (widget.hasUpdate)
                              _StatusBadge(
                                label: widget.l10n.updateAvailable,
                                color: Colors.orange,
                              )
                            else if (widget.isInstalled)
                              _StatusBadge(
                                label: widget.l10n.installed,
                                color: Colors.green,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      widget.product.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
