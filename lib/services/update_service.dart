import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdate {
  final String version;
  final String downloadUrl;

  const AppUpdate({required this.version, required this.downloadUrl});
}

// Olha a última release do GitHub. Repo é público, então não precisa de token.
class UpdateService {
  static const _latestUrl = 'https://api.github.com/repos/LuGoAn/frequencia-app/releases/latest';

  static bool isNewer(String latest, String current) {
    List<int> parts(String v) => v
        .replaceAll(RegExp(r'^[vV]'), '')
        .split('+')
        .first
        .split('.')
        .map((p) => int.tryParse(p.trim()) ?? 0)
        .toList();

    final l = parts(latest);
    final c = parts(current);
    for (var i = 0; i < 3; i++) {
      final a = i < l.length ? l[i] : 0;
      final b = i < c.length ? c[i] : 0;
      if (a != b) return a > b;
    }
    return false;
  }

  static AppUpdate? parseRelease(Map<String, dynamic> data, String currentVersion) {
    final tag = data['tag_name'] as String? ?? '';
    if (tag.isEmpty || !isNewer(tag, currentVersion)) return null;

    String? apk;
    for (final asset in (data['assets'] as List<dynamic>? ?? [])) {
      final name = (asset['name'] as String? ?? '').toLowerCase();
      if (name.endsWith('.apk')) {
        apk = asset['browser_download_url'] as String?;
        break;
      }
    }
    final url = apk ?? data['html_url'] as String?;
    if (url == null) return null;

    return AppUpdate(version: tag.replaceAll(RegExp(r'^[vV]'), ''), downloadUrl: url);
  }

  // Sem internet ou com a API fora, só não avisa nada.
  Future<AppUpdate?> check() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
    try {
      final current = (await PackageInfo.fromPlatform()).version;
      final request = await client.getUrl(Uri.parse(_latestUrl));
      request.headers.set('User-Agent', 'frequencia-app/$current');
      request.headers.set('Accept', 'application/vnd.github+json');
      final response = await request.close();
      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      return parseRelease(jsonDecode(body) as Map<String, dynamic>, current);
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
