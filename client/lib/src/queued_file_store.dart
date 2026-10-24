import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';
import 'files.dart';
import 'package:path_provider/path_provider.dart';

import 'attachments.dart';
import 'chat_outbox.dart';
import 'outbox_lock.dart';
import 'queued_file.dart';
import 'secure_vault.dart';

part 'queued_file_transfer.dart';

const maxQueuedFileBytes = 200 * 1024 * 1024;

class FileQueueFull extends OutboxFull {
  const FileQueueFull();
}

/// В каталоге только AES-GCM; ключ находится в системном защищённом хранилище.
class QueuedFileStore {
  QueuedFileStore({
    SecureKeyStorage? storage,
    Future<Directory> Function()? directory,
    this.maxBytes = maxQueuedFileBytes,
  }) : storage = storage ?? const PlatformKeyStorage(),
       directory = directory ?? getApplicationSupportDirectory;
  final SecureKeyStorage storage;
  final Future<Directory> Function() directory;
  final int maxBytes;
  final _cipher = AesGcm.with256bits();

  Future<T> _locked<T>(
    OutboxScope scope,
    Future<T> Function(Directory) action,
  ) async {
    final root = await directory();
    final locks = await Directory('${root.path}/outbox-file-locks')
        .create(recursive: true);
    return OutboxLock.run('${locks.path}/${scope.id}.lock', () async {
      final files = await Directory('${root.path}/outbox-files')
          .create(recursive: true);
      if (await FileSystemEntity.type(files.path, followLinks: false) !=
          FileSystemEntityType.directory) {
        throw const FormatException('Недопустимый каталог файлов');
      }
      // Windows может перенаправлять AppData процесса MSIX в LocalCache.
      // Проверяем границы выделенного каталога после этого перенаправления.
      final canonicalRoot = await files.resolveSymbolicLinks();
      final folder = await Directory('$canonicalRoot/${scope.id}')
          .create(recursive: true);
      final base = '${_normalize(canonicalRoot)}${Platform.pathSeparator}';
      final resolved = await folder.resolveSymbolicLinks();
      final inside = _normalize(resolved).startsWith(base);
      if (!inside) {
        throw const FormatException('Каталог файлов находится вне хранилища');
      }
      return action(Directory(resolved));
    });
  }

  String _normalize(String path) {
    final normalized = Platform.isWindows
        ? path.replaceAll('/', Platform.pathSeparator).toLowerCase()
        : path;
    return normalized.replaceFirst(RegExp(r'[/\\]+$'), '');
  }

  Future<SecretKey> _key(
    OutboxScope scope,
    Directory folder, {
    bool create = false,
  }) async {
    final slot = 'space.outbox.files.key.v1.${scope.id}';
    final saved = await storage.read(key: slot);
    if (saved != null) {
      final bytes = base64Decode(saved);
      if (bytes.length != 32) {
        throw const FormatException('Неверный ключ файловой очереди');
      }
      return SecretKey(bytes);
    }
    if (!create ||
        await folder.list().any((file) => file.path.endsWith('.bin'))) {
      throw StateError('Нет ключа файловой очереди');
    }
    final key = await _cipher.newSecretKey();
    await storage.write(
      key: slot,
      value: base64Encode(await key.extractBytes()),
    );
    return key;
  }

  List<int> _aad(OutboxScope scope, QueuedFile file) => utf8.encode(
    jsonEncode(['space/outbox-file/v1', scope.binding, file.toJson()]),
  );

  Future<List<QueuedFile>> stage(
    OutboxScope scope,
    String message,
    List<SpaceFile> files,
  ) => _locked(scope, (folder) => _stage(scope, folder, message, files));

  Future<List<QueuedFile>> _stage(
    OutboxScope scope,
    Directory folder,
    String message,
    List<SpaceFile> files,
  ) async {
    if (files.length > maxAttachments) {
      throw const FormatException('Не более пяти файлов');
    }
    await _removeTemporary(folder);
    final key = await _key(scope, folder, create: true);
    final staged = <QueuedFile>[];
    final created = <QueuedFile>[];
    try {
      for (var index = 0; index < files.length; index++) {
        final existed = await File(
          '${folder.path}/${QueuedFile.slot(message, index)}.bin',
        ).exists();
        final file = await _stageOne(
          scope,
          folder,
          key,
          message,
          index,
          files[index],
        );
        staged.add(file);
        if (!existed) created.add(file);
      }
      return List.unmodifiable(staged);
    } catch (_) {
      for (final file in created) {
        await _removeFile(File('${folder.path}/${file.id}.bin'));
      }
      rethrow;
    } finally {
      await _removeTemporary(folder);
    }
  }

