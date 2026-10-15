// Исторический runtime запускается напрямую: новый клиент намеренно требует новый протокол.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_runtime.dart';

class HistoricalHomeRuntime {
  HistoricalHomeRuntime(this.root, this.release);
  final Directory root;
  final HomeRelease release;
  Process? process;
  String diagnostics = '';

  Future<void> prepare() async {
    final installation = HomeInstallation(root);
    await installation.prepare(
      release,
      download: downloadHomeRelease,
      progress: (_) {},
      extracting: () {},
    );
    await installation.selectInitial(release);
    await File('${root.path}/config.json').writeAsString(
      jsonEncode({'ip': '203.0.113.10', 'port': 8443}),
      flush: true,
    );
  }

  Future<HomeServerState> start() async {
    final runtime = HomeInstallation(root).runtime(release);
    final data = await Directory('${root.path}/data').create(recursive: true);
    final ready = File('${data.path}/state.json');
    if (await ready.exists()) await ready.delete();
    final http = await freePort();
    final grpc = await freePort();
    final executable = Platform.isWindows ? 'space-server.exe' : 'space-server';
    final child = await Process.start('${runtime.path}/$executable', [
      '-home-data',
      data.path,
      '-home-runtime',
      runtime.path,
      '-public-ip',
      '203.0.113.10',
      '-http',
      '127.0.0.1:$http',
      '-grpc',
      '127.0.0.1:$grpc',
      '-https',
      '127.0.0.1:8443',
      '-managed',
    ]);
    process = child;
    diagnostics = '';
    child.stdout.listen(record);
    child.stderr.listen(record);
    int? exit;
    unawaited(child.exitCode.then((code) => exit = code));
    final deadline = DateTime.now().add(const Duration(seconds: 60));
    while (!await ready.exists()) {
      if (exit != null || DateTime.now().isAfter(deadline)) {
        throw StateError('Исторический runtime не запущен: $diagnostics');
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    final state = jsonDecode(await ready.readAsString()) as Map;
    final pem = await File('${data.path}/server.crt').readAsString();
    final der = base64Decode(pem.replaceAll(RegExp(r'-----[^-]+-----|\s'), ''));
    return HomeServerState(
      state['local_origin'] as String,
      state['public_origin'] as String,
      state['setup_code'] as String,
      sha256.convert(der).toString(),
    );
  }

  void record(List<int> bytes) {
    diagnostics += utf8.decode(bytes, allowMalformed: true);
    if (diagnostics.length > 8192) {
      diagnostics = diagnostics.substring(diagnostics.length - 8192);
    }
  }

  Future<void> stop() async {
    final child = process;
    if (child == null) return;
    process = null;
    await child.stdin.close();
    final code = await child.exitCode.timeout(const Duration(seconds: 30));
    if (code != 0) throw StateError('Исторический runtime: $code $diagnostics');
  }

  static Future<int> freePort() async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = socket.port;
    await socket.close();
    return port;
  }
}
