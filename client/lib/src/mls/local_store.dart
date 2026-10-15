import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../key_vault.dart';
import 'native.dart';

class MlsRecoveryRequired extends StateError {
  MlsRecoveryRequired()
    : super(
        'Обнаружен откат или незавершённая запись MLS. Отправка остановлена. '
        'Сохраните архив истории, подключите новое устройство и попросите '
        'управляющего исключить прежнее устройство и пригласить новое.',
      );
}

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

  File? get _witness => lockDirectory == null
      ? null
      : File.fromUri(lockDirectory!.uri.resolve('$storageKey.witness'));

  Future<void> _verify(String? raw) async {
    final witness = _witness;
    if (witness == null) return;
    final enabled = await storage.read(key: '$storageKey.rollback-enabled');
    final saved = await witness.exists() ? await witness.readAsString() : null;
    if (raw == null && saved == null && enabled == null) return;
    if (raw != null && saved == sha256.convert(utf8.encode(raw)).toString()) {
      return;
    }
    // Однократное включение защиты для состояния прежней версии.
    if (enabled == null &&
        saved == null &&
        raw != null &&
        (jsonDecode(raw) as Map)['rollback_guard'] == null) {
      return;
    }
    throw MlsRecoveryRequired();
  }

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
    await _verify(raw);
    if (raw != null) {
      final document = jsonDecode(raw) as Map<String, dynamic>;
      if (document['v'] != 1 ||
          jsonEncode(document['scope']) != jsonEncode(scope)) {
        throw StateError('Состояние MLS принадлежит другому устройству');
      }
      return document;
    }
    if (requireExisting) {
      throw MlsRecoveryRequired();
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
    if (_witness != null) document['rollback_guard'] = 1;
    final encoded = jsonEncode(document);
    if (utf8.encode(encoded).length > 32 * 1024 * 1024) {
      throw StateError('Хранилище MLS заполнено. Сохраните архив истории.');
    }
    // Сначала свидетель: сбой между записями блокирует старый ratchet,
    // а не разрешает повторно использовать уже выданный ключ сообщения.
    if (_witness != null &&
        await storage.read(key: '$storageKey.rollback-enabled') == null) {
      await storage.write(key: '$storageKey.rollback-enabled', value: '1');
    }
    await _witness?.writeAsString(
      sha256.convert(utf8.encode(encoded)).toString(),
      flush: true,
    );
    await storage.write(key: storageKey, value: encoded);
    if (await storage.read(key: storageKey) != encoded) {
      throw StateError('Не удалось подтвердить сохранение состояния MLS');
    }
  }

  // Этот путь не открывает snapshot и не позволяет возобновить ratchet.
  // Архив содержит только уже расшифрованную историю и ключи её файлов.
  Future<Map<String, dynamic>> historyArchive() => _serial(() async {
    final raw = await storage.read(key: storageKey);
    if (raw == null) throw StateError('История MLS не найдена');
    final document = jsonDecode(raw) as Map;
    if (document['v'] != 1 ||
        jsonEncode(document['scope']) != jsonEncode(scope)) {
      throw StateError('Архив принадлежит другому устройству');
    }
    return {
      'v': 1,
      'server_id': scope['server_id'],
      'principal_id': scope['principal_id'],
      'previous_grant_id': scope['grant_id'],
      'channels': [
        for (final entry in (document['channels'] as Map).entries)
          {
            'id': entry.key,
            'group_id': (entry.value as Map)['group_id'],
            'messages': [
              ...?(entry.value as Map)['archived_messages'] as List?,
              ...(entry.value as Map)['messages'] as List,
            ],
          },
      ],
    };
  });
}
