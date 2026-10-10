import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'home_runtime.dart';

class HomeServerState {
  HomeServerState(
    this.localOrigin,
    this.publicOrigin,
    this.setupCode,
    this.tlsFingerprint,
  );
  final String localOrigin, publicOrigin, setupCode, tlsFingerprint;
  String get link =>
      Uri.parse(publicOrigin)
          .replace(fragment: 'tls=$tlsFingerprint')
          .toString();
}

Future<Directory> homeDirectory() async =>
    Directory('${(await getApplicationSupportDirectory()).path}/home-server');

class HomeController extends ChangeNotifier {
  HomeController({
    this.directory = homeDirectory,
    this.release = bundledHomeRelease,
    this.download = downloadHomeRelease,
  });
  final Future<Directory> Function() directory;
  final Future<HomeRelease> Function() release;
  final Future<void> Function(HomeRelease, File, void Function(double))
  download;
  Directory? _root;
  Process? _process;
  RandomAccessFile? _lock;
  bool busy = false, running = false, _disposed = false;
  String ip = '', error = '', phase = '';
  double progress = 0;
  HomeServerState? state;
  void reportError(String message) {
    error = message;
    _update();
  }

  String _diagnostic = '';

  void _update() {
    if (!_disposed) notifyListeners();
  }

  Future<Directory> _directory() async {
    final root = _root ??= await directory();
    await root.create(recursive: true);
    return root;
  }

  Future<void> load() async {
    try {
      final root = await _directory();
      final config = File('${root.path}/config.json');
      if (await config.exists()) {
        final data =
            jsonDecode(await config.readAsString()) as Map<String, dynamic>;
        ip = data['ip'] as String;
      }
    } catch (_) {
      /* Первый запуск или недоступное хранилище проверяются при запуске. */
    }
    _update();
  }

