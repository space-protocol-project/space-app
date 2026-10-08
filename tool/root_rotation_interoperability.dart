import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/root_rotation.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/recovery_card.dart';
import 'package:space_client/src/generated/space/v1/space.pbgrpc.dart';

class CrashStorage implements SecureKeyStorage {
  final values = <String, String>{};
  bool failActivation = false, failCleanup = false;
  @override
  Future<String?> read({required String key}) async => values[key];
  @override
  Future<void> write({required String key, required String value}) async {
    if (failActivation && !key.endsWith('.rotation')) {
      throw StateError('Потеря записи после commit');
    }
    values[key] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    if (failCleanup) throw StateError('Сбой после записи нового vault');
    values.remove(key);
  }
}

void check(bool ok, String message) {
  if (!ok) throw StateError(message);
}

Future<void> main(List<String> args) async {
  final server = await discover(args.single);
  final storage = CrashStorage();
  var vault = KeyIdentityVault(storage);
  final original = await SpaceSession.connect(server, vault);
  final old = await vault.load(server.origin.toString());
  final auth = AuthServiceClient(original.channel);
  final identity = await old!.identity();
  final device = await Ed25519().newKeyPairFromSeed(old.deviceSeed);
  final root = identity.publicKey;
  final challenge = await auth.createChallenge(
    CreateChallengeRequest(purpose: 'auth.login', grantId: old.grantId),
  );
  final signing = await checkedSigningBytes(
    challenge,
    server,
    root,
    (await device.extractPublicKey()).bytes,
    'auth.login',
    old.grantId,
  );
  final login = await auth.completeChallenge(
    CompleteChallengeRequest(
      challengeId: challenge.challengeId,
      signature: (await Ed25519().sign(signing, keyPair: device)).bytes,
    ),
  );
  final options = CallOptions(
    metadata: {'authorization': 'Bearer ${login.accessToken}'},
  );
  final pending = await prepareRootRotation(server, old, vault, auth, options);
  check(
    await vault.loadRotation(old.origin) != null,
    'Журнал не сохранён до commit',
  );
  storage.failActivation = true;
  var failed = false;
  try {
    await finishRootRotation(server, vault, auth);
  } catch (_) {
    failed = true;
  }
  check(failed, 'Не смоделирован сбой сохранения');
  check(
    (await vault.load(old.origin))!.grantId == old.grantId,
    'Старые ключи потеряны при сбое',
  );
  check(
    await vault.loadRotation(old.origin) != null,
    'Новый секрет потерян после commit',
  );
  storage.failActivation = false;
  storage.failCleanup = true;
  vault = KeyIdentityVault(storage);
  failed = false;
  try {
    await finishRootRotation(server, vault, auth);
  } catch (_) {
    failed = true;
  }
  check(failed, 'Не смоделирован сбой очистки');
  final activated = await vault.load(old.origin);
  check(activated!.grantId != old.grantId, 'Новый grant не активирован');
  check(
    await vault.loadRotation(old.origin) != null,
    'Журнал потерян раньше подтверждения',
  );
  storage.failCleanup = false;
  final repeated = await finishRootRotation(server, vault, auth);
  check(repeated!.grantId == activated.grantId, 'Повтор создал другой grant');
  check(await vault.loadRotation(old.origin) == null, 'Журнал не очищен');
  check(
    (await repeated.identity()).principalId == identity.principalId,
    'ID изменён',
  );
  final next = await SpaceSession.connect(server, vault);
  try {
    check(next.principalId == original.principalId, 'Новый вход изменил ID');
    check(next.role == original.role, 'Роль потеряна');
    await next.messages();
    final payload = await next.recoveryPayload();
    check(payload['v'] == 2, 'Карточка не содержит историю');
    final encrypted = await sealRecoveryCard(
      payload,
      'Disposable rotation card password',
    );
    final reopened = await recordFromRecovery(
      await openRecoveryCard(encrypted, 'Disposable rotation card password'),
    );
    check(
      (await reopened.identity()).principalId == identity.principalId,
      'Карточка изменила ID',
    );
    final restored = await SpaceSession.connect(
      server,
      KeyIdentityVault(CrashStorage()),
      restoredRecord: reopened,
    );
    await restored.messages();
    await restored.close();
  } finally {
    await next.close();
    await original.close();
  }
  check(
    jsonEncode(pending).contains('old_digest'),
    'Нет связи с исходной записью',
  );
  stdout.writeln(
    'Dart/Go: полная цепочка root, stable principal, commit с потерей записи, повтор после очистки, новый вход и recovery v2 — успешно.',
  );
}
