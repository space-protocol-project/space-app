import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const appRepository = 'space-protocol-project/space-app';
const appReleaseAssets = {
  'Space-Setup-windows-x64.exe',
  'Space-macos-arm64.dmg',
  'Space-linux-x64.run',
};

class AppVersion implements Comparable<AppVersion> {
  AppVersion(this.core, this.preview);
  final List<int> core;
  final List<String> preview;

  static AppVersion? parse(String value) {
    if (value.length > 128) return null;
    final match = RegExp(
      r'^v?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-([0-9A-Za-z.-]+))?(?:\+([0-9A-Za-z.-]+))?$',
    ).firstMatch(value);
    if (match == null) return null;
    final numbers = [
      for (var i = 1; i <= 3; i++) int.tryParse(match.group(i)!),
    ];
    if (numbers.contains(null)) return null;
    final preview = match.group(4)?.split('.') ?? <String>[];
    final build = match.group(5)?.split('.') ?? <String>[];
    if (build.any((id) => id.isEmpty)) return null;
    if (preview.any((id) => id.isEmpty || RegExp(r'^0\d+$').hasMatch(id))) {
      return null;
    }
    return AppVersion(numbers.cast<int>(), preview);
  }

  @override
  int compareTo(AppVersion other) {
    for (var i = 0; i < 3; i++) {
      final result = core[i].compareTo(other.core[i]);
      if (result != 0) return result;
    }
    if (preview.isEmpty || other.preview.isEmpty) {
      return preview.isEmpty == other.preview.isEmpty
          ? 0
          : preview.isEmpty
          ? 1
          : -1;
    }
    for (var i = 0; i < preview.length && i < other.preview.length; i++) {
      final a = int.tryParse(preview[i]), b = int.tryParse(other.preview[i]);
      final result = a != null && b != null
          ? a.compareTo(b)
          : a != null
          ? -1
          : b != null
          ? 1
          : preview[i].compareTo(other.preview[i]);
      if (result != 0) return result;
    }
    return preview.length.compareTo(other.preview.length);
  }
}

class AppRelease {
  AppRelease(this.tag, this.url, this.notes, this.version);
  final String tag, notes;
  final Uri url;
  final AppVersion version;

  static AppRelease? fromJson(Map data) {
    final tag = data['tag_name'];
    if (data['draft'] != false || tag is! String || !tag.startsWith('v')) {
      return null;
    }
    final version = AppVersion.parse(tag);
    if (version == null) return null;
    final expected =
        'https://github.com/$appRepository/releases/tag/${Uri.encodeComponent(tag)}';
    if (data['html_url'] != expected) return null;
    final assets = data['assets'];
    if (assets is! List ||
        !assets
            .whereType<Map>()
            .map((asset) => asset['name'])
            .toSet()
            .containsAll(appReleaseAssets)) {
      return null;
    }
    final notes = data['body'] is String ? data['body'] as String : '';
    return AppRelease(
      tag,
      Uri.parse(expected),
      notes.length > 65536 ? notes.substring(0, 65536) : notes,
      version,
    );
  }
}

enum AppUpdateStatus { idle, checking, current, available, empty, failed }

class AppUpdates extends ChangeNotifier {
  AppUpdates({http.Client? client, Future<String> Function()? readVersion})
    : client = client ?? http.Client(),
      readVersion = readVersion ?? installedAppVersion;
  final http.Client client;
  final Future<String> Function() readVersion;
  String installed = '';
  AppRelease? release;
  AppUpdateStatus status = AppUpdateStatus.idle;
  bool _disposed = false;

  Future<void> initialize() async {
    try {
      final value = await readVersion();
      if (AppVersion.parse(value) == null) {
        throw const FormatException('Неверная версия приложения');
      }
      installed = value;
    } catch (_) {
      status = AppUpdateStatus.failed;
    }
    _notify();
  }

  Future<void> check() async {
    if (_disposed || status == AppUpdateStatus.checking) return;
    status = AppUpdateStatus.checking;
    release = null;
    _notify();
    try {
      if (installed.isEmpty) await initialize();
      final current = AppVersion.parse(installed);
      if (current == null) {
        throw const FormatException('Нет установленной версии');
      }
      final response = await client
          .get(
            Uri.parse(
              'https://api.github.com/repos/$appRepository/releases?per_page=100',
            ),
            headers: {
              'Accept': 'application/vnd.github+json',
              'X-GitHub-Api-Version': '2026-03-10',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200 ||
          response.bodyBytes.length > 2 * 1024 * 1024) {
        throw const FormatException('Ответ проверки обновлений недоступен');
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      final releases =
          data
              .whereType<Map>()
              .map(AppRelease.fromJson)
              .whereType<AppRelease>()
              .toList()
            ..sort((a, b) => b.version.compareTo(a.version));
      release = releases.firstOrNull;
      status = release == null
          ? AppUpdateStatus.empty
          : release!.version.compareTo(current) > 0
          ? AppUpdateStatus.available
          : AppUpdateStatus.current;
    } catch (_) {
      status = AppUpdateStatus.failed;
    }
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    client.close();
    super.dispose();
  }
}

Future<String> installedAppVersion() async {
  final source = await rootBundle.loadString('pubspec.yaml');
  final version = RegExp(
    r'^version:\s*([^\s#]+)',
    multiLine: true,
  ).firstMatch(source)?.group(1);
  if (version == null) throw const FormatException('Нет версии сборки');
  return version;
}
