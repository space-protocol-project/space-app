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
      if (document['transferred'] != null) {
        throw StateError(
          'Устройство перенесено. Используйте сохранённый архив на новом устройстве.',
        );
      }
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

  // Блокировка удерживается до сохранения архива: ratchet не может измениться
  // между снимком и остановкой прежнего устройства.
  Future<void> transferCheckpoint(
    String transferId,
    Future<void> Function(Map<String, dynamic>) preserve,
  ) => _serial(() async {
    final document = await _load();
    await validateCheckpoint(document);
    await preserve(jsonDecode(jsonEncode(document)) as Map<String, dynamic>);
    await _save(_frozenCheckpoint(document, transferId));
  });

  Map<String, dynamic> _frozenCheckpoint(
    Map<String, dynamic> checkpoint,
    String transferId,
  ) {
    final document = jsonDecode(jsonEncode(checkpoint)) as Map<String, dynamic>;
    document['transferred'] = transferId;
    // Старый клиент не знает отметку transferred. Отсутствие самих рабочих
    // ключей блокирует и его, сохраняя читаемую историю и ключи её файлов.
    for (final field in const ['key', 'snapshot', 'binding', 'revision']) {
      document.remove(field);
    }
    if (_witness != null) document['rollback_guard'] = 1;
    return document;
  }

  Future<bool> resumeTransfer(
    Map<String, dynamic> checkpoint,
    String transferId,
  ) => _serial(() async {
    final raw = await storage.read(key: storageKey);
    try {
      await _verify(raw);
    } on MlsRecoveryRequired {
      await _completeInterruptedRetirement(raw, checkpoint, transferId);
      return true;
    }
    return raw != null && (jsonDecode(raw) as Map)['transferred'] == transferId;
  });

  // При переносе всего устройства несколько ratchet останавливаются подряд.
  // После обрыва разрешено остановить лишь неизменившийся исходный снимок.
  Future<void> completeDeviceTransfer(
    Map<String, dynamic> checkpoint,
    String transferId,
  ) => _serial(() async {
    final raw = await storage.read(key: storageKey);
    try {
      await _verify(raw);
    } on MlsRecoveryRequired {
      await _completeInterruptedRetirement(raw, checkpoint, transferId);
      return;
    }
    if (raw != null && (jsonDecode(raw) as Map)['transferred'] == transferId) {
      return;
    }
    if (raw != jsonEncode(checkpoint)) {
      throw StateError('Исходное состояние MLS изменилось после экспорта');
    }
    await validateCheckpoint(checkpoint);
    await _save(_frozenCheckpoint(checkpoint, transferId));
  });

  Future<void> _completeInterruptedRetirement(
    String? raw,
    Map<String, dynamic> checkpoint,
    String transferId,
  ) async {
    if (raw != null && raw != jsonEncode(checkpoint)) {
      throw MlsRecoveryRequired();
    }
    await validateCheckpoint(checkpoint);
    final stopped = _frozenCheckpoint(checkpoint, transferId);
    final witness = _witness;
    final expected = sha256
        .convert(utf8.encode(jsonEncode(stopped)))
        .toString();
    if (witness == null ||
        !await witness.exists() ||
        await witness.readAsString() != expected ||
        await storage.read(key: '$storageKey.rollback-enabled') != '1') {
      throw MlsRecoveryRequired();
    }
    // Только завершение уже засвидетельствованного удаления рабочих ключей.
    // Ни снимок, ни ratchet из архива здесь не активируются.
    await _save(stopped);
  }

  Future<void> requireMigrationTarget(String transferId) => _serial(() async {
    final raw = await storage.read(key: storageKey);
    await _verify(raw);
    if (raw != null) {
      final document = await _load();
      if (document['imported_transfer'] == transferId) return;
      throw StateError('Нельзя заменить существующее состояние MLS архивом');
    }
  });

  Future<void> restoreCheckpoint(
    Map<String, dynamic> checkpoint,
    String transferId,
  ) => _serial(() async {
    final raw = await storage.read(key: storageKey);
    await _verify(raw);
    if (raw != null) {
      final existing = await _load();
      if (existing['imported_transfer'] == transferId) return;
      throw StateError('Нельзя заменить существующее состояние MLS архивом');
    }
    final document = jsonDecode(jsonEncode(checkpoint)) as Map<String, dynamic>;
    await _validateCheckpoint(document);
    document['imported_transfer'] = transferId;
    await _save(document);
  });

  Future<void> validateCheckpoint(Map<String, dynamic> checkpoint) =>
      _validateCheckpoint(
        jsonDecode(jsonEncode(checkpoint)) as Map<String, dynamic>,
      );

  Future<void> _validateCheckpoint(Map<String, dynamic> document) async {
    if (utf8.encode(jsonEncode(document)).length > 32 * 1024 * 1024) {
      throw const FormatException('Состояние MLS превышает допустимый размер');
    }
    if (document['v'] != 1 ||
        document['transferred'] != null ||
        jsonEncode(document['scope']) != jsonEncode(scope) ||
        document['channels'] is! Map ||
        document['trusted'] is! Map) {
      throw const FormatException('Снимок MLS не соответствует устройству');
    }
    final reply = await engine.execute({
      'op': 'key_package',
      'scope': scope,
      'key': document['key'],
      'revision': document['revision'],
      'binding': document['binding'],
      'snapshot': document['snapshot'],
      'args': <String, dynamic>{},
    });
    document.addAll(reply);
    document.remove('result');
  }

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
