import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show compute;

import 'core.dart' show url64;
import 'directory_archive.dart';
import 'directory_backup.dart';
import 'directory_workers.dart';
import 'directory_document.dart';
import 'remote_backup_models.dart';
import 'remote_backup_rpc.dart';

String backupHeadText(BackupHead head) => jsonEncode([
  head.id,
  head.revision.toInt(),
  head.digest,
  head.parent,
  head.archiveDigest,
]);

String remoteChainDigest(BackupHead head) => url64(
  crypto.sha256
      .convert(
        utf8.encode(
          'space/backup-chain/v1\n${head.id}\n${head.revision}\n${head.parent}\n${head.archiveDigest}',
        ),
      )
      .bytes,
);

void checkRemoteHead(BackupHead head, String id) {
  directoryRequire(head.id == id);
  directoryBytes(head.id, 16);
  final revision = directoryInt(head.revision.toInt());
  if (revision == 0) {
    directoryRequire(
      head.digest.isEmpty && head.parent.isEmpty && head.archiveDigest.isEmpty,
    );
    return;
  }
  directoryBytes(head.digest, 32);
  directoryBytes(head.archiveDigest, 32);
  if (revision == 1) {
    directoryRequire(head.parent.isEmpty);
  } else {
    directoryBytes(head.parent, 32);
  }
  directoryRequire(head.digest == remoteChainDigest(head));
}

List<int> backupHeadProof(BackupHead h, String challenge) => utf8.encode(
  'space/backup-head/v1\n$challenge\n${h.id}\n${h.revision}\n${h.digest}\n${h.parent}\n${h.archiveDigest}',
);

Future<String> remoteBackupHash(List<int> bytes) async =>
    url64((await Sha256().hash(bytes)).bytes);

final class RemoteRestore {
  RemoteRestore._(RemoteBackupKit kit, BackupHead head, this.plan)
    : kit = RemoteBackupKit.parse(kit.encode()),
      head = (head.deepCopy()..freeze());
  final RemoteBackupKit kit;
  final BackupHead head;
  final DirectoryRestorePlan plan;
}

class RemoteBackupService {
  RemoteBackupService(this.directory, {this.connect});
  final DirectoryBackupService directory;
  final RemoteBackupApi Function(RemoteBackupEndpoint)? connect;
  static const storageKey = 'space.directory.space-backup.v1';

  Future<Map<String, dynamic>> _state() async {
    final raw = await directory.repository.storage.read(key: storageKey);
    if (raw == null) return {'v': 1, 'kit': null, 'pending': null};
    directoryRequire(utf8.encode(raw).length <= 8 * 1024 * 1024);
    final data = directoryMap(jsonDecode(raw), 'kit,pending,v');
    directoryInt(data['v'], min: 1, max: 1);
    if (data['kit'] != null) RemoteBackupKit.parse(jsonEncode(data['kit']));
    return data;
  }

  Future<void> _save(Map<String, dynamic> data) async {
    final raw = jsonEncode(data);
    directoryRequire(utf8.encode(raw).length <= 8 * 1024 * 1024);
    final storage = directory.repository.storage;
    await storage.write(key: storageKey, value: raw);
    directoryRequire(await storage.read(key: storageKey) == raw);
  }

  Future<RemoteBackupKit?> savedKit() async {
    final value = (await _state())['kit'];
    return value == null ? null : RemoteBackupKit.parse(jsonEncode(value));
  }

  Future<void> saveKit(RemoteBackupKit kit) =>
      directory.repository.exclusive(() async {
        final state = await _state();
        directoryRequire(state['pending'] == null);
        state['kit'] = RemoteBackupKit.parse(kit.encode()).data;
        await _save(state);
      });
  Future<void> forgetRevokedKit() => directory.repository.exclusive(
    () async => _save({'v': 1, 'kit': null, 'pending': null}),
  );

