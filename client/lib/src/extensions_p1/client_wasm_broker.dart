import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'client_wasm_process.dart';
import 'installed_packages.dart';
import 'local_lifecycle_host.dart';
import 'local_sessions.dart';
import 'registry_validation.dart';
import 'strict_json.dart';

// Один посредник принадлежит владельцу всех установок приложения.
class ClientWasmBroker {
  ClientWasmBroker({Future<ClientWasmWorker> Function()? worker})
    : worker = worker ?? ClientWasmProcess.bundled;
  final Future<ClientWasmWorker> Function() worker;
  bool _busy = false, _closed = false;
  ClientWasmWorker? _active;
  Future<void>? _draining;

  Future<Object?> invoke(
    InstalledPackages packages,
    LocalLifecycleHost host,
    LocalExtensionSession session,
    String instance,
    String root,
  ) async {
    if (_closed || _busy) throw StateError('Unavailable');
    // Разрешение проверяется до чтения пакета и создания процесса.
    final lease = host.beginRead(session, instance, root);
    _busy = true;
    final done = Completer<void>();
    _draining = done.future;
    var expired = false;
    final deadline = Timer(const Duration(seconds: 10), () {
      expired = true;
      _active?.cancel();
    });
    void guard() {
      lease.deliver(null);
      if (_closed || expired) throw StateError('Cancelled');
    }

    try {
      final entry = host.snapshot(session).entries[instance]!;
      final module = await packages.clientModule(entry['package']! as String);
      guard();
      final process = _active = await worker();
      lease.onCancel = process.cancel;
      guard();
      return await _steps(
        process,
        module,
        host,
        session,
        instance,
        root,
        lease,
        guard,
      );
    } finally {
      deadline.cancel();
      try {
        await _active?.close();
      } finally {
        _active = null;
        lease.close();
        _busy = false;
        done.complete();
      }
    }
  }

  Future<Object?> _steps(
    ClientWasmWorker process,
    Uint8List module,
    LocalLifecycleHost host,
    LocalExtensionSession session,
    String instance,
    String root,
    LocalReadLease lease,
    void Function() guard,
  ) async {
    Object? input = {'event': 'start'};
    for (var step = 0; step < 8; step++) {
      guard();
      final bytes = utf8.encode(jsonEncode(input));
      extensionJson(bytes);
      final reply = registryObject(
        extensionJson(lease.deliver(await process.invoke(module, bytes))),
      );
      guard();
      if (reply['op'] == 'done') {
        registryKeys(reply, ['op', 'value']);
        return lease.deliver(reply['value']);
      }
      input = await _catalog(reply, host, session, instance, root);
      guard();
    }
    throw StateError('ResourceLimit');
  }

  Future<Object?> _catalog(
    Map<String, Object?> request,
    LocalLifecycleHost host,
    LocalExtensionSession session,
    String instance,
    String root,
  ) => switch (request['op']) {
    'list' => _list(request, host, session, instance, root),
    'read' => _read(request, host, session, instance, root),
    _ => throw StateError('ClientAbi'),
  };

  Future<Object?> _list(
    Map<String, Object?> request,
    LocalLifecycleHost host,
    LocalExtensionSession session,
    String instance,
    String root,
  ) async {
    registryKeys(request, ['op', 'limit', 'cursor', 'state']);
    final limit = _limit(request['limit'], 32);
    final cursor = request['cursor'] as String?;
    if (cursor != null && cursor.length > 256) {
      throw StateError('ResourceLimit');
    }
    Object? result;
    await host.listCatalog(
      session,
      instance,
      root,
      (page) {
        result = {
          'event': 'list',
          'state': request['state'],
          'entries': [
            for (final e in page.entries) {'name': e.name, 'handle': e.handle},
          ],
          'next': page.next,
        };
      },
      limit: limit,
      cursor: cursor,
    );
    return result;
  }

  Future<Object?> _read(
    Map<String, Object?> request,
    LocalLifecycleHost host,
    LocalExtensionSession session,
    String instance,
    String root,
  ) async {
    registryKeys(request, ['op', 'handle', 'offset', 'limit', 'state']);
    final handle = request['handle'] as String;
    final offset = request['offset'] as int;
    final limit = _limit(request['limit'], 4096);
    if (handle.length > 256 || offset < 0 || offset > 0x7fffffff) {
      throw StateError('ResourceLimit');
    }
    Object? result;
    await host.readCatalog(
      session,
      instance,
      root,
      handle,
      (chunk) {
        result = {
          'event': 'read',
          'state': request['state'],
          'bytes': base64Encode(chunk.bytes),
          'eof': chunk.eof,
        };
      },
      offset: offset,
      limit: limit,
    );
    return result;
  }

  int _limit(Object? value, int max) {
    if (value is! int || value < 1 || value > max) {
      throw StateError('ResourceLimit');
    }
    return value;
  }

  void stop() {
    _closed = true;
    _active?.cancel();
  }

  Future<void> drain() async => await _draining;
}
