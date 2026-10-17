import 'dart:io';

import '../chat_history.dart';
import '../core.dart';
import '../key_vault.dart';
import 'local_store.dart';
import 'native.dart';
import 'platform_stub.dart'
    if (dart.library.ui) 'platform_flutter.dart'
    as platform;

typedef SavedMlsArchiveOpener = Future<MlsLocalStore> Function(
  IdentityVault vault,
  String origin,
  ChatHistory history,
);

Future<MlsLocalStore> openSavedMlsArchive(
  IdentityVault vault,
  String origin,
  ChatHistory history, {
  SecureKeyStorage? storage,
  Directory? directory,
}) async {
  final record = await vault.load(origin);
  if (record == null ||
      record.origin != origin ||
      record.serverId != history.serverId ||
      record.grantId != history.grantId ||
      (await record.identity()).principalId != history.principalId) {
    throw StateError('Архив принадлежит другому устройству');
  }
  final scope = record.mlsIdentity;
  if (scope == null ||
      scope['server_id'] != history.serverId ||
      scope['principal_id'] != history.principalId) {
    throw StateError('Нет сохранённого архива MLS');
  }
  return MlsLocalStore(
    storage: _ReadOnlyArchiveStorage(storage ?? platform.secureStorage()),
    engine: _ArchiveEngine(),
    scope: Map<String, dynamic>.from(scope),
    deviceSeed: const [],
    requireExisting: true,
    lockDirectory: directory ?? await platform.lockDirectory(),
  );
}

class _ReadOnlyArchiveStorage implements SecureKeyStorage {
  _ReadOnlyArchiveStorage(this.source);
  final SecureKeyStorage source;
  @override
  Future<String?> read({required String key}) => source.read(key: key);
  @override
  Future<void> write({required String key, required String value}) async =>
      throw StateError('Архив доступен только для чтения');
  @override
  Future<void> delete({required String key}) async =>
      throw StateError('Архив доступен только для чтения');
}

class _ArchiveEngine implements MlsEngine {
  @override
  Future<Map<String, dynamic>> execute(Map<String, dynamic> request) async =>
      throw StateError('Офлайн-поиск не изменяет состояние MLS');
}
