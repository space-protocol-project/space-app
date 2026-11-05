import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart' as paths;

import 'local_catalog_types.dart';
import 'local_lifecycle_record.dart';

class DesktopCatalogPicker implements LocalCatalogPicker {
  DesktopCatalogPicker(this.executable, {Future<String?> Function()? choose})
    : _choose = choose ?? getDirectoryPath;
  final String executable;
  final Future<String?> Function() _choose;
  final _paths = <String, String>{};
  bool _choosing = false;
  final _processes = <Process>{};

  Future<void> get stopped async {
    await Future.wait(_processes.map((child) => child.exitCode));
  }

  // Только доверенное окно подтверждения получает путь выбранного корня.
  String? selectedPath(String root) => _paths[root];

  @override
  Future<LocalCatalogRoot> select(
    String instance,
    String package,
    void Function() guard,
  ) async {
    if (_choosing || _processes.length >= 4) throw StateError('ResourceLimit');
    if (!paths.isAbsolute(executable)) throw StateError('Unavailable');
    _choosing = true;
    _DesktopRoot? root;
    try {
      guard();
      final path = await _choose();
      guard();
      if (path == null) throw StateError('Cancelled');
      if (!paths.isAbsolute(path)) throw StateError('PermissionDenied');
      final process = await Process.start(executable, [path]);
      _processes.add(process);
      unawaited(
        process.exitCode.then((_) {
          _processes.remove(process);
        }),
      );
      root = _DesktopRoot(process, _paths.remove);
      await root.ready();
      guard();
      _paths[root.id] = path;
      return root;
    } catch (error) {
      root?.close();
      if (error is StateError) rethrow;
      throw StateError('Unavailable');
    } finally {
      _choosing = false;
    }
  }
}

class _DesktopRoot extends LocalCatalogRoot {
  _DesktopRoot(this.process, this.release)
    : replies = StreamIterator(
        process.stdout.transform(utf8.decoder).transform(const LineSplitter()),
      ) {
    unawaited(process.stderr.drain<void>());
  }
  final Process process;
  final void Function(String) release;
  final StreamIterator<String> replies;
  List<CatalogEntry>? snapshot;
  final issued = <String>{};
  String? next;
  int index = 0;
  bool busy = false;
  bool closed = false;

  Future<Object?> _reply() async {
    if (!await replies.moveNext().timeout(const Duration(seconds: 10))) {
      throw StateError('Unavailable');
    }
    final value = jsonDecode(replies.current);
    if (value case {'error': 'ResourceLimit'}) {
      throw StateError('ResourceLimit');
    }
    if (value is Map && value.containsKey('error')) {
      throw StateError('PermissionDenied');
    }
    return value;
  }

  Future<void> ready() async {
    if (await _reply() != true) throw StateError('Unavailable');
  }

  Future<Object?> _request(Map<String, Object?> request) async {
    if (closed) throw StateError('PermissionDenied');
    process.stdin.writeln(jsonEncode(request));
    await process.stdin.flush();
    return _reply();
  }

  Future<T> _serial<T>(Future<T> Function() work) async {
    if (busy) throw StateError('Busy');
    if (closed) throw StateError('PermissionDenied');
    busy = true;
    try {
      return await work();
    } on StateError {
      rethrow;
    } catch (_) {
      close();
      throw StateError('Unavailable');
    } finally {
      busy = false;
    }
  }

  Future<List<CatalogEntry>> _entries() async {
    final data = await _request({'op': 'list'}) as List;
    return [
      for (final item in data)
        (name: item['name'] as String, handle: item['handle'] as String),
    ];
  }

  @override
  Future<CatalogPage> list(int limit, String? cursor) => _serial(() async {
    if (limit < 1 || limit > 128) throw StateError('ResourceLimit');
    if (cursor != next || (snapshot != null && cursor == null)) {
      throw StateError('StaleBinding');
    }
    final all = snapshot ?? await _entries();
    if (closed) throw StateError('PermissionDenied');
    snapshot = all;
    final page = List<CatalogEntry>.unmodifiable(all.skip(index).take(limit));
    issued.addAll(page.map((item) => item.handle));
    index += page.length;
    next = index < all.length ? localGeneration() : null;
    return (entries: page, next: next);
  });
  @override
  Future<CatalogChunk> read(String handle, int offset, int limit) =>
      _serial(() async {
        lifecycleToken(handle);
        if (!issued.contains(handle)) throw StateError('StaleBinding');
        if (limit < 1 ||
            limit > 65536 ||
            offset < 0 ||
            offset > 9007199254740991 - limit) {
          throw StateError('ResourceLimit');
        }
        final result = await _request({
          'op': 'read',
          'handle': handle,
          'offset': offset,
          'limit': limit,
        }) as Map;
        return (
          bytes: base64Decode(result['bytes'] as String),
          eof: result['eof'] as bool,
        );
      });
  @override
  void close() {
    if (closed) return;
    closed = true;
    snapshot = null;
    issued.clear();
    release(id);
    process.kill(ProcessSignal.sigkill);
    unawaited(replies.cancel());
    unawaited(_closeInput());
  }

  Future<void> _closeInput() async {
    try {
      await process.exitCode;
      await process.stdin.close();
    } on IOException {
      // Канал мог закрыться при завершении процесса во время записи запроса.
    }
  }
}
