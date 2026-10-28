import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/settings_snapshot.dart';
import 'package:space_client/src/portable_voice_merge.dart';
import 'package:space_client/src/portable_voice_profile.dart';
import 'package:space_client/src/voice_audio_settings.dart';

import 'fixtures/directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Старый архив остаётся без голосового профиля и сохраняет байты', () {
    for (final version in [1, 2]) {
      final original = directoryDocument(version: version);
      final restored = decodeDirectoryDocument(original.encode());
      expect(restored.voiceSettings, isNull);
      expect(restored.encode(), original.encode());
    }
  });

  test('Новый архив проверяет профиль и причинную историю', () {
    final voice = PortableVoiceSnapshot(
      PortableVoiceProfile.fromAudio(const VoiceAudioSettings()),
      {},
    );
    final original = directoryDocument();
    final data = {...original.data, 'v': 4, 'voice_settings': voice.data};
    final restored = DirectoryDocument.parse(data);
    expect(restored.voiceSettings!.profile, voice.profile);
    expect(
      decodeDirectoryDocument(restored.encode()).encode(),
      restored.encode(),
    );
    final invalid = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
    (invalid['voice_settings'] as Map<String, dynamic>)['unknown'] = true;
    expect(() => DirectoryDocument.parse(invalid), throwsFormatException);
  });

  test('Неподключённое восстановление профиля не применяется молча', () async {
    final preferences = AppPreferences();
    addTearDown(preferences.close);
    final service = DirectoryBackupService(
      DirectoryRepository(DirectoryStorage()),
      DirectoryVault(),
      preferences,
      () => {},
    );
    final voice = PortableVoiceSnapshot(
      PortableVoiceProfile.fromAudio(const VoiceAudioSettings()),
      {},
    );
    final document = DirectoryDocument.parse({
      ...directoryDocument().data,
      'v': 4,
      'voice_settings': voice.data,
    });
    expect((await service.preview(document)).conflicts, isNotEmpty);
  });

  test(
    'Голосовой журнал сохраняется при ошибке и завершается повторно',
    () async {
      final storage = DirectoryStorage();
      final repository = DirectoryRepository(storage);
      final preferences = AppPreferences();
      addTearDown(preferences.close);
      final voice = PortableVoiceSnapshot(
        PortableVoiceProfile.fromAudio(const VoiceAudioSettings()),
        {},
      );
      final state = await repository.read();
      state['pending'] = {
        'origins': <String>[],
        'settings': null,
        'voice': {'v': 1, 'before': voice.data, 'after': voice.data},
      };
      await repository.write(state);
      var attempts = 0;
      final service = DirectoryBackupService(
        repository,
        DirectoryVault(),
        preferences,
        () => {},
        resumeVoice: (_) async {
          attempts++;
          if (attempts == 1) throw StateError('Сбой');
        },
      );
      await expectLater(service.resume(), throwsStateError);
      expect((await repository.read())['pending'], isNotNull);
      await service.resume();
      expect((await repository.read())['pending'], isNull);
      expect(attempts, 2);
    },
  );

  test(
    'Копия переносит профиль, старая копия оставляет его без изменений',
    () async {
      final preferences = AppPreferences();
      addTearDown(preferences.close);
      final speech = PortableVoiceProfile.fromAudio(const VoiceAudioSettings());
      final studio = PortableVoiceProfile.fromAudio(
        const VoiceAudioSettings().withProfile(VoiceInputProfile.studio),
      );
      var local = PortableVoiceSnapshot(speech, {});
      final service = DirectoryBackupService(
        DirectoryRepository(DirectoryStorage()),
        DirectoryVault(),
        preferences,
        () => {},
        readVoice: () async => local,
        resumeVoice: (pending) async {
          final journal = checkedPortableVoicePending(pending);
          local = resumePortableVoice(
            journal.before,
            journal.after,
            local,
            preferences.settingsActor,
          );
        },
      );
      final captured = await service.capture();
      expect(captured.voiceSettings!.profile, speech);
      final incoming = DirectoryDocument.parse({
        ...captured.data,
        'voice_settings': PortableVoiceSnapshot(studio, {}).data,
      });
      final plan = await service.preview(incoming);
      expect(plan.settingConflicts, contains('voiceProfile'));
      await service.apply(
        plan,
        mergeSettings: true,
        settingsChoices: {'voiceProfile': SettingsChoice.incoming},
      );
      expect(local.profile, studio);
      final old = await service.preview(directoryDocument());
      await service.apply(old, mergeSettings: false);
      expect(local.profile, studio);
    },
  );
}
