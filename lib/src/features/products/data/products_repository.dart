import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../domain/product.dart';
import 'installation_tracking_service.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final trackingService = ref.watch(installationTrackingServiceProvider);
  final packageInfo = await PackageInfo.fromPlatform();

  // Mock data for now
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay

  final rawProducts = [
    const Product(
      id: 'oxide-manager',
      name: 'Oxide Manager',
      description: 'The dashboard to manage all your Oxide apps.',
      iconUrl: 'assets/app_icon.png',
      channels: ['stable'],
      repoOwner: 'edhases',
      repoName: 'oxide_manager',
    ),
    const Product(
      id: 'oxide-player',
      name: 'Oxide Player',
      description: 'Modern media player for Oxide ecosystem.',
      iconUrl: 'assets/products/oxide_player.png',
      channels: ['stable', 'beta'],
      repoOwner: 'edhases',
      repoName: 'a_player',
    ),
    const Product(
      id: 'oxide-film',
      name: 'Oxide Film',
      description: 'Movie catalog and streaming application.',
      iconUrl: 'assets/products/oxide_film.png',
      channels: ['stable'],
      repoOwner: 'edhases',
      repoName: 'oxide_film',
    ),
  ];

  return rawProducts.map((p) {
    if (p.id == 'oxide-manager') {
      return p.copyWith(installedTag: packageInfo.version);
    }
    final tag = trackingService.getInstalledTag(p.id);
    return p.copyWith(installedTag: tag);
  }).toList();
});
