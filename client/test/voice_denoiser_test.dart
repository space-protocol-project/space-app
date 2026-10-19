import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_denoiser.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_voice_native/space_voice_native.dart';

class TestHandle implements DeepFilterHandle {
  TestHandle(this.log);
  final List<String> log;
  @override
  int get address => 1234;
  @override
  int get callbackAddress => 5678;
  @override
  void release() => log.add('free');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('FlutterWebRTC.Method');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  test(
    'DeepFilterNet3 — по умолчанию; прежний выключенный фильтр не включается',
    () {
      expect(
        const VoiceAudioSettings().noiseMode,
        VoiceNoiseSuppression.deepFilter,
      );
      expect(
        VoiceAudioSettings.fromJson({'noiseSuppression': false}).noiseMode,
        VoiceNoiseSuppression.disabled,
      );
      for (final mode in VoiceNoiseSuppression.values) {
        final audio = const VoiceAudioSettings().copyWith(noiseMode: mode);
        expect(VoiceAudioSettings.fromJson(audio.toJson()).noiseMode, mode);
        final constraints =
            voiceMicrophoneConstraints(null, audio)['audio'] as Map;
        expect(
          constraints['noiseSuppression'],
          mode == VoiceNoiseSuppression.webrtc,
        );
      }
      final webRtc = const VoiceAudioSettings(
        noiseMode: VoiceNoiseSuppression.webrtc,
      );
      expect(webRtc.sameProcessing(const VoiceAudioSettings()), false);
    },
  );

  test(
    'Callback отсоединяется до освобождения, повторное закрытие безопасно',
    () async {
      final log = <String>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        final args = call.arguments as Map;
        log.add(args['context'] == 0 ? 'detach:${args['expected']}' : 'attach');
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      final engine = VoiceDenoiser(create: () async => TestHandle(log));
      await engine.open(const VoiceAudioSettings());
      await engine.close();
      await engine.close();
      expect(log, ['attach', 'detach:1234', 'free']);
    },
  );

  test('Отмена загрузки не присоединяет позднюю модель к захвату', () async {
    final log = <String>[];
    final pending = Completer<DeepFilterHandle>();
    final engine = VoiceDenoiser(create: () => pending.future);
    final opening = engine.open(const VoiceAudioSettings());
    final checked = expectLater(opening, throwsStateError);
    await engine.close();
    pending.complete(TestHandle(log));
    await checked;
    expect(log, ['free']);
  });

  test(
    'Неуспешное отсоединение не освобождает доступный callback контекст',
    () async {
      final log = <String>[];
      messenger.setMockMethodCallHandler(channel, (call) async {
        if ((call.arguments as Map)['context'] == 0) {
          throw PlatformException(code: 'busy');
        }
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      final engine = VoiceDenoiser(create: () async => TestHandle(log));
      await engine.open(const VoiceAudioSettings());
      await expectLater(engine.close(), throwsA(isA<PlatformException>()));
      expect(log, isEmpty);
    },
  );

  test('WebRTC и отключение не загружают нейросетевую модель', () async {
    for (final mode in [
      VoiceNoiseSuppression.webrtc,
      VoiceNoiseSuppression.disabled,
    ]) {
      final engine = VoiceDenoiser(
        create: () async => throw StateError('Модель не нужна'),
      );
      await engine.open(VoiceAudioSettings(noiseMode: mode));
      await engine.close();
    }
  });

  test(
    'Встроенная модель обрабатывает реальные блоки через упакованный FFI',
    () async {
      final engine = await DeepFilterContext.create();
      final memory = calloc<Float>(480);
      addTearDown(() {
        calloc.free(memory);
        engine.release();
      });
      final state = Pointer<Void>.fromAddress(engine.address);
      final callback = Pointer<NativeFunction<ProcessFrame>>.fromAddress(
        engine.callbackAddress,
      ).asFunction<int Function(Pointer<Void>, Pointer<Float>, int, int)>();
      final random = Random(7);
      var inputEnergy = 0.0, outputEnergy = 0.0;
      for (var block = 0; block < 120; block++) {
        for (var i = 0; i < 480; i++) {
          memory[i] = (random.nextDouble() * 2 - 1) * 2000;
          if (block > 60) inputEnergy += memory[i] * memory[i];
        }
        expect(callback(state, memory, 480, 48000), 1);
        for (var i = 0; i < 480; i++) {
          expect(memory[i].isFinite, true);
          if (block > 60) outputEnergy += memory[i] * memory[i];
        }
      }
      expect(outputEnergy, lessThan(inputEnergy * .5));
      memory[0] = double.nan;
      expect(processFrame(state, memory, 480, 48000), 0);
      expect(memory.asTypedList(480), everyElement(0));
    },
  );
}