  Future<String> detectIP() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 5);
    try {
      final request = await client
          .getUrl(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 10));
      request.followRedirects = false;
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode != 200) {
        throw const FormatException('Не удалось определить IP');
      }
      final bytes = <int>[];
      await for (final chunk in response.timeout(const Duration(seconds: 10))) {
        bytes.addAll(chunk);
        if (bytes.length > 1024) {
          throw const FormatException('Некорректный ответ определения IP');
        }
      }
      return (jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>)['ip']
          as String;
    } finally {
      client.close(force: true);
    }
  }

  Future<Directory> _install(Directory root) async {
    final descriptor = await release();
    final target = Directory(
      '${root.path}/runtimes/${descriptor.version}-${descriptor.platform}',
    );
    final marker = File('${target.path}/installed.json');
    if (await marker.exists()) {
      final saved =
          jsonDecode(await marker.readAsString()) as Map<String, dynamic>;
      if (saved['sha256'] != descriptor.sha256) {
        throw const FormatException(
          'Сохранённый выпуск не совпадает с приложением',
        );
      }
      return target;
    }
    phase = 'Скачиваем сервер и PostgreSQL';
    _update();
    final staging = await Directory('${root.path}/runtimes')
        .create(recursive: true);
    final temporary = await staging.createTemp('download-');
    try {
      final archive = File('${temporary.path}/runtime.zip');
      await download(descriptor, archive, (value) {
        progress = value;
        _update();
      });
      phase = 'Проверяем и устанавливаем выпуск';
      _update();
      final unpacked = await Directory('${temporary.path}/unpacked').create();
      await extractHomeRelease(archive, unpacked, descriptor.sha256);
      final executable = Platform.isWindows
          ? 'space-server.exe'
          : 'space-server';
      if (!await File('${unpacked.path}/$executable').exists()) {
        throw const FormatException('В выпуске нет сервера');
      }
      await File('${unpacked.path}/installed.json')
          .writeAsString(jsonEncode({'sha256': descriptor.sha256}));
      await unpacked.rename(target.path);
      return target;
    } finally {
      await temporary.delete(recursive: true);
    }
  }

  Future<HomeServerState?> start(String address) async {
    if (busy || running || _disposed) return state;
    busy = true;
    error = '';
    progress = 0;
    state = null;
    _diagnostic = '';
    _update();
    try {
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      final config = File('${root.path}/config.json');
      // Повторный запуск читает прежнюю конфигурацию, а не создаёт новый сервер.
      if (await config.exists()) {
        ip =
            (jsonDecode(await config.readAsString())
                    as Map<String, dynamic>)['ip']
                as String;
      } else {
        ip = address.trim();
        if (!isPublicHomeIPv4(ip)) {
          throw const FormatException('Нужен статический публичный IPv4');
        }
        final pending = File('${config.path}.tmp');
        await pending.writeAsString(
          jsonEncode({'ip': ip, 'port': 8443}),
          flush: true,
        );
        await pending.rename(config.path);
      }
      final runtime = await _install(root);
      if (_disposed) {
        throw const FormatException('Запуск отменён при закрытии приложения');
      }
      phase = 'Запускаем сохранённый сервер';
      _update();
      final data = await Directory('${root.path}/data').create(recursive: true);
      final ready = File('${data.path}/state.json');
      if (await ready.exists()) await ready.delete();
      final httpPort = await _freePort();
      final grpcPort = await _freePort();
      final executable =
          '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}';
      final process = await Process.start(executable, [
        '-home-data',
        data.path,
        '-home-runtime',
        runtime.path,
        '-public-ip',
        ip,
        '-http',
        '127.0.0.1:$httpPort',
        '-grpc',
        '127.0.0.1:$grpcPort',
        '-https',
        '0.0.0.0:8443',
        '-managed',
      ], mode: ProcessStartMode.normal);
      _process = process;
      void record(List<int> chunk) {
        _diagnostic = '$_diagnostic${utf8.decode(chunk, allowMalformed: true)}';
        if (_diagnostic.length > 8192) {
          _diagnostic = _diagnostic.substring(_diagnostic.length - 8192);
        }
      }

      process.stdout.listen(record);
      process.stderr.listen(record);
      unawaited(
        process.exitCode.then((code) async {
          if (_process != process) return;
          _process = null;
          running = false;
          state = null;
          if (!busy && code != 0) {
            error = 'Сервер завершился с ошибкой. $_diagnostic';
          }
          await _unlock();
          _update();
        }),
      );
      final deadline = DateTime.now().add(const Duration(seconds: 60));
      while (!await ready.exists()) {
        if (_disposed || _process != process) {
          throw FormatException('Сервер не запущен. $_diagnostic');
        }
        if (DateTime.now().isAfter(deadline)) {
          throw const FormatException('Сервер не успел запуститься');
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      final result =
          jsonDecode(await ready.readAsString()) as Map<String, dynamic>;
      final pem = await File('${data.path}/server.crt').readAsString();
      final der = base64Decode(
        pem.replaceAll(RegExp(r'-----[^-]+-----|\s'), '').trim(),
      );
      state = HomeServerState(
        result['local_origin'] as String,
        result['public_origin'] as String,
        result['setup_code'] as String,
        crypto.sha256.convert(der).toString(),
      );
      running = true;
      phase = 'Сервер работает на этом компьютере';
      return state;
    } catch (e) {
      error = e.toString().replaceFirst('FormatException: ', '');
      try {
        await _stop();
      } catch (_) {
        error += ' Сервер не подтвердил остановку.';
      }
      return null;
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> _unlock() async {
    final lock = _lock;
    _lock = null;
    if (lock != null) {
      await lock.close();
    }
  }

  Future<void> _stop() async {
    final process = _process;
    if (process != null) {
      // EOF запускает штатное завершение Go, затем остановку собственной PostgreSQL.
      await process.stdin.close();
      await process.exitCode.timeout(const Duration(seconds: 30));
      _process = null;
    }
    running = false;
    state = null;
    phase = 'Сервер отключён, данные сохранены';
    await _unlock();
  }

  Future<void> stop() async {
    if (busy) return;
    busy = true;
    error = '';
    _update();
    try {
      await _stop();
    } catch (_) {
      error =
          'Сервер не подтвердил остановку. Повторный запуск пока заблокирован.';
    } finally {
      busy = false;
      _update();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_process?.stdin.close());
    super.dispose();
  }
}

bool isPublicHomeIPv4(String value) {
  final address = InternetAddress.tryParse(value);
  if (address == null || address.type != InternetAddressType.IPv4) return false;
  final bytes = address.rawAddress;
  return bytes[0] > 0 &&
      bytes[0] < 224 &&
      bytes[0] != 10 &&
      bytes[0] != 127 &&
      !(bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) &&
      !(bytes[0] == 192 && bytes[1] == 168) &&
      !(bytes[0] == 169 && bytes[1] == 254) &&
      !(bytes[0] == 100 && bytes[1] >= 64 && bytes[1] <= 127);
}

Future<int> _freePort() async {
  final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = socket.port;
  await socket.close();
  return port;
}
