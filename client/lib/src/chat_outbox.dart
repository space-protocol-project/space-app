import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import 'secure_vault.dart';
import 'outbox_lock.dart';
import 'queued_file.dart';
import 'queued_mutation.dart';

part 'chat_outbox_sources.dart';

const maxPendingMessages = 100;
const maxOutboxBytes = 1024 * 1024;

String outboxSnapshot(List<PendingMessage> entries) => sha256
    .convert(
      utf8.encode(jsonEncode(entries.map((entry) => entry.toJson()).toList())),
    )
    .toString();

class OutboxFull extends FormatException {
  const OutboxFull() : super('Очередь заполнена');
}

class OutboxScope {
  const OutboxScope(this.origin, this.serverId, this.principalId, this.grantId);
  final String origin, serverId, principalId, grantId;
  String get binding => jsonEncode([origin, serverId, principalId, grantId]);
  String get id => sha256.convert(utf8.encode(binding)).toString();
}

class PendingMessage {
  PendingMessage({
    required this.key,
    required this.channelId,
    required this.text,
    required this.createdAt,
    List<String> attachments = const [],
    List<QueuedFile> localFiles = const [],
    List<String> uploadedFiles = const [],
    this.blocked = false,
    this.mutation,
    this.replyTo = '',
  }) : attachments = List.unmodifiable(attachments),
       localFiles = List.unmodifiable(localFiles),
       uploadedFiles = List.unmodifiable(uploadedFiles);
  final String key, channelId, text, replyTo;
  final int createdAt;
  final List<String> attachments;
  final List<QueuedFile> localFiles;
  final List<String> uploadedFiles;
  List<String> get attachmentIds => [...attachments, ...uploadedFiles];
  final bool blocked;
  final QueuedMutation? mutation;

  PendingMessage withBlocked(bool value) => PendingMessage(
    key: key,
    channelId: channelId,
    text: text,
    createdAt: createdAt,
    attachments: attachments,
    localFiles: localFiles,
    uploadedFiles: uploadedFiles,
    blocked: value,
    mutation: mutation,
    replyTo: replyTo,
  );

  PendingMessage withFiles(List<QueuedFile> files) => PendingMessage(
    key: key,
    channelId: channelId,
    text: text,
    createdAt: createdAt,
    attachments: attachments,
    localFiles: files,
    uploadedFiles: uploadedFiles,
    blocked: blocked,
    mutation: mutation,
    replyTo: replyTo,
  );

  PendingMessage withUploaded(List<String> ids) => PendingMessage(
    key: key,
    channelId: channelId,
    text: text,
    createdAt: createdAt,
    attachments: attachments,
    localFiles: localFiles,
    uploadedFiles: ids,
    blocked: blocked,
    mutation: mutation,
    replyTo: replyTo,
  );

  PendingMessage withMutation(QueuedMutation value, {bool? blocked}) =>
      PendingMessage(
        key: key,
        channelId: channelId,
        text: text,
        createdAt: createdAt,
        mutation: value,
        blocked: blocked ?? this.blocked,
      );

  Map<String, dynamic> toJson() => {
    'key': key,
    'channel': channelId,
    'text': text,
    'created': createdAt,
    'attachments': attachments,
    'files': localFiles.map((file) => file.toJson()).toList(),
    'uploaded': uploadedFiles,
    'blocked': blocked,
    if (replyTo.isNotEmpty) 'replyTo': replyTo,
    if (mutation != null) 'mutation': mutation!.toJson(),
  };

  factory PendingMessage.fromJson(Map<String, dynamic> value) {
    final result = PendingMessage(
      key: value['key'] as String,
      channelId: value['channel'] as String,
      text: value['text'] as String,
      createdAt: value['created'] as int,
      attachments: (value['attachments'] as List).cast<String>(),
      localFiles: (value['files'] as List? ?? [])
          .map(
            (file) =>
                QueuedFile.fromJson(Map<String, dynamic>.from(file as Map)),
          )
          .toList(),
      uploadedFiles: (value['uploaded'] as List? ?? []).cast<String>(),
      blocked: value['blocked'] as bool,
      replyTo: value['replyTo'] as String? ?? '',
      mutation: value['mutation'] == null
          ? null
          : QueuedMutation.fromJson(
              Map<String, dynamic>.from(value['mutation'] as Map),
            ),
    );
    result.validate();
    return result;
  }

  void validate() {
    if (key.isEmpty ||
        key.length > 128 ||
        channelId.isEmpty ||
        channelId.length > 128 ||
        createdAt < 0 ||
        utf8.encode(replyTo).length > 128 ||
        mutation != null && replyTo.isNotEmpty) {
      throw const FormatException('Некорректная запись очереди');
    }
    if (mutation != null) {
      _validateMutation();
      return;
    }
    if (utf8.encode(text).length > 4096 ||
        attachments.length + localFiles.length > 5 ||
        (text.trim().isEmpty && attachments.isEmpty && localFiles.isEmpty)) {
      throw const FormatException('Некорректное сообщение очереди');
    }
    _validateFiles();
  }

  void _validateMutation() {
    final change = mutation!;
    change.validate();
    if (attachments.isNotEmpty ||
        localFiles.isNotEmpty ||
        uploadedFiles.isNotEmpty ||
        change.after == key ||
        utf8.encode(text).length > 4096) {
      throw const FormatException('Недопустимое изменение в очереди');
    }
    if (change.kind != MutationKind.edit && text.isNotEmpty) {
      throw const FormatException('Изменение не должно содержать текст');
    }
    if (change.kind == MutationKind.edit &&
        text.trim().isEmpty &&
        !change.hasAttachments) {
      throw const FormatException('Сообщение не может быть пустым');
    }
  }

