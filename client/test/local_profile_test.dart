import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/local_profile_record.dart';
import 'package:space_client/src/extensions_p1/local_profile_verifier.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';

import 'fixtures/directory.dart';

const password = 'local profile password';
Matcher failure(LocalProfileFailure value) => throwsA(
  isA<LocalProfileException>().having((e) => e.failure, 'failure', value),
);

class PausedStorage extends DirectoryStorage {
  Completer<void>? pause;
  bool discard = false;
  @override
  Future<void> write({required String key, required String value}) async {
    await pause?.future;
    if (!discard) await super.write(key: key, value: value);
  }
}

void main() {
  late Directory directory;
  late PausedStorage storage;
  late LocalProfileVerifier service;
  var now = DateTime.utc(2026, 11, 4);
  LocalProfileVerifier reopen() => LocalProfileVerifier(
    storage,
    lockPath: () async => '${directory.path}/profile.lock',
    now: () => now,
  );
  Future<LocalProfileIdentity> verify(String secret, {bool create = false}) =>
      service.verify(secret, create: create, active: () => true);
  setUp(() {
    directory = Directory.systemTemp.createTempSync('profile-');
    storage = PausedStorage();
    service = reopen();
  });
  tearDown(() => directory.deleteSync(recursive: true));

  test(
    'настоящий KDF, стабильный профиль, неверный пароль не выдаёт сессию',
    () async {
      expect(await service.hasProfile(), false);
      final identity = await verify(password, create: true);
      expect(storage.values.values.single, isNot(contains(password)));
      service = reopen();
      expect(await service.hasProfile(), true);
      var supplied = 'wrong password';
      final access = LocalSessionCubit(authenticate: () => verify(supplied))
        ..setForeground(true);
      expect(await access.unlock(), false);
      expect(() => access.session, throwsStateError);
      supplied = password;
      expect(await access.unlock(), true);
      expect(access.session.profile, identity.profile);
      expect(access.session.device, identity.device);
      final old = access.session;
      access.lock();
      expect(
        () => access.sessions.require(
          old,
          '${identity.device}/${identity.profile}',
        ),
        throwsStateError,
      );
      await access.close();
      await expectLater(verify(password, create: true), throwsStateError);
    },
  );

  test('пять попыток сохраняются, новый сервис соблюдает задержку', () async {
    await verify(password, create: true);
    for (var i = 0; i < 5; i++) {
      await expectLater(
        verify('wrong password'),
        failure(LocalProfileFailure.denied),
      );
      service = reopen();
    }
    await expectLater(verify(password), failure(LocalProfileFailure.throttled));
    now = now.add(const Duration(seconds: 31));
    await verify(password);
    expect(LocalProfileRecord.decode(storage.values.values.single).failures, 0);
  });

  test('повреждение и неподтверждённая запись закрывают доступ', () async {
    storage.values[LocalProfileVerifier.storageKey] = '{broken';
    await expectLater(service.hasProfile(), throwsFormatException);
    await expectLater(verify(password, create: true), throwsFormatException);
    expect(storage.values.values.single, '{broken');
    storage.values.clear();
    storage.discard = true;
    await expectLater(verify(password, create: true), throwsStateError);
  });

  test('ошибка записи попытки запрещает выдачу сессии', () async {
    await verify(password, create: true);
    storage.fail = true;
    await expectLater(verify(password), throwsStateError);
    storage.fail = false;
    await verify(password);
  });

  test('отмена при записи и конкурирующий сервис не выдают профиль', () async {
    await verify(password, create: true);
    storage.pause = Completer<void>();
    var active = true;
    final pending = service.verify(
      password,
      create: false,
      active: () => active,
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await expectLater(reopen().hasProfile(), throwsStateError);
    active = false;
    storage.pause!.complete();
    await expectLater(pending, failure(LocalProfileFailure.cancelled));
    expect(LocalProfileRecord.decode(storage.values.values.single).failures, 1);
  });

  test('границы пароля и отмена до создания не меняют хранилище', () async {
    for (final secret in ['short', ' ' * 20, 'a' * 257]) {
      await expectLater(
        verify(secret, create: true),
        failure(LocalProfileFailure.password),
      );
    }
    await expectLater(
      service.verify(password, create: true, active: () => false),
      failure(LocalProfileFailure.cancelled),
    );
    expect(storage.values, isEmpty);
  });
}
