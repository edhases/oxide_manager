import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';
import '../data/settings_service.dart';
import '../../products/data/products_repository.dart';
import '../../../shared/utils/version_comparator.dart';
import '../../../shared/widgets/global_navigation_menu.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsServiceProvider);
    final notifier = ref.read(settingsServiceProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final navigationShell = StatefulNavigationShell.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
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
          l10n.settings,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _SettingsSection(
            title: l10n.appearance,
            children: [
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.theme),
                trailing: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  underline: const SizedBox(),
                  onChanged: (mode) {
                    if (mode != null) notifier.setThemeMode(mode);
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.themeSystem),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.themeLight),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.themeDark),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: Text(l10n.language),
                trailing: DropdownButton<Locale>(
                  value: settings.locale,
                  underline: const SizedBox(),
                  onChanged: (locale) {
                    if (locale != null) notifier.setLocale(locale);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('uk'),
                      child: Text('Українська'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _SettingsSection(
            title: l10n.general,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open_outlined),
                title: Text(l10n.installDirectory),
                subtitle: Text(
                  settings.installPath.isEmpty
                      ? l10n.defaultTempDir
                      : settings.installPath,
                ),
                onTap: () async {
                  final String? selectedDirectory = await FilePicker.platform
                      .getDirectoryPath();
                  if (selectedDirectory != null) {
                    await notifier.setInstallPath(selectedDirectory);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 48),
          Center(
            child: ref
                .watch(productsProvider)
                .when(
                  data: (products) {
                    final manager = products.firstWhere(
                      (p) => p.id == 'oxide-manager',
                    );
                    return Column(
                      children: [
                        Text(
                          'Oxide Manager',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          'Version ${manager.installedTag ?? 'Unknown'}${VersionComparator.isUpdateAvailable(manager.installedTag, manager.latestTag) ? ' (Update available: ${manager.latestTag})' : ''}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          color: theme.colorScheme.surfaceContainerLow,
          child: Column(children: children),
        ),
      ],
    );
  }
}
