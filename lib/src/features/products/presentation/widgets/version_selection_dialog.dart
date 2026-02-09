import 'package:flutter/material.dart';
import 'package:oxide_manager/l10n/app_localizations.dart';
import '../../domain/models/release.dart';

class VersionSelectionDialog extends StatelessWidget {
  const VersionSelectionDialog({
    super.key,
    required this.release,
    required this.assets,
  });

  final Release release;
  final List<ReleaseAsset> assets;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text('${l10n.selectVersion} (${release.tag})'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            final type = asset.windowsType;

            return ListTile(
              leading: Icon(
                type == WindowsAssetType.portable
                    ? Icons.folder_zip
                    : Icons.install_desktop,
              ),
              title: Text(type.label),
              subtitle: Text(
                '${asset.name} (${(asset.size / 1024 / 1024).toStringAsFixed(1)} MB)',
              ),
              onTap: () => Navigator.of(context).pop(asset),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
