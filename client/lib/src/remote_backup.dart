import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart' show compute;

import 'core.dart' show url64;
import 'directory_archive.dart';
import 'directory_backup.dart';
import 'directory_backup_cubit.dart' show openDirectoryWorker, sealDirectoryWorker;
import 'directory_document.dart';
import 'remote_backup_models.dart';
import 'remote_backup_rpc.dart';

String backupHeadText(BackupHead head) => jsonEncode([
  head.id, head.revision.toInt(), head.digest, head.parent, head.archiveDigest,
]);

void checkRemoteHead(BackupHead head, String id) {
  directoryRequire(head.id == id);
  final revision = directoryInt(head.revision.toInt());
  if (revision == 0) {
    directoryRequire(head.digest.isEmpty && head.parent.isEmpty && head.archiveDigest.isEmpty);
    return;
  }
  directoryBytes(head.digest, 32);
  directoryBytes(head.archiveDigest, 32);
  if (revision == 1) {
    directoryRequire(head.parent.isEmpty);
  } else {
    directoryBytes(head.parent, 32);
  }
}

List<int> backupWitnessText(BackupHead h, String challenge) => utf8.encode(
  'space/backup-witness/v1\n$challenge\n${h.id}\n${h.revision}\n${h.digest}\n${h.parent}\n${h.archiveDigest}',
);

Future<String> remoteBackupHash(List<int> bytes) async => url64((await Sha256().hash(bytes)).bytes);

class RemoteRestore {
  RemoteRestore(this.kit, this.head, this.plan);
  final RemoteBackupKit kit;
  final BackupHead head;
  final DirectoryRestorePlan plan;
}

class RemoteBackupService {
  RemoteBackupService(this.directory, {RemoteBackupApi Function(RemoteBackupEndpoint)? connect})
      : connect = connect ?? RpcRemoteBackup.new;
  final DirectoryBackupService directory;
  final RemoteBackupApi Function(RemoteBackupEndpoint) connect;
  static const storageKey = 'space.directory.remote.v1';

  Future<Map<String,dynamic>> _state() async {
    final raw = await directory.repository.storage.read(key: storageKey);
    if (raw == null) return {'v':1,'kit':null,'pending':null};
    directoryRequire(utf8.encode(raw).length <= 8*1024*1024);
    final data = directoryMap(jsonDecode(raw),'kit,pending,v');
    directoryInt(data['v'],min:1,max:1);
    if (data['kit'] != null) RemoteBackupKit.parse(jsonEncode(data['kit']));
    return data;
  }
  Future<void> _save(Map<String,dynamic> data) async {
    final raw = jsonEncode(data);
    directoryRequire(utf8.encode(raw).length <= 8*1024*1024);
    final storage = directory.repository.storage;
    await storage.write(key:storageKey,value:raw);
    directoryRequire(await storage.read(key:storageKey) == raw);
  }
  Future<RemoteBackupKit?> savedKit() async {
    final value = (await _state())['kit'];
    return value == null ? null : RemoteBackupKit.parse(jsonEncode(value));
  }
  Future<void> saveKit(RemoteBackupKit kit) => directory.repository.exclusive(() async {
    final state = await _state();
    directoryRequire(state['pending'] == null);
    state['kit'] = RemoteBackupKit.parse(kit.encode()).data;
    await _save(state);
  });

  Future<T> _clients<T>(RemoteBackupKit kit, Future<T> Function(RemoteBackupApi, RemoteBackupApi) action) async {
    RemoteBackupKit.parse(kit.encode());
    final store = connect(kit.storage);
    try {
      final witness = connect(kit.witness);
      try { return await action(store,witness); } finally { await witness.close(); }
    } finally { await store.close(); }
  }
  Future<BackupHead> _witness(RemoteBackupKit kit, RemoteBackupApi api) async {
    final challenge = url64(DirectoryArchive.random(32));
    final result = await api.read(ReadBackupWitnessRequest(id:kit.id,token:kit.witness.readToken,challenge:challenge));
    directoryRequire(result.challenge == challenge && result.hasHead());
    checkRemoteHead(result.head,kit.id);
    final valid = await Ed25519().verify(
      backupWitnessText(result.head,challenge),
      signature:Signature(result.signature,publicKey:SimplePublicKey(base64Url.decode(base64Url.normalize(kit.witness.publicKey)),type:KeyPairType.ed25519)),
    );
    directoryRequire(valid);
    return result.head;
  }
  void _same(BackupHead a, BackupHead b) => directoryRequire(backupHeadText(a) == backupHeadText(b));

