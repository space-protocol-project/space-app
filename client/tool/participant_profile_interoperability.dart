import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

class ProfileVault implements IdentityVault {
  DeviceRecord? record;
  @override
  Future<DeviceRecord?> load(String origin) async => record;
  @override
  Future<void> save(DeviceRecord value) async {
    record = DeviceRecord.fromJson(value.toJson());
  }
}

void require(bool valid, String message) {
  if (!valid) throw StateError(message);
}

Future<void> requireCode(Future<Object?> operation, int code) async {
  try {
    await operation;
  } on GrpcError catch (error) {
    if (error.code == code) return;
    rethrow;
  }
  throw StateError('Ожидалась ошибка $code');
}

Future<void> main(List<String> args) async {
  final server = await discover(args.first);
  final vault = ProfileVault();
  var owner = await SpaceSession.connect(server, vault);
  SpaceSession? member, device;
  try {
    require(owner.participantProfilesSupported, 'Нет capability профиля');
    final settings =
        (await owner.adminRequest('/api/v1/space/settings'))['settings'] as Map;
    await owner.adminRequest(
      '/api/v1/space/settings',
      method: 'PATCH',
      body: {
        'title': 'Стенд профилей',
        'chatTitle': settings['chatTitle'],
        'chatEnabled': true,
        'registrationPolicy': 'open',
        'expectedRevision': settings['revision'],
      },
    );
    final principal = owner.principalId, grant = owner.currentGrantId;
    final root = url64(vault.record!.rootSeed);
    final original = await owner.send(
      'История и @Alice сохраняются',
      'profile-history',
    );
    final current = await owner.getParticipantProfile();
    final avatar = img.encodePng(
      img.Image(width: 8, height: 8, numChannels: 4)
        ..clear(img.ColorRgba8(120, 150, 90, 255)),
    );
    final saved = await owner.updateParticipantProfile(
      UpdateParticipantProfileRequest(
        displayName: 'Alice',
        avatarPng: avatar,
        expectedRevision: current.revision,
      ),
    );
    member = await SpaceSession.connect(
      await discover(args.first),
      ProfileVault(),
    );
    await requireCode(
      member.updateParticipantProfile(
        UpdateParticipantProfileRequest(displayName: 'ＡＬＩＣＥ'),
      ),
      StatusCode.alreadyExists,
    );
    final visible = await member.listParticipantProfiles('general', [
      principal,
    ]);
    require(
      visible.single.displayName == 'Alice' &&
          visible.single.avatarPng.isNotEmpty,
      'Connect не доставил профиль',
    );
    final deviceVault = ProfileVault()
      ..record = DeviceRecord.fromJson({
        ...vault.record!.toJson(),
        'deviceSeed': url64(List.filled(32, 42)),
        'grantId': '',
        'administrative': false,
      });
    device = await SpaceSession.connect(
      await discover(args.first),
      deviceVault,
    );
    require(
      device.principalId == principal && device.currentGrantId != grant,
      'Не создано второе устройство той же личности',
    );
    await device.updateParticipantProfile(
      UpdateParticipantProfileRequest(
        displayName: 'Имя на двух устройствах',
        expectedRevision: saved.revision,
      ),
    );
    await requireCode(
      owner.updateParticipantProfile(
        UpdateParticipantProfileRequest(
          displayName: 'Устаревшая правка',
          expectedRevision: saved.revision,
        ),
      ),
      StatusCode.aborted,
    );
    require(
      owner.principalId == principal &&
          owner.currentGrantId == grant &&
          url64(vault.record!.rootSeed) == root,
      'Профиль изменил ключи или идентичность',
    );
    if (args.length > 1) {
      await File('${args[1]}.ready').writeAsString('ready');
      final limit = Stopwatch()..start();
      while (!await File('${args[1]}.resume').exists()) {
        if (limit.elapsed > const Duration(seconds: 45)) {
          throw StateError('Сервер не перезапущен');
        }
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }
    await owner.close();
    owner = await SpaceSession.connect(await discover(args.first), vault);
    final restored = await owner.getParticipantProfile();
    require(
      owner.principalId == principal &&
          restored.displayName == 'Имя на двух устройствах' &&
          restored.avatarPng.isNotEmpty,
      'Профиль потерялся после перезапуска',
    );
    final messages = await owner.messages();
    require(
      messages.any(
        (m) =>
            m.id == original.id &&
            m.authorId == principal &&
            m.text == 'История и @Alice сохраняются',
      ),
      'Изменена история или авторство',
    );
    await owner.updateParticipantProfile(
      UpdateParticipantProfileRequest(
        displayName: restored.displayName,
        removeAvatar: true,
        expectedRevision: restored.revision,
      ),
    );
    require(
      (await device.getParticipantProfile()).avatarPng.isEmpty,
      'Удаление не синхронизировалось',
    );
    stdout.writeln(
      'PROFILE_INTEROP_OK: Connect, уникальность, два устройства, ревизии, перезапуск, история, удаление аватара',
    );
  } finally {
    await device?.close();
    await member?.close();
    await owner.close();
  }
}
