import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/member_profile_controller.dart';
import 'package:space_client/src/participant_directory.dart';
import 'package:space_client/src/participant_profiles.dart';
import 'package:space_client/src/profile_avatar.dart';
import 'package:space_client/src/files.dart';

import 'support/participant_profiles.dart';

Future<void> flushProfiles() =>
    Future<void>.delayed(const Duration(milliseconds: 15));

void main() {
  test(
    'аватар ограничен, очищен и уменьшен; анимация и повреждения отклоняются',
    () {
      final png = sampleAvatar();
      final avatar = profileAvatarBytes(png);
      expect(validProfileAvatar(avatar), isTrue);
      final jpeg = Uint8List.fromList(img.encodeJpg(img.decodePng(png)!));
      expect(validProfileAvatar(profileAvatarBytes(jpeg)), isTrue);
      expect(avatar.length, lessThanOrEqualTo(8192));
      final apng = Uint8List.fromList([
        ...png.take(33),
        0,
        0,
        0,
        8,
        ...'acTL'.codeUnits,
        ...List.filled(12, 0),
        ...png.skip(33),
      ]);
      expect(() => profileAvatarBytes(apng), throwsFormatException);
      expect(
        () => profileAvatarBytes(Uint8List.fromList('<svg/>'.codeUnits)),
        throwsFormatException,
      );
      final huge = Uint8List.fromList(png);
      ByteData.sublistView(huge).setUint32(16, 4097);
      expect(() => profileAvatarBytes(huge), throwsFormatException);
      // Сжатые метаданные отбрасываются до декодирования, в том числе повреждённые.
      final metadata = Uint8List.fromList([
        ...png.take(33),
        0,
        0,
        0,
        2,
        ...'zTXt'.codeUnits,
        1,
        2,
        0,
        0,
        0,
        0,
        ...png.skip(33),
      ]);
      expect(validProfileAvatar(profileAvatarBytes(metadata)), isTrue);
      expect(validProfileName(String.fromCharCode(0xd800)), isFalse);
      expect(validProfileName('\u202eимя'), isFalse);
    },
  );

  test(
    'чтение изображения ограничено даже при недостоверной длине файла',
    () async {
      final source = _GrowingFile();
      final file = SpaceFile.source(
        source,
        path: 'memory:',
        name: 'avatar.png',
      );
      await expectLater(prepareProfileAvatar(file), throwsFormatException);
      expect(source.readAll, isFalse);
    },
  );

  test(
    'имя и аватар сохраняются одной ревизией, удаление явно задано',
    () async {
      final api = FakeParticipantProfiles();
      final controller = MemberProfileController(api);
      addTearDown(controller.close);
      await controller.load();
      await controller.selectAvatar(
        SpaceFile.fromData(sampleAvatar(), name: 'avatar.png'),
      );
      await controller.save('Новое имя');
      expect(api.updates.single.hasAvatarPng(), isTrue);
      expect(api.updates.single.expectedRevision.toInt(), 0);
      expect(controller.state.previewAvatar, isNotEmpty);
      await controller.save('Другое имя');
      expect(api.updates.last.hasAvatarPng(), isFalse);
      expect(api.value.avatarPng, isNotEmpty);
      controller.removeAvatar();
      await controller.save('Другое имя');
      expect(api.updates.last.removeAvatar, isTrue);
      expect(api.value.avatarPng, isEmpty);
    },
  );

  test('занятое имя и конфликт сохраняют ввод и выбранный аватар', () async {
    final api = FakeParticipantProfiles();
    final controller = MemberProfileController(api);
    addTearDown(controller.close);
    await controller.load();
    await controller.selectAvatar(SpaceFile.fromData(sampleAvatar()));
    api.failure = const GrpcError.alreadyExists();
    await controller.save('Занятое имя');
    expect(controller.state.problem, ProfileProblem.taken);
    expect(controller.state.draftName, 'Занятое имя');
    expect(controller.state.avatarEdit, AvatarEdit.replace);
    api.failure = null;
    api.value.revision += 1;
    await controller.save('Свободное имя');
    expect(controller.state.problem, ProfileProblem.conflict);
    await controller.load();
    expect(controller.state.draftName, 'Свободное имя');
    expect(controller.state.avatarEdit, AvatarEdit.replace);
    await controller.save(controller.state.draftName);
    expect(controller.state.saved, isTrue);
  });

  test('поздняя загрузка закрытого редактора не возвращает профиль', () async {
    final api = FakeParticipantProfiles()
      ..pending = Completer<ParticipantProfile>();
    final controller = MemberProfileController(api);
    final load = controller.load();
    await controller.close();
    api.pending!.complete(api.value);
    await load;
    expect(controller.state.loaded, isFalse);
  });

  test('каталог ограничивает пакеты и игнорирует поздний ответ неактивного раздела', () async {
    final api = FakeParticipantProfiles();
    final directory = ParticipantDirectory(api, 'forum');
    addTearDown(directory.close);
    directory.select(List.generate(121, (i) => 'u_$i'));
    await flushProfiles();
    expect(api.queries.map((q) => q.$2.length), [50, 50, 21]);
    expect(directory.state.profiles.length, 121);
    api.listing = Completer<List<ParticipantProfile>>();
    final pending = directory.refresh();
    directory.select(['u_secret'], active: false);
    api.listing!.complete([
      ParticipantProfile(principalId: 'u_0', displayName: 'Секрет'),
    ]);
    await pending;
    expect(api.queries.length, 4);
    expect(directory.state.profiles, isEmpty);
  });

  test(
    'каталог не принимает посторонние ID, дубликаты и повреждённые аватары',
    () async {
      for (final result in [
        [ParticipantProfile(principalId: 'u_other')],
        [
          ParticipantProfile(principalId: 'u_alice'),
          ParticipantProfile(principalId: 'u_alice'),
        ],
        [
          ParticipantProfile(principalId: 'u_alice', avatarPng: [1, 2, 3]),
        ],
      ]) {
        final api = FakeParticipantProfiles()..listed = result;
        final directory = ParticipantDirectory(api, 'chat');
        directory.select(['u_alice']);
        await flushProfiles();
        expect(directory.state.profiles, isEmpty);
        await directory.close();
      }
    },
  );
}

class _GrowingFile implements SpaceFileSource {
  bool readAll = false;
  @override
  Future<int?> length() async => 0;
  @override
  Future<Uint8List> readAsBytes() async {
    readAll = true;
    throw StateError('Не должно вызываться');
  }

  @override
  Stream<List<int>> openRead([int? start, int? end]) async* {
    yield Uint8List(5 * 1024 * 1024);
    yield [1];
  }
}
