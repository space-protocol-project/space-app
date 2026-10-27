import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/directory_transfer_noise.dart';
import 'package:space_client/src/directory_transfer_qr.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_directory_noise/space_directory_noise.dart';

import 'fixtures/directory.dart';

Future<(DirectoryNoiseChannel,DirectoryNoiseChannel)> channels() async {
  const engine = NativeDirectoryNoise();
  final receiver = await DirectoryNoiseChannel.open(engine, initiator: true, context: 'context');
  final source = await DirectoryNoiseChannel.open(engine, initiator: false, context: 'context', expected: receiver.public);
  addTearDown(receiver.close);
  addTearDown(source.close);
  await source.readHandshake(await receiver.writeHandshake());
  await receiver.readHandshake(await source.writeHandshake());
  await source.readHandshake(await receiver.writeHandshake());
  expect(source.sas, receiver.sas);
  return (receiver,source);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Настоящий Noise через FFI: без двух подтверждений каталог недоступен', () async {
    final (receiver,source)=await channels();
    await expectLater(source.seal([1,2,3]), throwsStateError);
    // Любая ошибка закрывает handle: повторяем всю попытку с новыми ключами.
    await expectLater(source.confirm(source.sas), throwsStateError);
    final (r,s)=await channels();
    await r.confirm(r.sas);
    await s.confirm(s.sas);
    await s.receiveConfirmation(await r.confirmation());
    final plain=directoryDocument().encode();
    final frames=await s.seal(plain);
    expect(frames.any((frame)=>utf8.decode(frame,allowMalformed:true).contains('space.example')), isFalse);
    expect(await r.openDirectory(frames), plain);
    await s.receiveReceipt(await r.receipt());
    await expectLater(r.openDirectory(frames), throwsStateError);
    expect(receiver.sas, isNotEmpty);
  });
  test('Изменение шифротекста закрывает FFI handle и не возвращает частичный каталог', () async {
    final (r,s)=await channels();
    await r.confirm(r.sas);await s.confirm(s.sas);
    await s.receiveConfirmation(await r.confirmation());
    final frames=await s.seal(List.filled(130000,42));
    frames[2][20]^=1;
    await expectLater(r.openDirectory(frames), throwsStateError);
    await expectLater(r.receipt(), throwsStateError);
  });
  test('QR привязан к уже выбранному серверу и не содержит owner token', () {
    final server=Discovery(Uri.parse('https://space.example'),'srv_example',List.filled(32,2));
    final qr=DirectoryTransferQr(server.origin.toString(),server.serverId,url64(server.publicKey),'',
      'dt_${'a'*43}','dc_${'b'*43}',url64(List.filled(32,3)),DateTime.now().millisecondsSinceEpoch~/1000+300);
    final parsed=DirectoryTransferQr.parse(qr.encode());
    parsed.checkServer(server);
    expect(parsed.context,qr.context);
    expect(qr.encode().contains('dr_'),isFalse);
    expect(()=>parsed.checkServer(Discovery(server.origin,'attacker',server.publicKey)),throwsFormatException);
    expect(()=>DirectoryTransferQr.parse('${qr.encode()}garbage'), throwsFormatException);
  });
  test('Выбор каталога исключает лишние пространства и не продвигает цепочку файловых копий', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences=AppPreferences();addTearDown(preferences.close);
    final repository=DirectoryRepository(DirectoryStorage());
    final service=DirectoryBackupService(repository,DirectoryVault(),preferences,()=>{});
    await service.apply(await service.preview(directoryDocument()),replaceSettings:false);
    await service.recordExport(await service.capture());
    final before=await repository.read();
    final first=await service.capture(selectedOrigins:['https://space.example']);
    final second=await service.capture(selectedOrigins:['https://space.example']);
    expect(first.revision,1);expect(first.parent,isEmpty);expect(first.id,isNot(second.id));
    expect(await repository.read(),before);
    await expectLater(service.capture(selectedOrigins:[]),throwsFormatException);
    await expectLater(service.capture(selectedOrigins:['https://unknown.example']),throwsFormatException);
    await expectLater(service.capture(selectedOrigins:List.filled(2,'https://space.example')),throwsFormatException);
  });
}
