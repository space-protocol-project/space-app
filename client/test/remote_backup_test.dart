import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_models.dart';

import 'fixtures/directory.dart';
import 'fixtures/remote_backup.dart';

const backupPassword='длинный отдельный пароль';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DirectoryStorage storage;
  late DirectoryBackupService directory;
  late AppPreferences preferences;
  late RemoteBackupKit kit;
  late MemoryBackupApi store,witness;
  late RemoteBackupService remote;
  RemoteBackupService connectService(DirectoryBackupService service) => RemoteBackupService(service,connect:(endpoint) => endpoint.origin == kit.storage.origin ? store : witness);
  DirectoryBackupService fresh() {
    final prefs=AppPreferences(); addTearDown(prefs.close);
    return DirectoryBackupService(DirectoryRepository(DirectoryStorage()),DirectoryVault(),prefs,() => {});
  }
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage=DirectoryStorage(); preferences=AppPreferences();
    addTearDown(preferences.close);
    directory=DirectoryBackupService(DirectoryRepository(storage),DirectoryVault(),preferences,() => {});
    (kit,store,witness)=await memoryBackupNetwork();
    remote=connectService(directory);
    await directory.apply(await directory.preview(directoryDocument()),replaceSettings:true);
    await remote.saveKit(kit);
  });
  test('Комплект строгий, отдельные credentials и независимые endpoints обязательны',() async {
    final encoded=kit.encode();
    expect(encoded, isNot(contains(backupPassword)));
    expect(RemoteBackupKit.parse(encoded).id,kit.id);
    for (final field in ['kind','v','id','storage','witness']) {
      final data=jsonDecode(encoded) as Map<String,dynamic>;
      data.remove(field);
      expect(() => RemoteBackupKit.parse(jsonEncode(data)),throwsFormatException);
    }
    final data=jsonDecode(encoded) as Map<String,dynamic>;
    data['extra']=true;
    expect(() => RemoteBackupKit.parse(jsonEncode(data)),throwsFormatException);
    final endpoints=jsonDecode(encoded) as Map<String,dynamic>;
    endpoints['witness']=endpoints['storage'];
    expect(() => RemoteBackupKit.parse(jsonEncode(endpoints)),throwsFormatException);
  });
  test('Публикация проверяет контейнер и свидетель; чистое устройство требует явного применения',() async {
    await remote.publish(kit,backupPassword);
    expect(store.versions,hasLength(1)); expect(witness.head.revision.toInt(),1);
    expect(utf8.decode(store.versions[1]!.archive,allowMalformed:true),isNot(contains('space.example')));
    final target=fresh(), recovery=connectService(target);
    final plan=await recovery.preview(kit,backupPassword);
    expect(target.preferences.origins,isEmpty);
    expect(plan.plan.conflicts,isEmpty);
    await recovery.apply(plan,replaceSettings:false);
    expect(target.preferences.origins,['https://space.example']);
    expect(target.preferences.palette,'gruvbox');
    expect((target.vault as DirectoryVault).records,isEmpty);
  });
  test('Потерянный ответ загрузки сохраняет точные байты; холодный повтор завершает ту же ревизию',() async {
    store.failPut=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    final bytes=List.of(store.versions[1]!.archive);
    expect(witness.head.revision.toInt(),0);
    await expectLater(remote.preview(kit,backupPassword),throwsFormatException);
    final resumed=connectService(directory);
    await expectLater(resumed.publish(kit,'другой длинный пароль'),throwsA(anything));
    await resumed.publish(kit,backupPassword);
    expect(store.versions[1]!.archive,bytes);
    expect(store.versions,hasLength(1)); expect(witness.head.revision.toInt(),1);
    expect((jsonDecode(storage.values[RemoteBackupService.storageKey]!) as Map)['pending'],isNull);
  });
  test('Потерянный ответ свидетеля не создаёт новую копию',() async {
    witness.failAdvance=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    expect(witness.head.revision.toInt(),1);
    await connectService(directory).publish(kit,backupPassword);
    expect(store.versions,hasLength(1));
    expect((await directory.repository.read())['outgoing'],kit.id);
  });
  test('Недоступный свидетель, подмена подписи/challenge и контейнера блокируют preview',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    witness.unavailable=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsStateError);
    witness.unavailable=false; witness.badSignature=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    witness.badSignature=false; witness.badChallenge=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    witness.badChallenge=false;
    store.versions[1]!.archive[0]^=1;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    expect(target.preferences.origins,isEmpty);
    expect((await target.repository.read())['catalog'],isEmpty);
  });
  test('Новый head между preview и применением блокирует старый план',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    final plan=await recovery.preview(kit,backupPassword);
    await remote.publish(kit,backupPassword);
    await expectLater(recovery.apply(plan,replaceSettings:true),throwsFormatException);
    expect(target.preferences.origins,isEmpty);
  });
  test('Несколько ревизий проверяются цепочкой, а откат свидетеля не обходит локальный head',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    await recovery.apply(await recovery.preview(kit,backupPassword),replaceSettings:false);
    final old=witness.head.deepCopy();
    await remote.publish(kit,backupPassword);
    await remote.publish(kit,backupPassword);
    final plan=await recovery.preview(kit,backupPassword);
    expect(plan.plan.ancestors,hasLength(1)); expect(plan.plan.conflicts,isEmpty);
    await recovery.apply(plan,replaceSettings:false);
    witness.head=old;
    final rollback=await recovery.preview(kit,backupPassword);
    expect(rollback.plan.conflicts,isNotEmpty);
    await expectLater(recovery.apply(rollback,replaceSettings:false),throwsFormatException);
  });
  test('Ошибка защищённого журнала происходит до загрузки контейнера',() async {
    storage.fail=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    expect(store.versions,isEmpty); expect(witness.head.revision.toInt(),0);
  });
}