  /// Блокировка держится до записи метаданных. Другой процесс не может убрать
  /// ещё не зафиксированную копию как оставшуюся после аварии.
  Future<List<PendingMessage>> enqueue(
    OutboxScope scope,
    PendingMessage entry,
    List<SpaceFile> files,
    ChatOutboxStore outbox, {
    required bool Function() active,
  }) => _locked(scope, (folder) async {
    final saved = await outbox.read(scope);
    if (!active() || saved.any((message) => message.key == entry.key)) {
      return saved;
    }
    _checkCapacity(entry, files, saved.length);
    await _prune(
      folder,
      saved.expand((m) => m.localFiles).map((f) => f.id).toSet(),
    );
    final staged = entry.withFiles(
      await _stage(scope, folder, entry.key, files),
    );
    staged.validate();
    return outbox.change(scope, (latest) {
      if (!active() || latest.any((m) => m.key == staged.key)) return latest;
      return [...latest, staged];
    });
  });

  void _checkCapacity(PendingMessage entry, List<SpaceFile> files, int count) {
    if (count >= maxPendingMessages) throw const OutboxFull();
    if (files.isEmpty ||
        files.length + entry.attachments.length > maxAttachments ||
        utf8.encode(entry.text).length > 4096) {
      throw const FormatException('Некорректное сообщение с файлами');
    }
  }

  Future<void> _prune(Directory folder, Set<String> protected) async {
    await for (final entity in folder.list(followLinks: false)) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      if (RegExp(r'^[a-f0-9]{64}\.bin$').hasMatch(name) &&
          !protected.contains(name.substring(0, 64))) {
        await entity.delete();
      }
    }
  }

  Future<QueuedFile> _stageOne(
    OutboxScope scope,
    Directory folder,
    SecretKey key,
    String message,
    int index,
    SpaceFile source,
  ) async {
    final bytes = await readAttachmentBytes(source);
    final file = QueuedFile(
      id: QueuedFile.slot(message, index),
      key: '$message-file-$index',
      name: attachmentName(source),
      size: bytes.length,
      digest: hash.sha256.convert(bytes).toString(),
    );
    file.validate();
    final path = File('${folder.path}/${file.id}.bin');
    if (await path.exists()) {
      await _read(scope, folder, key, file);
      return file;
    }
    if (await _usedBytes(folder) + bytes.length + 28 > maxBytes) {
      throw const FileQueueFull();
    }
    final sealed = await _cipher.encrypt(
      bytes,
      secretKey: key,
      aad: _aad(scope, file),
    );
    final temporary = File('${folder.path}/${file.id}.tmp');
    await temporary.writeAsBytes(sealed.concatenation(), flush: true);
    await temporary.rename(path.path);
    return file;
  }

  Future<int> _usedBytes(Directory folder) async {
    var size = 0;
    await for (final entity in folder.list(followLinks: false)) {
      if (entity is File) size += await entity.length();
    }
    return size;
  }

  Future<Uint8List> read(OutboxScope scope, QueuedFile file) =>
      _locked(scope, (folder) async {
        file.validate();
        return _read(scope, folder, await _key(scope, folder), file);
      });

  Future<Uint8List> _read(
    OutboxScope scope,
    Directory folder,
    SecretKey key,
    QueuedFile file,
  ) async {
    final path = File('${folder.path}/${file.id}.bin');
    if (await FileSystemEntity.type(path.path, followLinks: false) !=
            FileSystemEntityType.file ||
        await path.length() != file.size + 28) {
      throw const FormatException('Копия файла отсутствует или повреждена');
    }
    final sealed = SecretBox.fromConcatenation(
      await path.readAsBytes(),
      nonceLength: 12,
      macLength: 16,
    );
    final bytes = await _cipher.decrypt(
      sealed,
      secretKey: key,
      aad: _aad(scope, file),
    );
    if (bytes.length != file.size ||
        hash.sha256.convert(bytes).toString() != file.digest) {
      throw const FormatException(
        'Контрольная сумма локального файла не совпадает',
      );
    }
    return Uint8List.fromList(bytes);
  }

  Future<void> remove(OutboxScope scope, Iterable<QueuedFile> files) =>
      _locked(scope, (folder) async {
        for (final file in files) {
          file.validate();
          await _removeFile(File('${folder.path}/${file.id}.bin'));
        }
      });

  Future<void> _removeFile(File file) async {
    final type = await FileSystemEntity.type(file.path, followLinks: false);
    if (type == FileSystemEntityType.file) await file.delete();
  }

  Future<void> _removeTemporary(Directory folder) async {
    await for (final entity in folder.list(followLinks: false)) {
      if (entity is File &&
          RegExp(r'^[a-f0-9]{64}\.tmp$')
              .hasMatch(entity.uri.pathSegments.last)) {
        await entity.delete();
      }
    }
  }

  Future<void> clear(OutboxScope scope) => _locked(scope, (folder) async {
    await for (final entity in folder.list(followLinks: false)) {
      if (entity is File &&
          RegExp(r'^[a-f0-9]{64}\.(bin|tmp)$')
              .hasMatch(entity.uri.pathSegments.last)) {
        await entity.delete();
      }
    }
    await storage.delete(key: 'space.outbox.files.key.v1.${scope.id}');
  });
}