  RemoteBackupApi _api(RemoteBackupEndpoint endpoint) {
    final factory = connect;
    if (factory != null) return factory(endpoint);
    final session = directory.controllers()[endpoint.origin]?.mlsSession;
    if (session != null &&
        session.server.origin.toString() == endpoint.origin &&
        url64(session.server.publicKey) == endpoint.publicKey &&
        session.server.tlsFingerprint.toLowerCase() == endpoint.fingerprint) {
      return RpcRemoteBackup.session(session);
    }
    return RpcRemoteBackup(endpoint);
  }

  Future<T> _client<T>(
    RemoteBackupKit kit,
    Future<T> Function(RemoteBackupApi) action,
  ) async {
    RemoteBackupKit.parse(kit.encode());
    final api = _api(kit.space);
    try {
      return await action(api);
    } finally {
      await api.close();
    }
  }

  Future<BackupHead> _head(RemoteBackupKit kit, RemoteBackupApi api) async {
    final challenge = url64(DirectoryArchive.random(32));
    final result = await api.read(
      ReadBackupHeadRequest(
        id: kit.id,
        token: kit.space.readToken,
        challenge: challenge,
      ),
    );
    directoryRequire(result.challenge == challenge && result.hasHead());
    checkRemoteHead(result.head, kit.id);
    final valid = await Ed25519().verify(
      backupHeadProof(result.head, challenge),
      signature: Signature(
        result.signature,
        publicKey: SimplePublicKey(
          base64Url.decode(base64Url.normalize(kit.space.publicKey)),
          type: KeyPairType.ed25519,
        ),
      ),
    );
    directoryRequire(valid);
    return result.head;
  }

  void _same(BackupHead a, BackupHead b) =>
      directoryRequire(backupHeadText(a) == backupHeadText(b));

  Future<DirectoryDocument> _document(
    GetBackupResponse response,
    BackupHead head,
    String password,
  ) async {
    checkRemoteHead(head, head.id);
    directoryRequire(
      response.hasHead() && response.archive.length <= DirectoryArchive.maxFile,
    );
    _same(response.head, head);
    directoryRequire(
      await remoteBackupHash(response.archive) == head.archiveDigest,
    );
    final document = DirectoryDocument.parse(
      await compute(openDirectoryWorker, (
        Uint8List.fromList(response.archive),
        password,
      )),
    );
    directoryRequire(
      document.id == head.id && document.revision == head.revision.toInt(),
    );
    return document;
  }

  Future<GetBackupResponse> _get(
    RemoteBackupKit kit,
    RemoteBackupApi store,
    int revision,
  ) => store.get(
    GetBackupRequest(
      id: kit.id,
      token: kit.space.readToken,
      revision: Int64(revision),
    ),
  );

