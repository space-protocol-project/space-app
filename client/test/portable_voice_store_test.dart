import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/core.dart' show url64;
import 'package:space_client/src/portable_voice_profile.dart';
import 'package:space_client/src/portable_voice_store.dart';
import 'package:space_client/src/voice_audio_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final actor = url64(List.filled(16, 1));
  final speech = PortableVoiceProfile.fromAudio(const VoiceAudioSettings());
  final studio = PortableVoiceProfile.fromAudio(
    const VoiceAudioSettings().withProfile(VoiceInputProfile.studio),
  );
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Начальная миграция сохраняет значение и повтор не создаёт ревизию', () async {
    final store = PortableVoiceStore();
    final initial = await store.observe(speech, actor);
    expect(initial.profile, speech);
    expect(initial.clock, isEmpty);
    final changed = await store.observe(studio, actor);
    expect(changed.clock, {actor: 1});
    final again = await store.observe(studio, actor);
    expect(again.clock, {actor: 1});
  });

  test('Повреждённое хранилище не заменяется настройками по умолчанию', () async {
    SharedPreferences.setMockInitialValues({PortableVoiceStore.key: '{'});
    await expectLater(PortableVoiceStore().observe(speech, actor), throwsFormatException);
    expect((await SharedPreferences.getInstance()).getString(PortableVoiceStore.key), '{');
  });

  test('Одновременные локальные изменения сериализуются', () async {
    final store = PortableVoiceStore();
    await store.observe(speech, actor);
    await Future.wait([
      store.observe(studio, actor),
      store.observe(speech, actor),
    ]);
    final current = await store.read(studio);
    expect(current.profile, speech);
    expect(current.clock, {actor: 2});
  });
}
