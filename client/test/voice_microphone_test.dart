import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_microphone_probe.dart';
import 'package:space_client/src/voice_microphone_test.dart';

class FakeMicrophoneProbe implements VoiceMicrophoneProbe {
  bool opened = false, closed = false, failClose = false;
  Completer<void>? opening;
  Completer<double>? reading;
  double sample = 0.25;
  int updates = 0;
  @override
  Future<void> open(String? device, VoiceAudioSettings settings) async {
    opened = true;
    await opening?.future;
  }

  @override
  Future<void> close() async {
    closed = true;
    if (failClose) throw StateError('capture not stopped');
  }

  @override
  Future<double> level() async => reading?.future ?? sample;
  @override
  Future<void> configure(VoiceAudioSettings settings) async {
    updates++;
  }
}

void main() {
  test('Losing a selected device stops the local microphone test', () {
    fakeAsync((clock) {
      final probe = FakeMicrophoneProbe();
      var available = true;
      final controller = VoiceMicrophoneTest(factory: () => probe)
        ..validate = () async {
          if (!available) throw StateError('unplugged');
        };
      unawaited(controller.start(null, const VoiceAudioSettings()));
      clock.flushMicrotasks();
      available = false;
      clock.elapse(const Duration(seconds: 2));
      clock.flushMicrotasks();
      expect(probe.closed, true);
      expect(controller.state.error, contains('unplugged'));
      unawaited(controller.close());
      clock.flushMicrotasks();
      expect(clock.pendingTimers, isEmpty);
    });
  });
  test('Explicit start samples real backend levels and automatically stops after 60 seconds', () {
    fakeAsync((clock) {
      final probe = FakeMicrophoneProbe();
      final controller = VoiceMicrophoneTest(factory: () => probe);
      expect(probe.opened, false);
      unawaited(controller.start('mic', const VoiceAudioSettings()));
      clock.flushMicrotasks();
      expect(controller.state.active, true);
      clock.elapse(const Duration(milliseconds: 100));
      expect(controller.state.level, 0.25);
      unawaited(controller.configure(const VoiceAudioSettings(inputGain: 0.5)));
      clock.flushMicrotasks();
      expect(probe.updates, 1);
      clock.elapse(const Duration(seconds: 60));
      clock.flushMicrotasks();
      expect(probe.closed, true);
      expect(controller.running, false);
      unawaited(controller.close());
      clock.flushMicrotasks();
      expect(clock.pendingTimers, isEmpty);
    });
  });

  test('Cancel during permission or startup never revives the test', () async {
    final probe = FakeMicrophoneProbe()..opening = Completer<void>();
    final controller = VoiceMicrophoneTest(factory: () => probe);
    final starting = controller.start(null, const VoiceAudioSettings());
    await Future<void>.delayed(Duration.zero);
    await controller.stop();
    probe.opening!.complete();
    await starting;
    expect(probe.closed, true);
    expect(controller.state.active, false);
    await controller.close();
  });

  test('Failed preparation never opens capture', () async {
    final probe = FakeMicrophoneProbe();
    final controller = VoiceMicrophoneTest(factory: () => probe)
      ..prepare = () async => throw StateError('room not muted');
    await controller.start(null, const VoiceAudioSettings());
    expect(probe.opened, false);
    expect(controller.state.error, contains('room not muted'));
    await controller.close();
  });

  test(
    'Cleanup failure blocks new capture without an unhandled timer error',
    () async {
      final probe = FakeMicrophoneProbe()..failClose = true;
      var created = 0;
      final controller = VoiceMicrophoneTest(
        factory: () {
          created++;
          return probe;
        },
      );
      await controller.start(null, const VoiceAudioSettings());
      await controller.stop();
      expect(controller.ownsMicrophone, true);
      expect(controller.state.error, contains('capture not stopped'));
      await controller.start(null, const VoiceAudioSettings());
      expect(created, 1);
      await controller.close();
    },
  );

  test('An old pending level request cannot block a later test or overwrite its state', () {
    fakeAsync((clock) {
      final old = FakeMicrophoneProbe()..reading = Completer<double>();
      final next = FakeMicrophoneProbe()..sample = 0.8;
      var created = 0;
      final controller = VoiceMicrophoneTest(
        factory: () => created++ == 0 ? old : next,
      );
      unawaited(controller.start(null, const VoiceAudioSettings()));
      clock.flushMicrotasks();
      clock.elapse(const Duration(milliseconds: 100));
      unawaited(controller.stop());
      clock.flushMicrotasks();
      unawaited(controller.start(null, const VoiceAudioSettings()));
      clock.flushMicrotasks();
      clock.elapse(const Duration(milliseconds: 100));
      expect(controller.state.level, 0.8);
      old.reading!.complete(0.1);
      clock.flushMicrotasks();
      expect(controller.state.level, 0.8);
      unawaited(controller.close());
      clock.flushMicrotasks();
      expect(clock.pendingTimers, isEmpty);
    });
  });
}
