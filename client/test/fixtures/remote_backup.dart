import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_models.dart';
import 'package:space_client/src/remote_backup_rpc.dart';

class MemoryBackupApi implements RemoteBackupApi {
  MemoryBackupApi(this.kit, this.key, {required this.witness})
    : head = BackupHead(id: kit.id);
  final RemoteBackupKit kit;
  final SimpleKeyPair key;
  final bool witness;
  BackupHead head;
  final versions = <int, GetBackupResponse>{};
  bool failPut = false,
      failAdvance = false,
      badSignature = false,
      badChallenge = false,
      unavailable = false;
  int reads = 0;
  RemoteBackupEndpoint get endpoint => witness ? kit.witness : kit.storage;
  void token(String value, bool write) {
    if (unavailable ||
        value != (write ? endpoint.writeToken : endpoint.readToken)) {
      throw StateError('Недоступно');
    }
  }

  @override
  Future<BackupHead> put(PutBackupRequest request) async {
    token(request.token, true);
    final previous = versions[request.head.revision.toInt()];
    if (previous != null &&
        backupHeadText(previous.head) != backupHeadText(request.head)) {
      throw StateError('Конфликт');
    }
    versions[request.head.revision.toInt()] = GetBackupResponse(
      head: request.head.deepCopy(),
      archive: List.of(request.archive),
    );
    head = request.head.deepCopy();
    if (failPut) {
      failPut = false;
      throw StateError('Ответ после commit потерян');
    }
    return head.deepCopy();
  }

  @override
  Future<GetBackupResponse> get(GetBackupRequest request) async {
    token(request.token, false);
    return versions[request.revision.toInt()]!.deepCopy();
  }

  @override
  Future<BackupHead> advance(AdvanceBackupWitnessRequest request) async {
    token(request.token, true);
    if (backupHeadText(head) != backupHeadText(request.head)) {
      if (request.head.revision != head.revision + 1 ||
          request.head.parent != head.digest) {
        throw StateError('Конфликт');
      }
      head = request.head.deepCopy();
    }
    if (failAdvance) {
      failAdvance = false;
      throw StateError('Ответ свидетеля потерян');
    }
    return head.deepCopy();
  }

  @override
  Future<ReadBackupWitnessResponse> read(
    ReadBackupWitnessRequest request,
  ) async {
    token(request.token, false);
    reads++;
    final challenge = badChallenge
        ? url64(List.filled(32, 9))
        : request.challenge;
    final signed = await Ed25519().sign(
      backupWitnessText(head, challenge),
      keyPair: key,
    );
    final signature = List.of(signed.bytes);
    if (badSignature) signature[0] ^= 1;
    return ReadBackupWitnessResponse(
      head: head.deepCopy(),
      challenge: challenge,
      signature: signature,
    );
  }

  @override
  Future<void> close() async {}
}

Future<(RemoteBackupKit, MemoryBackupApi, MemoryBackupApi)>
memoryBackupNetwork() async {
  final key = await Ed25519().newKeyPairFromSeed(List.filled(32, 11));
  final public = url64((await key.extractPublicKey()).bytes);
  final kit = RemoteBackupKit.parse(
    jsonEncode({
      'v': 1,
      'kind': 'space.remote-backup',
      'id': url64(List.filled(16, 7)),
      'storage': {
        'origin': 'https://storage.example',
        'tls': 'a' * 64,
        'key': url64(List.filled(32, 4)),
        'read': url64(List.filled(32, 1)),
        'write': url64(List.filled(32, 2)),
      },
      'witness': {
        'origin': 'https://witness.example',
        'tls': 'b' * 64,
        'key': public,
        'read': url64(List.filled(32, 3)),
        'write': url64(List.filled(32, 5)),
      },
    }),
  );
  return (
    kit,
    MemoryBackupApi(kit, key, witness: false),
    MemoryBackupApi(kit, key, witness: true),
  );
}
