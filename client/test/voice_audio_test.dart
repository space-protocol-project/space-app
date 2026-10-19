import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/voice_audio_native.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_client/src/voice_microphone_probe.dart';
import 'package:space_client/src/voice_microphone_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/voice_devices.dart';

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia, waitFor;
import 'voice_devices_test.dart' show DevicesBackend;
import 'voice_microphone_test.dart' show FakeMicrophoneProbe;

class AudioVoiceMedia extends FakeVoiceMedia implements VoiceAudioMedia {
  AudioVoiceMedia(super.log);
  final settings = <VoiceAudioSettings>[];
  @override
  Future<void> configureAudio(VoiceAudioSettings value) async {
    settings.add(value);
    log.add('audio:${value.inputGain}:${value.outputGain}');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final locale in ['ru', 'en', 'zh']) {
    testWidgets('Профили и расширенная обработка сохраняются: $locale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final devices = VoiceDevices(backend: DevicesBackend());
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VoiceDevicesDialog(devices: devices),
        ),
      );
      await tester.pumpAndSettle();
      for (final mode in VoiceNoiseSuppression.values) {
        final dropdown = find.byType(
          DropdownButtonFormField<VoiceNoiseSuppression>,
        );
        await tester.ensureVisible(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        final label = switch (mode) {
          VoiceNoiseSuppression.deepFilter => 'DeepFilterNet3',
          VoiceNoiseSuppression.webrtc => 'WebRTC',
          VoiceNoiseSuppression.disabled => AppLocalizations.of(
            tester.element(dropdown),
          )!.voiceNoiseOff,
        };
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(devices.state.audio.noiseMode, mode);
        expect(
          (await SavedVoiceDevicePreferences().load()).audio.noiseMode,
          mode,
        );
      }
      final studio = find.byKey(const ValueKey('voice-profile-studio'));
      await tester.ensureVisible(studio);
      await tester.tap(studio);
      await tester.pumpAndSettle();
      expect(devices.state.audio.profile, VoiceInputProfile.studio);
      expect(devices.state.audio.highPassFilter, false);
      final custom = find.byKey(const ValueKey('voice-profile-custom'));
      await tester.ensureVisible(custom);
      await tester.tap(custom);
      await tester.pumpAndSettle();
      expect(devices.state.audio.profile, VoiceInputProfile.custom);
      final strings = AppLocalizations.of(tester.element(custom))!;
      final advanced = find.text(strings.voiceAdvancedSettings);
      await tester.ensureVisible(advanced);
      await tester.tap(advanced);
      await tester.pumpAndSettle();
      final filter = find.text(strings.voiceHighPass);
      await tester.ensureVisible(filter);
      await tester.tap(filter);
      await tester.pumpAndSettle();
      expect(devices.state.audio.highPassFilter, true);
      final slider = find.byKey(const ValueKey('voice-release-delay'));
      await tester.ensureVisible(slider);
      await tester.drag(slider, const Offset(30, 0));
      await tester.pumpAndSettle();
      final saved = (await SavedVoiceDevicePreferences().load()).audio;
      expect(saved.profile, VoiceInputProfile.custom);
      expect(saved.highPassFilter, true);
      expect(saved.releaseDelayMs, greaterThan(300));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await devices.close();
    });
  }

  testWidgets('Transmission controls persist PTT and manual sensitivity', (
    tester,
  ) async {
    final devices = VoiceDevices(backend: DevicesBackend());
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VoiceDevicesDialog(devices: devices),
      ),
    );
    await tester.pumpAndSettle();
    final automatic = find.text('Автоматическая чувствительность микрофона');
    await tester.ensureVisible(automatic);
    await tester.tap(automatic);
    await tester.pumpAndSettle();
    expect(devices.state.audio.automaticSensitivity, isFalse);
    expect(find.textContaining('Порог срабатывания:'), findsOneWidget);
    final ptt = find.text('Режим рации');
    await tester.ensureVisible(ptt);
    await tester.tap(ptt);
    await tester.pumpAndSettle();
    expect(devices.state.audio.pushToTalk, isTrue);
    expect(find.textContaining('Порог срабатывания:'), findsNothing);
    final saved = (await SavedVoiceDevicePreferences().load()).audio;
    expect(saved.pushToTalk, isTrue);
    expect(saved.automaticSensitivity, isFalse);
    await tester.pumpWidget(const SizedBox());
    await devices.close();
  });

  testWidgets(
    'Narrow audio settings save volume and stop the meter on background or dismissal',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final devices = VoiceDevices(backend: DevicesBackend());
      final probes = <FakeMicrophoneProbe>[];
      final test = VoiceMicrophoneTest(
        factory: () {
          final probe = FakeMicrophoneProbe();
          probes.add(probe);
          return probe;
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VoiceDevicesDialog(devices: devices, microphoneTest: test),
        ),
      );
      await tester.pumpAndSettle();
      final input = find.byType(Slider).first;
      await tester.ensureVisible(input);
      await tester.drag(input, const Offset(35, 0));
      await tester.pumpAndSettle();
      expect(devices.state.audio.inputGain, greaterThan(1));
      expect(
        (await SavedVoiceDevicePreferences().load()).audio.inputGain,
        devices.state.audio.inputGain,
      );
      final button = find.byKey(const ValueKey('voice-microphone-test'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(test.state.active, true);
      expect(test.state.level, 0.25);
      expect(probes.single.opened, true);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(probes.single.closed, true);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await test.start(null, devices.state.audio);
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      expect(probes.last.closed, true);
      expect(tester.takeException(), isNull);
      await test.close();
      await devices.close();
    },
  );

  test('Native probe disposes a late microphone stream after cancellation without creating peers', () async {
    const channel = MethodChannel('FlutterWebRTC.Method');
    const events = MethodChannel('FlutterWebRTC.Event');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final pending = Completer<Map<String, Object>>();
    final calls = <String>[];
    messenger.setMockMethodCallHandler(events, (_) async => null);
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'getUserMedia') return pending.future;
      return null;
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(channel, null);
      messenger.setMockMethodCallHandler(events, null);
    });
    final probe = NativeVoiceMicrophoneProbe();
    final opening = probe.open('mic', const VoiceAudioSettings());
    await waitFor(() => calls.contains('getUserMedia'));
    await probe.close();
    pending.complete({
      'streamId': 'late',
      'audioTracks': [
        {'id': 'late-mic', 'label': 'Mic', 'kind': 'audio', 'enabled': true},
      ],
      'videoTracks': [],
    });
    await expectLater(opening, throwsStateError);
    expect(calls, containsAll(['trackDispose', 'streamDispose']));
    expect(calls, isNot(contains('createPeerConnection')));
  });

  test('Audio settings and devices survive restart together', () async {
    const audio = VoiceAudioSettings(
      inputGain: 0.6,
      outputGain: 1.4,
      noiseSuppression: false,
      echoCancellation: true,
      autoGainControl: false,
    );
    await SavedVoiceDevicePreferences().save(
      const VoiceDeviceChoice(input: 'mic', output: 'speaker', audio: audio),
    );
    final saved = await SavedVoiceDevicePreferences().load();
    expect(saved.input, 'mic');
    expect(saved.output, 'speaker');
    expect(saved.audio.toJson(), audio.toJson());
    expect(saved.audio.profile, VoiceInputProfile.custom);
    expect(audio.withProfile(VoiceInputProfile.studio).noiseSuppression, false);
    expect(audio.withProfile(VoiceInputProfile.speech).autoGainControl, true);
  });

  test('Old and malformed audio settings use safe defaults', () async {
    SharedPreferences.setMockInitialValues({
      SavedVoiceDevicePreferences.key: '{"input":"mic"}',
    });
    expect(
      (await SavedVoiceDevicePreferences().load()).audio.toJson(),
      const VoiceAudioSettings().toJson(),
    );
    final audio = VoiceAudioSettings.fromJson({
      'inputGain': double.nan,
      'outputGain': 9,
      'noiseSuppression': 'invalid',
    });
    expect(audio.inputGain, 1);
    expect(audio.outputGain, 2);
    expect(audio.noiseSuppression, true);
    expect(audio.copyWith(inputGain: -2).inputGain, 0);
  });

  test(
    'Native gain and meter never request microphone permission by themselves',
    () async {
      const channel = MethodChannel('FlutterWebRTC.Method');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            if (call.method == 'spaceVoiceLevel') return 0.25;
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      await VoiceAudioNative.gain(0.5);
      expect(await VoiceAudioNative.level(), 0.25);
      expect(calls.any((call) => call.method == 'getUserMedia'), false);
      expect(
        calls.firstWhere((call) => call.method == 'spaceVoiceGain').arguments,
        {'gain': 0.5},
      );
      await expectLater(VoiceAudioNative.gain(double.nan), throwsArgumentError);
    },
  );

  test(
    'Native capture uses the selected processing on all desktop adapters',
    () {
      final audio =
          voiceMicrophoneConstraints(
                'mic',
                const VoiceAudioSettings(
                  noiseSuppression: false,
                  echoCancellation: false,
                  autoGainControl: false,
                ),
              )['audio']
              as Map;
      expect(audio['noiseSuppression'], false);
      expect(audio['highpassFilter'], true);
      expect(audio['optional'], contains(equals({'googHighpassFilter': true})));
      final studio =
          voiceMicrophoneConstraints(
                'mic',
                const VoiceAudioSettings().withProfile(
                  VoiceInputProfile.studio,
                ),
              )['audio']
              as Map;
      expect(studio['highpassFilter'], false);
      expect(
        audio['optional'],
        contains(equals({'googEchoCancellation': false})),
      );
      expect(
        audio['optional'],
        contains(equals({'googNoiseSuppression': false})),
      );
      expect(
        audio['optional'],
        contains(equals({'googAutoGainControl': false})),
      );
      expect(audio['optional'], contains(equals({'sourceId': 'mic'})));
    },
  );

  test(
    'Gain applies live; changing processing stops capture until manual enable',
    () async {
      final log = <String>[];
      final media = AudioVoiceMedia(log);
      final api = FakeVoiceApi(log);
      final controller = VoiceController(
        mediaFactory: () => media,
        audioDevices: VoiceDevices(backend: DevicesBackend()),
      );
      addTearDown(controller.close);
      addTearDown(api.closing.close);
      await controller.join(api, 'room', 'Room');
      await waitFor(() => controller.state.phase == VoicePhase.connected);
      await controller.toggleMicrophone();
      await controller.devices.updateAudio(
        const VoiceAudioSettings(inputGain: 0.4, outputGain: 1.2),
      );
      expect(controller.state.muted, false);
      expect(media.settings.last.inputGain, 0.4);
      await controller.devices.updateAudio(
        controller.devices.state.audio.withProfile(VoiceInputProfile.studio),
      );
      expect(controller.state.muted, true);
      expect(
        log.lastIndexOf('microphone:false'),
        lessThan(log.lastIndexOf('audio:0.4:1.2')),
      );
      expect(
        (await SavedVoiceDevicePreferences().load()).audio.profile,
        VoiceInputProfile.studio,
      );
    },
  );
}
