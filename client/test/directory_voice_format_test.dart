import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_document.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/portable_voice_merge.dart';
import 'package:space_client/src/portable_voice_profile.dart';
import 'package:space_client/src/voice_audio_settings.dart';

import 'fixtures/directory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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
}
