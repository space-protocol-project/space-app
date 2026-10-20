import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_microphone_test.dart';

import 'voice_microphone_test.dart' show FakeMicrophoneProbe;

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia, waitFor;
import 'voice_devices_test.dart' show DevicesBackend;

class DeviceCall {
  DeviceCall({VoiceMicrophoneTest? microphoneTest}) {
    api = FakeVoiceApi(log);
    controller = VoiceController(
      audioDevices: VoiceDevices(backend: backend),
      mediaFactory: () => FakeVoiceMedia(log),
      heartbeat: const Duration(milliseconds: 20),
      microphoneTest: microphoneTest,
    );
  }
  final log = <String>[];
  final backend = DevicesBackend();
  late final FakeVoiceApi api;
  late final VoiceController controller;

  Future<void> join() async {
    await controller.join(api, 'room', 'Room');
    await waitFor(() => controller.state.phase == VoicePhase.connected);
  }

  Future<void> close() async {
    await controller.close();
    await api.closing.close();
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Смена аудиоустройства останавливает передачу и не включает её сама',
    () async {
      final call = DeviceCall();
      addTearDown(call.close);
      await call.join();
      await call.controller.toggleMicrophone();
      expect(call.controller.state.muted, false);
      await call.controller.devices.select(call.backend.microphone);
      expect(call.controller.state.muted, true);
      expect(
        call.log.lastIndexOf('microphone:false'),
        greaterThan(call.log.lastIndexOf('microphone:true')),
      );
      await call.controller.devices.refresh();
      expect(call.controller.state.muted, true);
    },
  );

  test(
    'Microphone test deafens the room and never enables publishing or sound',
    () async {
      final probe = FakeMicrophoneProbe();
      final test = VoiceMicrophoneTest(factory: () => probe);
      final call = DeviceCall(microphoneTest: test);
      addTearDown(call.close);
      await call.join();
      await call.controller.toggleMicrophone();
      await test.start(null, call.controller.devices.state.audio);
      expect(probe.opened, true);
      expect(call.controller.state.muted, true);
      expect(call.controller.state.deafened, true);
      final captures = call.log
          .where((value) => value == 'microphone:true')
          .length;
      await call.controller.toggleMicrophone();
      await call.controller.toggleDeafened();
      expect(call.controller.state.muted, true);
      expect(call.controller.state.deafened, true);
      expect(
        call.log.where((value) => value == 'microphone:true').length,
        captures,
      );
      await call.controller.leave();
      expect(probe.closed, true);
      expect(test.running, false);
    },
  );

  test(
    'Missing saved headset disables sound before the first media answer',
    () async {
      await SavedVoiceDevicePreferences().save(
        const VoiceDeviceChoice(output: 'missing-headset'),
      );
      final call = DeviceCall();
      addTearDown(call.close);
      await call.join();
      expect(call.controller.state.deafened, true);
      expect(call.controller.state.muted, true);
      expect(
        call.log.indexOf('deafen:true'),
        lessThan(call.log.indexOf('answer')),
      );
      expect(call.log, contains('update:true:true'));
      expect(call.backend.selected, isEmpty);
    },
  );

  test(
    'Unplugging selected microphone mutes, reconnecting never unmutes',
    () async {
      final call = DeviceCall();
      addTearDown(call.close);
      await call.join();
      await call.controller.devices.select(call.backend.microphone);
      await call.controller.toggleMicrophone();
      expect(call.controller.state.muted, false);
      call.backend.available = [call.backend.speaker];
      await waitFor(() => call.controller.state.muted);
      expect(call.log, contains('microphone:false'));
      expect(call.log, contains('update:true:false'));
      final captures = call.log
          .where((event) => event == 'microphone:true')
          .length;
      await call.controller.toggleMicrophone();
      expect(call.controller.state.muted, true);
      call.backend.available = null;
      await waitFor(() => !call.controller.devices.state.inputUnavailable);
      expect(call.controller.state.muted, true);
      expect(
        call.log.where((event) => event == 'microphone:true').length,
        captures,
      );
    },
  );

  test('Unplugging selected output deafens; explicit action required after reconnect', () async {
    final call = DeviceCall();
    addTearDown(call.close);
    await call.join();
    await call.controller.devices.select(call.backend.speaker);
    await call.controller.toggleMicrophone();
    call.backend.available = [call.backend.microphone];
    await waitFor(
      () => call.controller.state.deafened && !call.controller.state.busy,
    );
    expect(call.controller.state.muted, true);
    expect(call.log, contains('deafen:true'));
    await call.controller.toggleDeafened();
    expect(call.controller.state.deafened, true);
    call.backend.available = null;
    await waitFor(() => !call.controller.devices.state.outputUnavailable);
    expect(call.controller.state.deafened, true);
    await call.controller.toggleDeafened();
    expect(call.controller.state.deafened, false);
    expect(call.controller.state.muted, true);
  });

  test(
    'Saved choices apply before joining without enabling microphone',
    () async {
      final first = DeviceCall();
      await first.join();
      await first.controller.devices.select(first.backend.microphone);
      await first.controller.devices.select(first.backend.speaker);
      await first.close();
      final next = DeviceCall();
      addTearDown(next.close);
      await next.join();
      expect(next.backend.selected, [
        next.backend.microphone,
        next.backend.speaker,
      ]);
      expect(next.controller.state.muted, true);
      expect(next.log, isNot(contains('microphone:true')));
    },
  );
}
