import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../domain/product.dart';
import '../domain/models/release.dart';

class ReleaseFetcher {
  ReleaseFetcher({required this.client, this.token});
  final http.Client client;
  final String? token;

  Future<List<Release>> fetchReleases(String owner, String repo) async {
    final url = Uri.https('api.github.com', '/repos/$owner/$repo/releases');

    final Map<String, String> headers = {
      'Accept': 'application/vnd.github.v3+json',
      'User-Agent': 'OxideManager',
    };

    if (token != null && token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Release.fromJson(json)).toList();
    } else if (response.statusCode == 403) {
      throw Exception(
        'GitHub API rate limit exceeded. Please wait a few minutes or provide a GITHUB_TOKEN in your .env file.',
      );
    } else {
      throw Exception('Failed to load releases: ${response.statusCode}');
    }
  }
}

final httpClientProvider = Provider((ref) => http.Client());

final githubTokenProvider = Provider<String?>((ref) {
  try {
    if (dotenv.isInitialized) {
      return dotenv.env['GITHUB_TOKEN'];
    }
    return null;
  } catch (_) {
    return null;
  }
});

final releaseFetcherProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  final token = ref.watch(githubTokenProvider);
  return ReleaseFetcher(client: client, token: token);
});

final productReleasesProvider = FutureProvider.family<List<Release>, Product>((
  ref,
  product,
) async {
  final fetcher = ref.watch(releaseFetcherProvider);
  return fetcher.fetchReleases(product.repoOwner, product.repoName);
});
