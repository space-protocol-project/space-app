import 'dart:async';
import 'dart:convert';

import 'core.dart';
import 'directory_document.dart';
import 'key_vault.dart';

class DirectoryRepository {
  DirectoryRepository(this.storage);
  final SecureKeyStorage storage;
  static const key = 'space.directory.v1';
  Future<void> _tail = Future.value();

  Future<T> exclusive<T>(Future<T> Function() action) async {
    final previous = _tail, done = Completer<void>();
    _tail = done.future;
    await previous;
    try {
      return await action();
    } finally {
      done.complete();
    }
  }

  Future<Map<String, dynamic>> read() async {
    final raw = await storage.read(key: key);
    if (raw == null) {
      return {
        'v': 1,
        'catalog': <String, dynamic>{},
        'heads': <String, dynamic>{},
        'outgoing': '',
        'pending': null,
      };
    }
    directoryRequire(utf8.encode(raw).length <= 8 * 1024 * 1024);
    final data = directoryMap(
      jsonDecode(raw),
      'catalog,heads,outgoing,pending,v',
    );
    directoryRequire(
      data['v'] == 1 &&
          data['catalog'] is Map<String, dynamic> &&
          data['heads'] is Map<String, dynamic>,
    );
    final catalog = data['catalog'] as Map<String, dynamic>;
    directoryRequire(
      catalog.length <= 100 && (data['heads'] as Map).length <= 1000,
    );
    for (final entry in catalog.entries) {
      directoryRequire(
        checkedDirectorySpace(entry.value)['origin'] == entry.key,
      );
    }
    final outgoing = directoryText(data['outgoing'], max: 22);
    if (outgoing.isNotEmpty) directoryBytes(outgoing, 16);
    _heads(data['heads'] as Map<String, dynamic>);
    _pending(data['pending'], catalog);
    return data;
  }

  void _heads(Map<String, dynamic> heads) {
    for (final entry in heads.entries) {
      directoryBytes(entry.key, 16);
      final head = directoryMap(entry.value, 'digest,revision');
      directoryBytes(head['digest'], 32);
      directoryInt(head['revision'], min: 1);
    }
  }

  void _pending(Object? value, Map<String, dynamic> catalog) {
    if (value == null) return;
    final data = directoryMap(value, 'origins,settings'),
        origins = data['origins'];
    directoryRequire(origins is List && origins.length <= 100);
    directoryRequire(
      (origins as List).every(
        (origin) => origin is String && catalog.containsKey(origin),
      ),
    );
    if (data['settings'] != null) checkedDirectorySettings(data['settings']);
  }

  Future<void> write(Map<String, dynamic> data) async {
    directoryRequire(
      (data['catalog'] as Map).length <= 100 &&
          (data['heads'] as Map).length <= 1000,
    );
    _heads(data['heads'] as Map<String, dynamic>);
    _pending(data['pending'], data['catalog'] as Map<String, dynamic>);
    final raw = jsonEncode(data);
    directoryRequire(utf8.encode(raw).length <= 8 * 1024 * 1024);
    await storage.write(key: key, value: raw);
    if (await storage.read(key: key) != raw) {
      throw StateError('Хранилище не подтвердило запись каталога');
    }
  }

  Future<void> checkTrust(Discovery server) async {
    final state = await read();
    final pin = (state['catalog'] as Map)[server.origin.toString()];
    if (pin == null) return;
    final saved = checkedDirectorySpace(pin),
        announcement = server.announcement;
    directoryRequire(
      saved['server_id'] == server.serverId &&
          saved['server_key'] == url64(server.publicKey),
    );
    directoryRequire(saved['tls_fingerprint'] == server.tlsFingerprint);
    final revision = saved['endpoint_revision'] as int;
    if (revision == 0) return;
    directoryRequire(announcement != null && announcement.revision >= revision);
    if (announcement!.revision == revision) {
      directoryRequire(announcement.digest == saved['endpoint_digest']);
    }
  }

  Future<void> checkRecord(DeviceRecord record) async {
    final state = await read();
    final pin = (state['catalog'] as Map)[record.origin];
    if (pin == null) return;
    final saved = checkedDirectorySpace(pin);
    directoryRequire(saved['principal_id'] == (await record.identity()).principalId);
    directoryRequire(saved['server_id'] == record.serverId &&
        saved['server_key'] == record.serverKey &&
        saved['tls_fingerprint'] == record.tlsFingerprint);
  }
}

String? directoryPinConflict(
  Map<String, dynamic> local,
  Map<String, dynamic> incoming,
) {
  for (final field in [
    'server_id',
    'server_key',
    'tls_fingerprint',
    'principal_id',
  ]) {
    if (local[field] != incoming[field]) {
      return 'Конфликт $field: ${incoming['origin']}';
    }
  }
  final before = local['endpoint_revision'] as int,
      after = incoming['endpoint_revision'] as int;
  if (after < before) return 'Откат адресов: ${incoming['origin']}';
  if (after == before &&
      local['endpoint_digest'] != incoming['endpoint_digest']) {
    return 'Конфликт адресов: ${incoming['origin']}';
  }
  return null;
}
