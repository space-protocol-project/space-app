import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'home_runtime.dart';
import 'home_installation.dart';
import 'home_update_journal.dart';
import 'local_failure.dart';

enum HomePhase {
  idle,
  detectingIP,
  downloading,
  installing,
  starting,
  running,
  stopping,
  stopped,
}

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
  String ip = '', error = '';
  LocalFailureCode? failureCode;
  HomePhase phase = HomePhase.idle;
  double progress = 0;
  double stopProgress = 0;
  final _operationClock = Stopwatch();
  final _downloadClock = Stopwatch();
  Timer? _progressTimer;
  Duration get elapsed => _operationClock.elapsed;
  int? get downloadSecondsRemaining {
    if (phase != HomePhase.downloading ||
        progress <= 0 ||
        progress >= 1 ||
        _downloadClock.elapsedMilliseconds < 1000) {
      return null;
    }
    return (_downloadClock.elapsedMilliseconds /
            1000 *
            (1 - progress) /
            progress)
        .ceil();
  }

  double get operationProgress => switch (phase) {
    HomePhase.idle => 0.01,
    HomePhase.detectingIP => 0.02,
    HomePhase.downloading => 0.05 + 0.55 * progress.clamp(0, 1),
    HomePhase.installing => 0.65,
    HomePhase.starting => 0.80,
    HomePhase.stopping => stopProgress,
    HomePhase.running || HomePhase.stopped => 1,
  };
  void _beginProgress() {
    _operationClock.reset();
    _operationClock.start();
    _downloadClock.reset();
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _update(),
    );
  }

  void _endProgress() {
    _downloadClock.stop();
    _operationClock.stop();
    _progressTimer?.cancel();
  }

  HomeServerState? state;
  void reportError(String message) {
    error = message;
    failureCode = LocalFailureCode.homeStartFailed;
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
    final offered = await release();
    final installation = HomeInstallation(root);
    final active = await installation.active(offered);
    if (active != null) return installation.runtime(active);
    final descriptor = offered;
    final target = installation.runtime(descriptor);
    phase = HomePhase.downloading;
    _downloadClock.start();
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
      _downloadClock.stop();
      phase = HomePhase.installing;
      _update();
      final unpacked = await Directory('${temporary.path}/unpacked').create();
      await extractHomeRelease(archive, unpacked, descriptor.sha256);
      final executable = Platform.isWindows
          ? 'space-server.exe'
          : 'space-server';
      if (!await File('${unpacked.path}/$executable').exists()) {
        throw const FormatException('В выпуске нет сервера');
      }
      await File('${unpacked.path}/installed.json').writeAsString(
        jsonEncode({
          'sha256': descriptor.sha256,
          'release': descriptor.toJson(),
        }),
        flush: true,
      );
      await unpacked.rename(target.path);
      await installation.selectInitial(descriptor);
      return target;
    } finally {
      await temporary.delete(recursive: true);
    }
  }

  Future<HomeServerState?> start(String address) async {
    if (busy || running || _disposed) return state;
    busy = true;
    _beginProgress();
    error = '';
    failureCode = null;
    progress = 0;
    phase = HomePhase.idle;
    state = null;
    _diagnostic = '';
    _update();
    try {
      final root = await _directory();
      _lock = await File('${root.path}/process.lock')
          .open(mode: FileMode.append);
      await _lock!.lock(FileLock.exclusive);
      await HomeUpdateJournal(root).requireSettled();
      final config = File('${root.path}/config.json');
      // Повторный запуск читает прежнюю конфигурацию, а не создаёт новый сервер.
      if (await config.exists()) {
        ip =
            (jsonDecode(await config.readAsString())
                    as Map<String, dynamic>)['ip']
                as String;
      } else {
        var candidate = address.trim();
        if (candidate.isEmpty) {
          phase = HomePhase.detectingIP;
          _update();
          candidate = await detectIP();
        }
        if (!isPublicHomeIPv4(candidate)) {
          throw const FormatException('Нужен статический публичный IPv4');
        }
        final pending = File('${config.path}.tmp');
        await pending.writeAsString(
          jsonEncode({'ip': candidate, 'port': 8443}),
          flush: true,
        );
        await pending.rename(config.path);
        ip = candidate;
      }
      final runtime = await _install(root);
      if (_disposed) {
        throw const FormatException('Запуск отменён при закрытии приложения');
      }
      phase = HomePhase.starting;
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
            failureCode = LocalFailureCode.homeStartFailed;
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
      phase = HomePhase.running;
      return state;
    } catch (e) {
      failureCode = e is LocalFailure
          ? e.code
          : LocalFailureCode.homeStartFailed;
      error = e.toString().replaceFirst('FormatException: ', '');
      try {
        await _stop();
      } catch (_) {
        failureCode = LocalFailureCode.homeStopFailed;
        error += ' Сервер не подтвердил остановку.';
      }
      return null;
    } finally {
      busy = false;
      _endProgress();
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
    phase = HomePhase.stopping;
    stopProgress = .1;
    _update();
    final process = _process;
    if (process != null) {
      // EOF запускает штатное завершение Go, затем остановку собственной PostgreSQL.
      await process.stdin.close();
      stopProgress = .35;
      _update();
      final code = await process.exitCode.timeout(const Duration(seconds: 30));
      if (code != 0) {
        throw StateError('Ошибка остановки домашнего сервера: $_diagnostic');
      }
      _process = null;
      stopProgress = .95;
      _update();
    }
    running = false;
    state = null;
    phase = HomePhase.stopped;
    await _unlock();
  }

  Future<void> stop() async {
    if (busy) return;
    busy = true;
    phase = HomePhase.stopping;
    stopProgress = 0;
    _beginProgress();
    error = '';
    failureCode = null;
    _update();
    try {
      await _stop();
    } catch (_) {
      failureCode = LocalFailureCode.homeStopFailed;
      error = 'Сервер не подтвердил завершение всех процессов. Проверьте состояние перед повторным запуском.';
    } finally {
      busy = false;
      _endProgress();
      _update();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _endProgress();
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
