import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'core.dart' show url64;
import 'directory_archive.dart';
import 'directory_document.dart';
import 'remote_backup.dart';
import 'remote_backup_models.dart';
import 'remote_backup_rpc.dart';

part 'remote_backup_cubit.freezed.dart';

@freezed
abstract class RemoteBackupState with _$RemoteBackupState {
  const factory RemoteBackupState({
    @Default(false) bool busy,
    @Default(false) bool replaceSettings,
    @Default('') String message,
    RemoteBackupKit? kit,
    RemoteRestore? restore,
    Object? error,
  }) = _RemoteBackupState;
}

class RemoteBackupCubit extends Cubit<RemoteBackupState> {
  RemoteBackupCubit(this.service) : super(const RemoteBackupState());
  final RemoteBackupService service;
  Future<void> _run(Future<void> Function() action) async {
    if (isClosed || state.busy) return;
    emit(state.copyWith(busy:true,error:null,message:''));
    try { await action(); } catch(error) {
      if (!isClosed) emit(state.copyWith(error:error));
    } finally {
      if (!isClosed) emit(state.copyWith(busy:false));
    }
  }
  void _emit(RemoteBackupState value) { if (!isClosed) emit(value); }
  Future<void> load() => _run(() async => _emit(state.copyWith(kit:await service.savedKit())));
  void replaceSettings(bool value) {
    if (!isClosed && !state.busy) emit(state.copyWith(replaceSettings:value));
  }
  void reset() {
    if (!isClosed && !state.busy) emit(state.copyWith(restore:null,replaceSettings:false,error:null,message:''));
  }
  RemoteBackupEndpoint _endpoint(String origin) {
    final session = service.directory.controllers()[origin]?.mlsSession;
    directoryRequire(session != null);
    final server = session!.server;
    return RemoteBackupEndpoint.create(server.origin.toString(),server.tlsFingerprint,url64(server.publicKey));
  }
  Future<void> setup(String storageOrigin, String witnessOrigin, Future<bool> Function(String) save) => _run(() async {
    final kit = RemoteBackupKit.parse(RemoteBackupKit(url64(DirectoryArchive.random(16)),_endpoint(storageOrigin),_endpoint(witnessOrigin)).encode());
    if (!await save(kit.encode())) return;
    await service.saveKit(kit);
    _emit(state.copyWith(kit:kit,restore:null,replaceSettings:false));
    await _provision(kit);
    _emit(state.copyWith(message:'configured'));
  });
  Future<void> configure() => _run(() async {
    final kit = state.kit;
    directoryRequire(kit != null);
    await _provision(kit!);
    _emit(state.copyWith(message:'configured'));
  });
  Future<void> _provision(RemoteBackupKit kit) async {
    for (final (endpoint,witness) in [(kit.storage,false),(kit.witness,true)]) {
      final session = service.directory.controllers()[endpoint.origin]?.mlsSession;
      directoryRequire(session != null);
      final server = session!.server;
      directoryRequire(server.origin.toString() == endpoint.origin && url64(server.publicKey) == endpoint.publicKey && server.tlsFingerprint.toLowerCase() == endpoint.fingerprint);
      await provisionRemoteBackup(session,CreateBackupSlotRequest(id:kit.id,witness:witness,readHash:await _hash(endpoint.readToken),writeHash:await _hash(endpoint.writeToken)));
    }
  }
  Future<List<int>> _hash(String value) async {
    // Сервер хранит SHA-256 точной UTF-8 capability, не её декодированных байтов.
    return (await Sha256().hash(utf8.encode(value))).bytes;
  }
  Future<void> importKit(String raw) => _run(() async {
    final kit = RemoteBackupKit.parse(raw);
    await service.saveKit(kit);
    _emit(state.copyWith(kit:kit,restore:null,replaceSettings:false));
  });
  Future<void> publish(String password) => _run(() async {
    final kit = state.kit;
    directoryRequire(kit != null);
    _emit(state.copyWith(restore:null,replaceSettings:false));
    await service.publish(kit!,password);
    _emit(state.copyWith(message:'saved'));
  });
  Future<void> preview(String password) => _run(() async {
    final kit = state.kit;
    directoryRequire(kit != null);
    _emit(state.copyWith(restore:null,replaceSettings:false));
    final restore = await service.preview(kit!,password);
    _emit(state.copyWith(restore:restore,message:'preview'));
  });
  Future<void> apply() => _run(() async {
    final restore = state.restore;
    if (restore == null || restore.plan.conflicts.isNotEmpty) return;
    await service.apply(restore,replaceSettings:state.replaceSettings);
    _emit(state.copyWith(restore:null,message:'restored'));
  });
}
