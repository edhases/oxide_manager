import 'package:flutter/material.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';

class GlobalNavigationMenu extends StatelessWidget {
  const GlobalNavigationMenu({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icon(
            currentIndex == 0 ? Icons.apps_rounded : Icons.settings_rounded,
            color: theme.colorScheme.primary,
          ),
          tooltip: 'Menu',
        );
      },
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.apps_rounded),
          onPressed: () => onTap(0),
          child: Text(l10n.store),
        ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.settings_rounded),
          onPressed: () => onTap(1),
          child: Text(l10n.settings),
        ),
      ],
    );
  }
}
