import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_models.dart';
import 'package:space_client/src/remote_backup_rpc.dart';

class MemoryBackupApi implements RemoteBackupApi {
  MemoryBackupApi(this.kit,this.key) : head=BackupHead(id:kit.id);
  final RemoteBackupKit kit;
  final SimpleKeyPair key;
  BackupHead head;
  final versions=<int,GetBackupResponse>{};
  bool failPut=false,badSignature=false,badChallenge=false,unavailable=false;
  void token(String value,bool write) {
    if(unavailable || value != (write ? kit.space.writeToken : kit.space.readToken)) throw StateError('Недоступно');
  }
  @override
  Future<BackupHead> put(PutBackupRequest request) async {
    token(request.token,true);
    final previous=versions[request.head.revision.toInt()];
    if(previous != null && backupHeadText(previous.head) != backupHeadText(request.head)) throw StateError('Конфликт');
    versions[request.head.revision.toInt()]=GetBackupResponse(head:request.head.deepCopy(),archive:List.of(request.archive));
    head=request.head.deepCopy();
    if(failPut) { failPut=false; throw StateError('Ответ после commit потерян'); }
    return head.deepCopy();
  }
  @override
  Future<GetBackupResponse> get(GetBackupRequest request) async {
    token(request.token,false);
    final result=versions[request.revision.toInt()];
    if(result == null) throw const GrpcError.notFound();
    return result.deepCopy();
  }
  @override
  Future<ReadBackupHeadResponse> read(ReadBackupHeadRequest request) async {
    token(request.token,false);
    final challenge=badChallenge ? url64(List.filled(32,9)) : request.challenge;
    final signature=List.of((await Ed25519().sign(backupHeadProof(head,challenge),keyPair:key)).bytes);
    if(badSignature) signature[0]^=1;
    return ReadBackupHeadResponse(head:head.deepCopy(),challenge:challenge,signature:signature);
  }
  @override
  Future<void> close() async {}
}
Future<(RemoteBackupKit,MemoryBackupApi)> memoryBackupNetwork() async {
  final key=await Ed25519().newKeyPairFromSeed(List.filled(32,11));
  final kit=RemoteBackupKit.parse(jsonEncode({
    'v':1,'kind':'space.remote-backup','id':url64(List.filled(16,7)),
    'space':{'origin':'https://space.example','tls':'a'*64,'key':url64((await key.extractPublicKey()).bytes),'read':url64(List.filled(32,1)),'write':url64(List.filled(32,2))},
  }));
  return (kit,MemoryBackupApi(kit,key));
}