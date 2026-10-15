import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../key_vault.dart';
import 'native.dart';

// Вся запись, включая checkpoint, историю и исходящие пакеты, сохраняется
// одним защищённым значением ОС. Открытые SharedPreferences не используются.
class MlsLocalStore {
  MlsLocalStore({
    required this.storage,
    required this.engine,
    required this.scope,
    required this.deviceSeed,
    this.lockDirectory,
    this.requireExisting = false,
  });
  final SecureKeyStorage storage;
  final MlsEngine engine;
  final Map<String, dynamic> scope;
  final List<int> deviceSeed;
  final Directory? lockDirectory;
  final bool requireExisting;
  static final _tails = <String, Future<void>>{};

  String get storageKey =>
      'space.mls.v1.${sha256.convert(utf8.encode(jsonEncode([scope['server_id'], scope['principal_id'], scope['grant_id']])))}';

  Future<T> _serial<T>(Future<T> Function() operation) async {
    final previous = _tails[storageKey] ?? Future.value();
    final done = Completer<void>();
    _tails[storageKey] = done.future;
    await previous;
    RandomAccessFile? lock;
    var locked = false;
    try {
      final directory = lockDirectory;
      if (directory != null) {
        await directory.create(recursive: true);
        lock = await File.fromUri(directory.uri.resolve('$storageKey.lock'))
            .open(mode: FileMode.append);
        await lock.lock(FileLock.blockingExclusive);
        locked = true;
      }
      return await operation();
    } finally {
      try {
        if (lock != null) {
          try {
            if (locked) await lock.unlock();
          } finally {
            await lock.close();
          }
        }
      } finally {
        done.complete();
        if (identical(_tails[storageKey], done.future)) {
          _tails.remove(storageKey);
        }
      }
    }
  }

  Future<Map<String, dynamic>> read() => _serial(_load);

  Future<Map<String, dynamic>> _load() async {
    final raw = await storage.read(key: storageKey);
    if (raw != null) {
      final document = jsonDecode(raw) as Map<String, dynamic>;
      if (document['v'] != 1 ||
          jsonEncode(document['scope']) != jsonEncode(scope)) {
        throw StateError('Состояние MLS принадлежит другому устройству');
      }
      return document;
    }
    if (requireExisting) {
      throw StateError('Не найдено сохранённое состояние MLS до смены root');
    }
    final random = Random.secure();
    final key = List.generate(32, (_) => random.nextInt(256));
    final initialized = await engine.execute({
      'op': 'new',
      'scope': scope,
      'key': key,
      'revision': 0,
      'args': {'device_seed': deviceSeed},
    });
    final document = <String, dynamic>{
      'v': 1,
      'scope': scope,
      'key': key,
      ...initialized,
      'channels': <String, dynamic>{},
      'trusted': <String, dynamic>{},
    };
    document.remove('result');
    await _save(document);
    return document;
  }

  Future<Map<String, dynamic>> update(
    String operation,
    Map<String, dynamic> args, {
    void Function(Map<String, dynamic> document, Map<String, dynamic> result)?
    change,
  }) => _serial(() async {
    final document = await _load();
    final reply = await engine.execute({
      'op': operation,
      'scope': scope,
      'key': document['key'],
      'revision': document['revision'],
      'binding': document['binding'],
      'snapshot': document['snapshot'],
      'args': args,
    });
    final result = Map<String, dynamic>.from(reply['result'] as Map);
    document.addAll(reply);
    document.remove('result');
    change?.call(document, result);
    await _save(document);
    return result;
  });

  Future<void> change(void Function(Map<String, dynamic>) change) =>
      _serial(() async {
        final document = await _load();
        change(document);
        await _save(document);
      });

  Future<void> _save(Map<String, dynamic> document) async {
    final encoded = jsonEncode(document);
    await storage.write(key: storageKey, value: encoded);
    if (await storage.read(key: storageKey) != encoded) {
      throw StateError('Не удалось подтвердить сохранение состояния MLS');
    }
  }
}
