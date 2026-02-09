import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'release_fetcher.dart';

class DownloadService {
  DownloadService({required this.client});
  final http.Client client;

  Stream<double> downloadFile(String url, String fileName) async* {
    final response = await client.send(http.Request('GET', Uri.parse(url)));
    final total = response.contentLength ?? 0;
    var downloaded = 0;

    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    final sink = file.openWrite();

    await for (final chunk in response.stream) {
      sink.add(chunk);
      downloaded += chunk.length;
      if (total > 0) {
        yield downloaded / total;
      }
    }

    await sink.close();
  }

  Future<String> getDownloadPath(String fileName) async {
    final dir = await getTemporaryDirectory();
    return p.join(dir.path, fileName);
  }
}

final downloadServiceProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  return DownloadService(client: client);
});
