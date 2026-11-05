import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'bundled_catalog.dart';
import 'registry_validation.dart';
import 'strict_json.dart';

abstract interface class ClientWasmWorker {
  Future<Uint8List> invoke(List<int> module, List<int> input);
  void cancel();
  Future<void> close();
}

class ClientWasmProcess implements ClientWasmWorker {
  ClientWasmProcess(this.executable, {this.verify});
  final String executable;
  final Future<void> Function()? verify;
  Process? _process;
  bool _cancelled = false;
  Future<void>? _running;

  static Future<ClientWasmProcess> bundled() async {
    final binary = await BundledCatalog.resolve(name: 'space-client-wasm');
    return ClientWasmProcess(binary.executable, verify: binary.verify);
  }

  @override
  Future<Uint8List> invoke(List<int> module, List<int> input) async {
    if (_cancelled || _running != null) throw StateError('Cancelled');
    if (module.length > 65536 || input.length > 16384) {
      throw StateError('ResourceLimit');
    }
    final operation = _invoke(module, input);
    _running = operation.then<void>((_) {}, onError: (Object _) {});
    try {
      return await operation;
    } finally {
      _running = null;
    }
  }

  Future<Uint8List> _invoke(List<int> module, List<int> input) async {
    await verify?.call();
    if (_cancelled) throw StateError('Cancelled');
    final process = await Process.start(executable, ['--serve']);
    _process = process;
    final errors = process.stderr.drain<void>();
    final lines = StreamIterator(
      _bounded(process.stdout)
          .transform(utf8.decoder)
          .transform(const LineSplitter()),
    );
    try {
      if (_cancelled) throw StateError('Cancelled');
      final ready = await _line(lines);
      if (ready != '{"ready":true}') throw StateError('IsolationUnavailable');
      process.stdin.writeln(
        jsonEncode({
          'wasm': base64Encode(module),
          'input': base64Encode(input),
        }),
      );
      await process.stdin.flush();
      final result = registryObject(jsonDecode(await _line(lines)));
      registryKeys(result, ['result']);
      final bytes = base64Decode(result['result'] as String);
      extensionJson(bytes);
      if (await process.exitCode.timeout(const Duration(seconds: 3)) != 0 ||
          _cancelled) {
        throw StateError('WorkerFailed');
      }
      return bytes;
    } finally {
      process.kill();
      await process.exitCode;
      await process.stdin.close().catchError((Object _) {});
      await lines.cancel();
      await errors;
      _process = null;
    }
  }

  Future<String> _line(StreamIterator<String> lines) async {
    if (!await lines.moveNext().timeout(const Duration(seconds: 3))) {
      throw StateError('IsolationUnavailable');
    }
    return lines.current;
  }

  Stream<List<int>> _bounded(Stream<List<int>> input) async* {
    var size = 0;
    await for (final chunk in input) {
      size += chunk.length;
      if (size > 32768) throw StateError('ResourceLimit');
      yield chunk;
    }
  }

  @override
  void cancel() {
    _cancelled = true;
    unawaited(_process?.stdin.close().catchError((Object _) {}));
  }

  @override
  Future<void> close() async {
    cancel();
    await _running;
  }
}