  Future<void> publish(
    RemoteBackupKit kit,
    String password,
  ) => directory.repository.exclusive(
    () => _client(kit, (api) async {
      final state = await _state();
      directoryRequire(jsonEncode(state['kit']) == jsonEncode(kit.data));
      if (state['pending'] == null) await _prepare(state, kit, password, api);
      final pending = directoryMap(state['pending'], 'archive,head');
      final head = BackupHead()..mergeFromProto3Json(pending['head']);
      checkRemoteHead(head, kit.id);
      final raw = directoryText(pending['archive'], max: 7 * 1024 * 1024);
      final archive = Uint8List.fromList(base64Decode(raw));
      directoryRequire(archive.length <= DirectoryArchive.maxFile);
      final document = await _document(
        GetBackupResponse(head: head, archive: archive),
        head,
        password,
      );
      directoryRequire((await directory.preview(document)).conflicts.isEmpty);
      final old = await _head(kit, api);
      directoryRequire(
        backupHeadText(old) == backupHeadText(head) ||
            (old.revision.toInt() + 1 == document.revision &&
                old.digest == head.parent),
      );
      _same(
        await api.put(
          PutBackupRequest(
            head: head,
            token: kit.space.writeToken,
            archive: archive,
          ),
        ),
        head,
      );
      await _document(await _get(kit, api, document.revision), head, password);
      _same(await _head(kit, api), head);
      await directory.recordExport(document, selectOutgoing: false);
      state['pending'] = null;
      await _save(state);
    }),
  );
  Future<void> _prepare(
    Map<String, dynamic> state,
    RemoteBackupKit kit,
    String password,
    RemoteBackupApi store,
  ) async {
    final head = await _head(kit, store);
    final local =
        ((await directory.repository.read())['heads'] as Map)[kit.id] as Map?;
    directoryRequire(local != null || head.revision == Int64.ZERO);
    var parent = '';
    if (head.revision > Int64.ZERO) {
      final previous = await _document(
        await _get(kit, store, head.revision.toInt()),
        head,
        password,
      );
      parent = await previous.digest();
    }
    if (local != null) {
      directoryRequire(
        local['revision'] == head.revision.toInt() && local['digest'] == parent,
      );
    }
    final captured = await directory.capture();
    final document = DirectoryDocument.parse({
      ...captured.data,
      'id': kit.id,
      'revision': head.revision.toInt() + 1,
      'parent': parent,
    });
    final archive = await compute(sealDirectoryWorker, (
      document.data,
      password,
    ));
    final next = BackupHead(
      id: kit.id,
      revision: Int64(document.revision),
      parent: head.digest,
      archiveDigest: await remoteBackupHash(archive),
    );
    next.digest = remoteChainDigest(next);
    await _document(
      GetBackupResponse(head: next, archive: archive),
      next,
      password,
    );
    state['pending'] = {
      'head': next.toProto3Json(),
      'archive': base64Encode(archive),
    };
    await _save(state);
  }

  Future<RemoteRestore> preview(RemoteBackupKit kit, String password) =>
      _client(kit, (store) async {
        final head = await _head(kit, store);
        directoryRequire(head.revision > Int64.ZERO);
        final document = await _document(
          await _get(kit, store, head.revision.toInt()),
          head,
          password,
        );
        final ancestors = await _ancestors(
          kit,
          store,
          document,
          head,
          password,
        );
        final plan = await directory.preview(document, ancestors: ancestors);
        _same(await _head(kit, store), head);
        return RemoteRestore._(kit, head, plan);
      });

  Future<List<DirectoryDocument>> _ancestors(
    RemoteBackupKit kit,
    RemoteBackupApi store,
    DirectoryDocument latest,
    BackupHead latestHead,
    String password,
  ) async {
    final local =
        ((await directory.repository.read())['heads'] as Map)[kit.id] as Map?;
    if (local == null) return [];
    final result = <DirectoryDocument>[];
    var child = latest;
    var childHead = latestHead;
    while (child.revision > (local['revision'] as int) + 1) {
      directoryRequire(result.length < 32);
      final response = await _get(kit, store, child.revision - 1);
      checkRemoteHead(response.head, kit.id);
      directoryRequire(
        response.head.digest == childHead.parent &&
            response.head.revision.toInt() == child.revision - 1,
      );
      child = await _document(response, response.head, password);
      childHead = response.head;
      result.add(child);
    }
    return result;
  }

  Future<void> apply(RemoteRestore restore, {required bool replaceSettings}) =>
      _client(restore.kit, (store) async {
        final document = restore.plan.document;
        directoryRequire(
          document.id == restore.head.id &&
              document.revision == restore.head.revision.toInt() &&
              restore.plan.digest == await document.digest(),
        );
        _same(await _head(restore.kit, store), restore.head);
        await directory.apply(restore.plan, replaceSettings: replaceSettings);
        await _settle(restore);
      });

  Future<void> _settle(RemoteRestore restore) =>
      directory.repository.exclusive(() async {
        final state = await _state(), pending = state['pending'];
        if (pending == null ||
            jsonEncode(state['kit']) != jsonEncode(restore.kit.data)) {
          return;
        }
        final data = directoryMap(pending, 'archive,head');
        final head = BackupHead()..mergeFromProto3Json(data['head']);
        checkRemoteHead(head, restore.kit.id);
        if (head.revision > restore.head.revision) return;
        state['pending'] = null;
        await _save(state);
      });
}
