import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart' show url64;
import 'package:space_client/src/portable_voice_merge.dart';
import 'package:space_client/src/portable_voice_profile.dart';
import 'package:space_client/src/settings_snapshot.dart';
import 'package:space_client/src/voice_audio_settings.dart';

void main() {
  final a = url64(List.filled(16, 1));
  final b = url64(List.filled(16, 2));
  final speech = PortableVoiceProfile.fromAudio(const VoiceAudioSettings());
  final studio = PortableVoiceProfile.fromAudio(
    const VoiceAudioSettings().withProfile(VoiceInputProfile.studio),
  );

  test('Старая копия без профиля сохраняет локальный профиль', () {
    final local = PortableVoiceSnapshot(studio, {a: 1});
    expect(PortableVoiceMerge(local, null).resolve(a, null), same(local));
  });

  test('Причинный потомок применяется без конфликта', () {
    final local = PortableVoiceSnapshot(speech, {a: 1});
    final next = PortableVoiceSnapshot(studio, {a: 2});
    final merge = PortableVoiceMerge(local, next);
    expect(merge.conflict, isFalse);
    expect(merge.resolve(a, null), same(next));
  });

  test('Конкурентные изменения требуют выбора и учитывают обе истории', () {
    final local = PortableVoiceSnapshot(speech, {a: 1});
    final incoming = PortableVoiceSnapshot(studio, {b: 1});
    final merge = PortableVoiceMerge(local, incoming);
    expect(merge.conflict, isTrue);
    expect(() => merge.resolve(a, null), throwsFormatException);
    final result = merge.resolve(a, SettingsChoice.local);
    expect(result.profile, speech);
    expect(result.clock, {a: 2, b: 1});
    expect(PortableVoiceMerge(result, incoming).conflict, isFalse);
  });

  test('Повреждённая история и лишние поля отклоняются', () {
    final local = PortableVoiceSnapshot(speech, {a: 1});
    expect(
      () => PortableVoiceSnapshot.parse({...local.data, 'extra': true}),
      throwsFormatException,
    );
    expect(
      () => PortableVoiceSnapshot.parse({
        ...local.data,
        'clock': {a: 0},
      }),
      throwsFormatException,
    );
  });

  test('Повтор после сбоя сохраняет позднее локальное изменение', () {
    final before = PortableVoiceSnapshot(speech, {a: 1});
    final target = PortableVoiceSnapshot(studio, {a: 1, b: 1});
    final current = before.observe(studio, a).observe(speech, a);
    final result = resumePortableVoice(before, target, current, a);
    expect(result.profile, speech);
    expect(result.clock, {a: 4, b: 1});
    expect(resumePortableVoice(before, target, result, a), same(result));
  });

  test('Журнал не допускает откат или незарегистрированное изменение', () {
    final before = PortableVoiceSnapshot(speech, {a: 2});
    final older = PortableVoiceSnapshot(studio, {a: 1});
    final unversioned = PortableVoiceSnapshot(studio, {a: 2});
    for (final after in [older, unversioned]) {
      expect(
        () => checkedPortableVoicePending({
          'v': 1,
          'before': before.data,
          'after': after.data,
        }),
        throwsFormatException,
      );
    }
    final after = PortableVoiceSnapshot(studio, {a: 2, b: 1});
    final pending = checkedPortableVoicePending({
      'v': 1,
      'before': before.data,
      'after': after.data,
    });
    expect(pending.after.profile, studio);
  });
}
