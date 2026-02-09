import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';
import 'installation_tracking_service.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final trackingService = ref.watch(installationTrackingServiceProvider);

  // Mock data for now
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

  final rawProducts = [
    const Product(
      id: 'oxide-player',
      name: 'Oxide Player',
      description: 'Modern media player for Oxide ecosystem.',
      iconUrl: 'https://via.placeholder.com/150',
      channels: ['stable', 'beta'],
      repoOwner: 'edhases',
      repoName: 'a_player',
    ),
    const Product(
      id: 'oxide-film',
      name: 'Oxide Film',
      description: 'Movie catalog and streaming application.',
      iconUrl: 'https://via.placeholder.com/150',
      channels: ['stable'],
      repoOwner: 'edhases',
      repoName: 'oxide_film',
    ),
  ];

  return rawProducts.map((p) {
    final tag = trackingService.getInstalledTag(p.id);
    return p.copyWith(installedTag: tag);
  }).toList();
});