  void _validateFiles() {
    if (attachmentIds.any((id) => id.isEmpty || id.length > 128) ||
        attachmentIds.toSet().length != attachmentIds.length ||
        uploadedFiles.isNotEmpty && uploadedFiles.length != localFiles.length) {
      throw const FormatException('Некорректные вложения очереди');
    }
    if (localFiles.map((file) => file.id).toSet().length != localFiles.length ||
        localFiles.map((file) => file.key).toSet().length !=
            localFiles.length) {
      throw const FormatException('Повторяющиеся файлы очереди');
    }
    for (var index = 0; index < localFiles.length; index++) {
      final file = localFiles[index];
      file.validate();
      if (file.id != QueuedFile.slot(key, index) ||
          file.key != '$key-file-$index') {
        throw const FormatException('Файл относится к другому сообщению');
      }
    }
  }
}

abstract interface class ChatOutboxStore {
  Future<List<PendingMessage>> read(OutboxScope scope);
  Future<List<PendingMessage>> change(
    OutboxScope scope,
    List<PendingMessage> Function(List<PendingMessage>) update,
  );
}

/// Данные находятся в защищённом хранилище; файл служит только блокировкой.
/// Изменения читают последнюю запись под общей для процессов блокировкой.
class LocalChatOutbox implements ChatOutboxStore {
  LocalChatOutbox({
    SecureKeyStorage? storage,
    Future<Directory> Function()? directory,
  }) : storage = storage ?? const PlatformKeyStorage(),
       directory = directory ?? getApplicationSupportDirectory;
  final SecureKeyStorage storage;
  final Future<Directory> Function() directory;
  String _key(OutboxScope scope) => 'space.outbox.v1.${scope.id}';

  Future<T> _locked<T>(OutboxScope scope, Future<T> Function() action) async {
    final root = await directory();
    final locks = await Directory('${root.path}/outbox-locks')
        .create(recursive: true);
    final path = '${locks.path}/${scope.id}.lock';
    return OutboxLock.run(path, action);
  }

  Future<List<PendingMessage>> _read(OutboxScope scope) async {
    final saved = await storage.read(key: _key(scope));
    if (saved == null) return [];
    if (utf8.encode(saved).length > maxOutboxBytes) {
      throw const FormatException('Слишком большая очередь');
    }
    final data = jsonDecode(saved) as Map<String, dynamic>;
    if (![1, 2, 3].contains(data['v']) || data['binding'] != scope.binding) {
      throw const FormatException('Очередь принадлежит другому устройству');
    }
    final entries = (data['messages'] as List)
        .map(
          (entry) =>
              PendingMessage.fromJson(Map<String, dynamic>.from(entry as Map)),
        )
        .toList();
    if (data['v'] == 1 && entries.any((entry) => entry.mutation != null)) {
      throw const FormatException('Изменения требуют второй версии очереди');
    }
    if (data['v'] != 3 && entries.any((entry) => entry.replyTo.isNotEmpty)) {
      throw const FormatException('Ответы требуют третьей версии очереди');
    }
    _validate(entries);
    return entries;
  }

  void _validate(List<PendingMessage> entries) {
    if (entries.length > maxPendingMessages) throw const OutboxFull();
    if (entries.map((entry) => entry.key).toSet().length != entries.length) {
      throw const FormatException('Некорректный состав очереди');
    }
    for (final entry in entries) {
      entry.validate();
    }
    _validateDependencies(entries);
  }

  void _validateDependencies(List<PendingMessage> entries) {
    final seen = <String, PendingMessage>{};
    for (final entry in entries) {
      final after = entry.mutation?.after ?? '';
      if (after.isNotEmpty) _validateParent(entry, seen[after]);
      seen[entry.key] = entry;
    }
  }

  void _validateParent(PendingMessage entry, PendingMessage? parent) {
    if (parent == null && entry.blocked) return;
    if (parent == null ||
        parent.channelId != entry.channelId ||
        parent.mutation?.id != entry.mutation!.id) {
      throw const FormatException('Недопустимая зависимость изменения');
    }
  }

  @override
  Future<List<PendingMessage>> read(OutboxScope scope) =>
      _locked(scope, () async {
        final entries = await _read(scope);
        if (entries.isNotEmpty) await _rememberScope(scope);
        return entries;
      });

  @override
  Future<List<PendingMessage>> change(
    OutboxScope scope,
    List<PendingMessage> Function(List<PendingMessage>) update,
  ) => _locked(scope, () async {
    final entries = update(await _read(scope));
    _validate(entries);
    final encoded = jsonEncode({
      // Старый клиент не должен отправить текст правки как новое сообщение.
      'v': entries.any((entry) => entry.replyTo.isNotEmpty)
          ? 3
          : entries.any((entry) => entry.mutation != null)
          ? 2
          : 1,
      'binding': scope.binding,
      'messages': entries.map((entry) => entry.toJson()).toList(),
    });
    if (utf8.encode(encoded).length > maxOutboxBytes) {
      throw const OutboxFull();
    }
    // Пустой документ тоже записывается атомарно: отсутствие подтверждения
    // записи оставляет прежние ключи для безопасного повтора.
    if (entries.isNotEmpty) await _rememberScope(scope);
    await storage.write(key: _key(scope), value: encoded);
    return List.unmodifiable(entries);
  });
}
