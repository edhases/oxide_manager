import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';
import '../domain/models/release.dart';

class ReleaseFetcher {
  ReleaseFetcher({required this.client});
  final http.Client client;

  Future<List<Release>> fetchReleases(String owner, String repo) async {
    final url = Uri.https('api.github.com', '/repos/$owner/$repo/releases');
    final response = await client.get(
      url,
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Release.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load releases: ${response.statusCode}');
    }
  }
}

final httpClientProvider = Provider((ref) => http.Client());

final releaseFetcherProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  return ReleaseFetcher(client: client);
});

final productReleasesProvider = FutureProvider.family<List<Release>, Product>((
  ref,
  product,
) async {
  final fetcher = ref.watch(releaseFetcherProvider);
  return fetcher.fetchReleases(product.repoOwner, product.repoName);
});
