import 'package:freezed_annotation/freezed_annotation.dart';

part 'release.freezed.dart';
part 'release.g.dart';

@freezed
abstract class Release with _$Release {
  const factory Release({
    @JsonKey(name: 'tag_name') required String tag,
    String? name,
    @JsonKey(name: 'published_at') required DateTime publishedAt,
    required List<ReleaseAsset> assets,
    String? body,
  }) = _Release;

  factory Release.fromJson(Map<String, dynamic> json) =>
      _$ReleaseFromJson(json);
}

@freezed
abstract class ReleaseAsset with _$ReleaseAsset {
  const factory ReleaseAsset({
    required String name,
    @JsonKey(name: 'browser_download_url') required String downloadUrl,
    required int size,
    @JsonKey(name: 'content_type') String? contentType,
  }) = _ReleaseAsset;

  factory ReleaseAsset.fromJson(Map<String, dynamic> json) =>
      _$ReleaseAssetFromJson(json);
}

enum WindowsAssetType {
  installer,
  portable,
  archive,
  unknown;

  String get label {
    return switch (this) {
      WindowsAssetType.installer => 'Installer',
      WindowsAssetType.portable => 'Portable',
      WindowsAssetType.archive => 'Archive',
      WindowsAssetType.unknown => 'Unknown',
    };
  }
}

extension ReleaseAssetX on ReleaseAsset {
  WindowsAssetType get windowsType {
    final lower = name.toLowerCase();

    // Check for explicit installer extensions
    if (lower.endsWith('.exe') ||
        lower.endsWith('.msi') ||
        lower.endsWith('.msix')) {
      return WindowsAssetType.installer;
    }

    // Check for zip files
    if (lower.endsWith('.zip')) {
      // If zip contains 'setup' or 'install', it's likely an installer bundle
      if (lower.contains('setup') || lower.contains('install')) {
        return WindowsAssetType.installer;
      }
      return WindowsAssetType.portable;
    }

    if (lower.endsWith('.rar') || lower.endsWith('.7z')) {
      return WindowsAssetType.archive;
    }
    return WindowsAssetType.unknown;
  }
}

extension ReleaseX on Release {
  bool get hasWindowsAsset =>
      assets.any((a) => a.windowsType != WindowsAssetType.unknown);

  List<ReleaseAsset> get windowsAssets =>
      assets.where((a) => a.windowsType != WindowsAssetType.unknown).toList();

  bool get hasAndroidAsset =>
      assets.any((a) => a.name.toLowerCase().endsWith('.apk'));

  List<ReleaseAsset> get androidAssets =>
      assets.where((a) => a.name.toLowerCase().endsWith('.apk')).toList();

  bool get hasLinuxAsset => assets.any(
    (a) =>
        a.name.toLowerCase().endsWith('.appimage') ||
        a.name.toLowerCase().endsWith('.deb') ||
        a.name.toLowerCase().endsWith('.rpm'),
  );

  List<ReleaseAsset> get linuxAssets => assets
      .where(
        (a) =>
            a.name.toLowerCase().endsWith('.appimage') ||
            a.name.toLowerCase().endsWith('.deb') ||
            a.name.toLowerCase().endsWith('.rpm'),
      )
      .toList();

  List<String> get supportedPlatforms {
    final platforms = <String>[];
    if (hasWindowsAsset) platforms.add('Windows');
    if (hasAndroidAsset) platforms.add('Android');
    if (hasLinuxAsset) platforms.add('Linux');
    return platforms;
  }
}
