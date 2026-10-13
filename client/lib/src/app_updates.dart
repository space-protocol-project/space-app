import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:path_provider/path_provider.dart';

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

const appPackages = {
  'windows-x64': 'Space-Setup-windows-x64.exe',
  'macos-arm64': 'Space-macos-arm64.dmg',
  'linux-x64': 'Space-linux-x64.run',
};

String installedAppPlatform() {
  if (Platform.isWindows && Abi.current() == Abi.windowsX64) {
    return 'windows-x64';
  }
  if (Platform.isMacOS && Abi.current() == Abi.macosArm64) return 'macos-arm64';
  if (Platform.isLinux && Abi.current() == Abi.linuxX64) return 'linux-x64';
  return '';
}

class AppPackage {
  AppPackage(this.name, this.url, this.size, this.digest);
  final String name, digest;
  final Uri url;
  final int size;

  static AppPackage? fromJson(Map asset, String tag) {
    final name = asset['name'], size = asset['size'], digest = asset['digest'];
    if (!appReleaseAssets.contains(name) ||
        size is! int ||
        size <= 0 ||
        size > 1024 * 1024 * 1024 ||
        digest is! String ||
        !RegExp(r'^sha256:[0-9a-f]{64}$').hasMatch(digest)) {
      return null;
    }
    final expected =
        'https://github.com/$appRepository/releases/download/${Uri.encodeComponent(tag)}/$name';
    if (asset['browser_download_url'] != expected) return null;
    return AppPackage(name as String, Uri.parse(expected), size, digest);
  }
}

class AppRelease {
  AppRelease(this.tag, this.url, this.notes, this.version, this.packages);
  final Map<String, AppPackage> packages;
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
      {
        for (final asset in assets.whereType<Map>())
          if (AppPackage.fromJson(asset, tag) case final AppPackage package)
            package.name: package,
      },
    );
  }
}

enum AppUpdateStatus { idle, checking, current, available, empty, failed }

class AppUpdates extends ChangeNotifier {
  AppUpdates({
    http.Client? client,
    Future<String> Function()? readVersion,
    String? platform,
    Future<Directory> Function()? downloadDirectory,
  }) : client = client ?? http.Client(),
       readVersion = readVersion ?? installedAppVersion,
       platform = platform ?? installedAppPlatform(),
       downloadDirectory = downloadDirectory ?? appUpdateDirectory;
  final Future<Directory> Function() downloadDirectory;
  bool downloading = false;
  int downloadedBytes = 0;
  bool downloadFailed = false;
  File? downloadedPackage;
  final String platform;
  AppPackage? get package => release?.packages[appPackages[platform]];
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
    if (_disposed || downloading || status == AppUpdateStatus.checking) return;
    downloadedPackage = null;
    downloadFailed = false;
    downloadedBytes = 0;
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

  Future<void> download() async {
    final target = package;
    if (_disposed ||
        downloading ||
        status != AppUpdateStatus.available ||
        target == null) {
      return;
    }
    downloading = true;
    downloadFailed = false;
    downloadedPackage = null;
    _notify();
    File? partial;
    IOSink? sink;
    try {
      final directory = await downloadDirectory();
      await directory.create(recursive: true);
      final hash = target.digest.substring(7);
      final output = File('${directory.path}/$hash-${target.name}');
      partial = File('${output.path}.part');
      if (await output.exists()) {
        if (await validPackage(output, target)) {
          downloadedBytes = target.size;
          downloadedPackage = output;
          return;
        }
        await output.delete();
      }
      var offset = await partial.exists() ? await partial.length() : 0;
      if (offset > target.size) {
        await partial.delete();
        offset = 0;
      }
      downloadedBytes = offset;
      if (offset < target.size) {
        final response = await packageResponse(target, offset);
        if (response.statusCode == 200) {
          offset = 0;
        } else if (response.statusCode != 206 ||
            response.headers['content-range'] !=
                'bytes $offset-${target.size - 1}/${target.size}') {
          throw const FormatException('Неверный диапазон загрузки');
        }
        if (response.contentLength != null &&
            response.contentLength != target.size - offset) {
          throw const FormatException('Неверный размер пакета');
        }
        downloadedBytes = offset;
        final writer = partial.openWrite(
          mode: offset == 0 ? FileMode.write : FileMode.append,
        );
        sink = writer;
        await for (final chunk in response.stream.timeout(
          const Duration(seconds: 30),
        )) {
          if (_disposed) throw const FormatException('Загрузка остановлена');
          if (downloadedBytes + chunk.length > target.size) {
            await writer.close();
            sink = null;
            await partial.delete();
            throw const FormatException('Пакет превышает ожидаемый размер');
          }
          writer.add(chunk);
          downloadedBytes += chunk.length;
          _notify();
        }
        await writer.close();
        sink = null;
      }
      if (await partial.length() != target.size) {
        throw const FormatException('Неполная загрузка');
      }
      if (!await validPackage(partial, target)) {
        await partial.delete();
        downloadedBytes = 0;
        throw const FormatException('Контрольная сумма не совпадает');
      }
      if (_disposed) return;
      downloadedPackage = await partial.rename(output.path);
    } catch (_) {
      downloadFailed = true;
    } finally {
      try {
        await sink?.close();
      } catch (_) {
        downloadFailed = true;
      }
      downloading = false;
      _notify();
    }
  }

  Future<http.StreamedResponse> packageResponse(
    AppPackage target,
    int offset,
  ) async {
    var url = target.url;
    for (var i = 0; i < 6; i++) {
      if (url.scheme != 'https' ||
          url.userInfo.isNotEmpty ||
          url.port != 443 ||
          !{
            'github.com',
            'release-assets.githubusercontent.com',
            'objects.githubusercontent.com',
          }.contains(url.host)) {
        throw const FormatException('Недопустимый адрес загрузки');
      }
      final request = http.Request('GET', url)..followRedirects = false;
      request.headers['Accept-Encoding'] = 'identity';
      if (offset > 0) request.headers['Range'] = 'bytes=$offset-';
      final response = await client
          .send(request)
          .timeout(const Duration(seconds: 30));
      if (![301, 302, 303, 307, 308].contains(response.statusCode)) {
        return response;
      }
      final location = response.headers['location'];
      await response.stream.drain<void>().timeout(const Duration(seconds: 30));
      if (location == null) break;
      url = url.resolve(location);
    }
    throw const FormatException('Слишком много перенаправлений');
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

Future<Directory> appUpdateDirectory() async =>
    Directory('${(await getApplicationSupportDirectory()).path}/updates');

Future<bool> validPackage(File file, AppPackage package) async {
  if (await file.length() != package.size) return false;
  final digest = await crypto.sha256.bind(file.openRead()).first;
  return 'sha256:$digest' == package.digest;
}
