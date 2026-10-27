import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/remote_backup.dart';
import 'package:space_client/src/remote_backup_models.dart';
import 'fixtures/directory.dart';
import 'fixtures/remote_backup.dart';

const backupPassword='длинный отдельный пароль';
void backupTest(String name,Future<void> Function() body) => test(name,body,timeout:const Timeout(Duration(minutes:4)));
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late DirectoryStorage storage;
  late DirectoryBackupService directory;
  late RemoteBackupKit kit;
  late MemoryBackupApi api;
  late RemoteBackupService remote;
  RemoteBackupService connectService(DirectoryBackupService value) => RemoteBackupService(value,connect:(_) => api);
  DirectoryBackupService fresh() {
    final preferences=AppPreferences(); addTearDown(preferences.close);
    return DirectoryBackupService(DirectoryRepository(DirectoryStorage()),DirectoryVault(),preferences,() => {});
  }
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage=DirectoryStorage();
    final preferences=AppPreferences(); addTearDown(preferences.close);
    directory=DirectoryBackupService(DirectoryRepository(storage),DirectoryVault(),preferences,() => {});
    (kit,api)=await memoryBackupNetwork();
    remote=connectService(directory);
    await directory.apply(await directory.preview(directoryDocument()),replaceSettings:true);
    await remote.saveKit(kit);
  });
  backupTest('Комплект содержит ровно одно пространство и два разных ключа доступа',() async {
    expect(RemoteBackupKit.parse(kit.encode()).space.origin,'https://space.example');
    final fields=jsonDecode(kit.encode()) as Map<String,dynamic>;
    for(final field in ['kind','v','id','space']) {
      final invalid=Map<String,dynamic>.from(fields)..remove(field);
      expect(() => RemoteBackupKit.parse(jsonEncode(invalid)),throwsFormatException);
    }
    fields['witness']=fields['space'];
    expect(() => RemoteBackupKit.parse(jsonEncode(fields)),throwsFormatException);
    expect(kit.encode(),isNot(contains(backupPassword)));
  });
  backupTest('Один сервер пространства сохраняет копию; применение отдельно и без рабочих ключей',() async {
    await remote.publish(kit,backupPassword);
    expect(api.versions,hasLength(1));
    final target=fresh(), recovery=connectService(target);
    final plan=await recovery.preview(kit,backupPassword);
    expect(plan.plan.unknown,isTrue);
    expect(target.preferences.origins,isEmpty);
    await recovery.apply(plan,replaceSettings:false);
    expect(target.preferences.origins,['https://space.example']);
    expect(target.preferences.palette,'gruvbox');
    expect((target.vault as DirectoryVault).records,isEmpty);
  });
  backupTest('Потеря ответа не отделяет контейнер от головы; чистый профиль уже может восстановиться',() async {
    api.failPut=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    final bytes=List.of(api.versions[1]!.archive);
    expect(api.head.revision.toInt(),1);
    final target=fresh(), recovery=connectService(target);
    final plan=await recovery.preview(kit,backupPassword);
    await recovery.apply(plan,replaceSettings:false);
    expect(target.preferences.origins,['https://space.example']);
    await expectLater(connectService(directory).publish(kit,'другой длинный пароль'),throwsA(anything));
    await connectService(directory).publish(kit,backupPassword);
    expect(api.versions[1]!.archive,bytes);
    expect(api.versions,hasLength(1));
  });
  backupTest('После явного восстановления очищается покрытая им очередь публикации',() async {
    api.failPut=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    await remote.apply(await remote.preview(kit,backupPassword),replaceSettings:false);
    expect((jsonDecode(storage.values[RemoteBackupService.storageKey]!) as Map)['pending'],isNull);
    await remote.publish(kit,backupPassword);
    expect(api.head.revision.toInt(),2);
  });
  backupTest('Подмена подписи, challenge, ciphertext и недоступность пространства блокируют восстановление',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    api.unavailable=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsStateError);
    api.unavailable=false; api.badSignature=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    api.badSignature=false; api.badChallenge=true;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    api.badChallenge=false;
    api.versions[1]!.archive[0]^=1;
    await expectLater(recovery.preview(kit,backupPassword),throwsFormatException);
    expect(target.preferences.origins,isEmpty);
  });
  backupTest('Изменение версии после preview блокирует применение',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    final plan=await recovery.preview(kit,backupPassword);
    await remote.publish(kit,backupPassword);
    await expectLater(recovery.apply(plan,replaceSettings:true),throwsFormatException);
    expect(target.preferences.origins,isEmpty);
  });
  backupTest('Известный откат отклоняется; пропущенные ревизии проверяются цепочкой',() async {
    await remote.publish(kit,backupPassword);
    final target=fresh(), recovery=connectService(target);
    await recovery.apply(await recovery.preview(kit,backupPassword),replaceSettings:false);
    final old=api.head.deepCopy();
    await remote.publish(kit,backupPassword); await remote.publish(kit,backupPassword);
    final plan=await recovery.preview(kit,backupPassword);
    expect(plan.plan.ancestors,hasLength(1));
    expect(plan.plan.conflicts,isEmpty);
    await recovery.apply(plan,replaceSettings:false);
    api.head=old;
    final rollback=await recovery.preview(kit,backupPassword);
    expect(rollback.plan.conflicts,isNotEmpty);
    await expectLater(recovery.apply(rollback,replaceSettings:false),throwsFormatException);
    final clean=await connectService(fresh()).preview(kit,backupPassword);
    expect(clean.plan.unknown,isTrue);
  });
  backupTest('Ошибка защищённой записи происходит до загрузки',() async {
    storage.fail=true;
    await expectLater(remote.publish(kit,backupPassword),throwsStateError);
    expect(api.versions,isEmpty);
  });
  backupTest('Наружу передаются хеши ciphertext, локальные файловые цепочки независимы',() async {
    final local=await directory.capture(); await directory.recordExport(local);
    await remote.publish(kit,backupPassword);
    final first=await remote.preview(kit,backupPassword);
    expect(first.head.digest,isNot(first.plan.digest));
    final next=await directory.capture();
    expect(next.id,local.id); expect(next.revision,2);
    await directory.recordExport(next);
    await expectLater(remote.publish(kit,'другой длинный пароль цепочки'),throwsA(anything));
    expect(api.versions,hasLength(1));
    await remote.publish(kit,backupPassword);
    final second=await remote.preview(kit,backupPassword);
    expect(second.head.parent,first.head.digest);
    expect(second.plan.document.parent,first.plan.digest);
    expect(backupHeadText(second.head),isNot(contains(first.plan.digest)));
  });
}