  Future<DirectoryDocument> _document(GetBackupResponse response, BackupHead head, String password) async {
    directoryRequire(response.hasHead() && response.archive.length <= DirectoryArchive.maxFile);
    _same(response.head,head);
    directoryRequire(await remoteBackupHash(response.archive) == head.archiveDigest);
    final document = DirectoryDocument.parse(await compute(openDirectoryWorker,(Uint8List.fromList(response.archive),password)));
    directoryRequire(document.id == head.id && document.revision == head.revision.toInt() && document.parent == head.parent && await document.digest() == head.digest);
    return document;
  }
  Future<GetBackupResponse> _get(RemoteBackupKit kit, RemoteBackupApi store, int revision) => store.get(GetBackupRequest(id:kit.id,token:kit.storage.readToken,revision:Int64(revision)));

  Future<void> publish(RemoteBackupKit kit, String password) => directory.repository.exclusive(() => _clients(kit,(store,witness) async {
    final state = await _state();
    directoryRequire(jsonEncode(state['kit']) == jsonEncode(kit.data));
    if (state['pending'] == null) {
      await _prepare(state,kit,password,witness);
    }
    final pending = directoryMap(state['pending'],'archive,head');
    final head = BackupHead.fromProto3Json(pending['head']);
    checkRemoteHead(head,kit.id);
    final raw = directoryText(pending['archive'],max:7*1024*1024);
    final archive = Uint8List.fromList(base64Decode(raw));
    directoryRequire(archive.length <= DirectoryArchive.maxFile);
    final document = await _document(GetBackupResponse(head:head,archive:archive),head,password);
    final old = await _witness(kit,witness);
    directoryRequire(backupHeadText(old) == backupHeadText(head) || (old.revision.toInt()+1 == document.revision && old.digest == document.parent));
    _same(await store.put(PutBackupRequest(head:head,token:kit.storage.writeToken,archive:archive)),head);
    await _document(await _get(kit,store,document.revision),head,password);
    _same(await witness.advance(AdvanceBackupWitnessRequest(head:head,token:kit.witness.writeToken)),head);
    _same(await _witness(kit,witness),head);
    await directory.recordExport(document);
    state['pending'] = null;
    await _save(state);
  }));

  Future<void> _prepare(Map<String,dynamic> state, RemoteBackupKit kit, String password, RemoteBackupApi witness) async {
    final head = await _witness(kit,witness);
    final local = ((await directory.repository.read())['heads'] as Map)[kit.id] as Map?;
    if (local != null) {
      directoryRequire(local['revision'] == head.revision.toInt() && local['digest'] == head.digest);
    }
    final captured = await directory.capture();
    final document = DirectoryDocument.parse({...captured.data,'id':kit.id,'revision':head.revision.toInt()+1,'parent':head.digest});
    final archive = await compute(sealDirectoryWorker,(document.data,password));
    final next = BackupHead(id:kit.id,revision:Int64(document.revision),digest:await document.digest(),parent:document.parent,archiveDigest:await remoteBackupHash(archive));
    await _document(GetBackupResponse(head:next,archive:archive),next,password);
    state['pending'] = {'head':next.toProto3Json(),'archive':base64Encode(archive)};
    await _save(state);
  }

  Future<RemoteRestore> preview(RemoteBackupKit kit, String password) => _clients(kit,(store,witness) async {
    final head = await _witness(kit,witness);
    directoryRequire(head.revision > Int64.ZERO);
    final document = await _document(await _get(kit,store,head.revision.toInt()),head,password);
    final ancestors = await _ancestors(kit,store,document,password);
    final plan = await directory.preview(document,ancestors:ancestors);
    _same(await _witness(kit,witness),head);
    return RemoteRestore(kit,head,plan);
  });

  Future<List<DirectoryDocument>> _ancestors(RemoteBackupKit kit, RemoteBackupApi store, DirectoryDocument latest, String password) async {
    final local = ((await directory.repository.read())['heads'] as Map)[kit.id] as Map?;
    if (local == null) return [];
    final result = <DirectoryDocument>[];
    var child = latest;
    while (child.revision > (local['revision'] as int)+1) {
      directoryRequire(result.length < 32);
      final response = await _get(kit,store,child.revision-1);
      checkRemoteHead(response.head,kit.id);
      directoryRequire(response.head.digest == child.parent && response.head.revision.toInt() == child.revision-1);
      child = await _document(response,response.head,password);
      result.add(child);
    }
    return result;
  }

  Future<void> apply(RemoteRestore restore, {required bool replaceSettings}) => _clients(restore.kit,(store,witness) async {
    _same(await _witness(restore.kit,witness),restore.head);
    await directory.apply(restore.plan,replaceSettings:replaceSettings);
  });
}
