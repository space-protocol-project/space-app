import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_directory_noise/space_directory_noise.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/directory_transfer.dart';
import 'package:space_client/src/directory_transfer_rpc.dart';
import 'package:space_client/src/preferences.dart';

import 'fixtures/directory.dart';

class DirectoryNetworkBinding extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}

class RecordingRelay extends RpcDirectoryRelay {
  RecordingRelay(super.server);
  final records=<List<int>>[];
  bool loseFirstReply=true;
  @override
  Future<void> write(WriteDirectoryFrameRequest request) async {
    records.add(List.of(request.data));
    await super.write(request);
    if (loseFirstReply) {
      loseFirstReply=false;
      throw const SocketException('Проверка потерянного ответа после commit');
    }
  }
}

void main() {
  DirectoryNetworkBinding();
  const origin=String.fromEnvironment('DIRECTORY_RELAY');
  const marker=String.fromEnvironment('DIRECTORY_RESTART');
  test('Два настоящих Noise клиента, Connect relay, перезапуск и явное применение', () async {
    SharedPreferences.setMockInitialValues({});
    final server=await discover(origin);
    final sourcePrefs=AppPreferences(), targetPrefs=AppPreferences();
    addTearDown(sourcePrefs.close);addTearDown(targetPrefs.close);
    final sourceRepo=DirectoryRepository(DirectoryStorage()), targetRepo=DirectoryRepository(DirectoryStorage());
    final sourceService=DirectoryBackupService(sourceRepo,DirectoryVault(),sourcePrefs,()=>{});
    final targetVault=DirectoryVault();
    final targetService=DirectoryBackupService(targetRepo,targetVault,targetPrefs,()=>{});
    await sourceService.apply(await sourceService.preview(directoryDocument(count:3)),replaceSettings:true);
    final document=await sourceService.capture(selectedOrigins:['https://space.example']);
    final sourceRelay=RecordingRelay(server), targetRelay=RecordingRelay(server);
    const engine=NativeDirectoryNoise();
    final source=DirectoryTransfer(server,sourceRelay,engine), target=DirectoryTransfer(server,targetRelay,engine);
    addTearDown(source.close);addTearDown(target.close);
    final qr=await target.receiveStart();
    await Future.wait([source.sendStart(qr),target.receiveHandshake()]);
    expect(sourceRelay.records[0],sourceRelay.records[1]);
    expect(targetRelay.records[0],targetRelay.records[1]);
    expect(source.sas,target.sas);expect(source.sas.length,24);
    await File('$marker.ready').writeAsString('ready');
    final deadline=DateTime.now().add(const Duration(seconds:60));
    while (!await File('$marker.resume').exists()) {
      if (DateTime.now().isAfter(deadline)) throw TimeoutException('restart');
      await Future<void>.delayed(const Duration(milliseconds:100));
    }
    final sending=source.send(target.sas,document);
    final plan=await target.receive(targetService);
    await sending;
    expect(targetPrefs.origins,isEmpty);expect(targetVault.records,isEmpty);
    expect(plan.conflicts,isEmpty);expect(plan.document.spaces.single['following'],hasLength(3));
    final wire=[...sourceRelay.records,...targetRelay.records];
    expect(wire.any((record)=>utf8.decode(record,allowMalformed:true).contains('space.example')),isFalse);
    await targetService.apply(plan,replaceSettings:false);
    expect(targetPrefs.origins,['https://space.example']);
    expect(targetPrefs.palette,'gruvbox');expect(targetVault.records,isEmpty);
    expect((await targetRepo.read())['pending'],isNull);
    // Успешный receipt удаляет relay; ключи/сессии и device grant не импортируются.
    final other=RpcDirectoryRelay(server);addTearDown(other.dispose);
    await expectLater(other.open(OpenDirectoryTransferRequest(code:qr.code)),throwsA(anything));
  }, skip:origin.isEmpty, timeout:const Timeout(Duration(minutes:4)));
}
