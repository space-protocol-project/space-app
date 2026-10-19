import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/voice_devices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_media.dart';

import 'package:space_client/src/voice_devices.dart';

class DevicesBackend implements VoiceDeviceBackend {
  final microphone = const VoiceDevice('mic', 'Microphone', input: true);
  final speaker = const VoiceDevice('speaker', 'Speaker', input: false);
  Object? error;
  Completer<void>? pending;
  final selected = <VoiceDevice>[];
  List<VoiceDevice>? available;
  Completer<List<VoiceDevice>>? listing;
  @override
  Future<List<VoiceDevice>> devices() async =>
      listing?.future ?? available ?? [microphone, speaker];
  @override
  Future<void> select(VoiceDevice device) async {
    selected.add(device);
    await pending?.future;
    if (error != null) throw error!;
  }
}

class FailingDevicePreferences extends SavedVoiceDevicePreferences {
  bool fail = true;
  @override
  Future<void> save(VoiceDeviceChoice choice) async {
    if (fail) throw StateError('disk full');
    await super.save(choice);
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'Save failure keeps active selection and warning until a successful save',
    () async {
      final backend = DevicesBackend();
      final preferences = FailingDevicePreferences();
      final controller = VoiceDevices(
        backend: backend,
        preferences: preferences,
      );
      await controller.refresh();
      await controller.select(backend.microphone);
      expect(controller.state.input, 'mic');
      expect(controller.state.error, contains('disk full'));
      await controller.refresh();
      expect(controller.state.error, contains('disk full'));
      preferences.fail = false;
      await controller.select(backend.speaker);
      expect(controller.state.error, isEmpty);
      final saved = await SavedVoiceDevicePreferences().load();
      expect(saved.input, 'mic');
      expect(saved.output, 'speaker');
      await controller.close();
    },
  );

  test('Corrupted preferences never prevent choosing another device', () async {
    for (final saved in [
      42,
      '{invalid',
      '[1]',
      '{"input":true,"output":[]}',
      '{"input":""}',
    ]) {
      SharedPreferences.setMockInitialValues({
        SavedVoiceDevicePreferences.key: saved,
      });
      final backend = DevicesBackend();
      final controller = VoiceDevices(backend: backend);
      await controller.refresh();
      expect(controller.state.error, isEmpty);
      expect(backend.selected, isEmpty);
      await controller.select(backend.microphone);
      expect((await SavedVoiceDevicePreferences().load()).input, 'mic');
      await controller.close();
    }
  });

  testWidgets('Missing selected device remains visible on a narrow screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await SavedVoiceDevicePreferences().save(
      const VoiceDeviceChoice(input: 'mic'),
    );
    final backend = DevicesBackend();
    backend.available = [backend.speaker];
    final controller = VoiceDevices(backend: backend);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VoiceDevicesDialog(devices: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Устройство отключено'), findsOneWidget);
    expect(find.textContaining('выберите другое'), findsOneWidget);
    expect(backend.selected, isEmpty);
    expect(tester.takeException(), isNull);
    backend.available = null;
    await controller.refresh();
    await tester.pumpAndSettle();
    expect(find.text('Устройство отключено'), findsNothing);
    expect(find.text('Microphone'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    await controller.close();
  });

  test(
    'Restores input and output in a new controller without capturing audio',
    () async {
      final firstBackend = DevicesBackend();
      final first = VoiceDevices(backend: firstBackend);
      await first.refresh();
      await first.select(firstBackend.microphone);
      await first.select(firstBackend.speaker);
      await first.close();
      final backend = DevicesBackend();
      final next = VoiceDevices(backend: backend);
      await next.refresh();
      expect(next.state.input, 'mic');
      expect(next.state.output, 'speaker');
      expect(backend.selected, [backend.microphone, backend.speaker]);
      await next.refresh();
      expect(backend.selected.length, 2);
      await next.close();
    },
  );

  test(
    'Missing device retains preference and is restored when reconnected',
    () async {
      final backend = DevicesBackend();
      final controller = VoiceDevices(backend: backend);
      await controller.refresh();
      await controller.select(backend.microphone);
      backend.available = [backend.speaker];
      await controller.refresh();
      expect(controller.state.inputUnavailable, true);
      expect(controller.state.input, 'mic');
      expect(backend.selected, [backend.microphone]);
      backend.available = null;
      await controller.refresh();
      expect(controller.state.inputUnavailable, false);
      expect(backend.selected, [backend.microphone, backend.microphone]);
      await controller.close();
    },
  );

  test(
    'Disconnected output does not select another available speaker',
    () async {
      await SavedVoiceDevicePreferences().save(
        const VoiceDeviceChoice(output: 'headset'),
      );
      final backend = DevicesBackend();
      final controller = VoiceDevices(backend: backend);
      await controller.refresh();
      expect(controller.state.outputUnavailable, true);
      expect(backend.selected, isEmpty);
      await controller.select(backend.speaker);
      expect(controller.state.outputUnavailable, false);
      expect((await SavedVoiceDevicePreferences().load()).output, 'speaker');
      await controller.close();
    },
  );

  test(
    'Closing while loading devices never applies saved preferences',
    () async {
      await SavedVoiceDevicePreferences().save(
        const VoiceDeviceChoice(input: 'mic'),
      );
      final backend = DevicesBackend()
        ..listing = Completer<List<VoiceDevice>>();
      final controller = VoiceDevices(backend: backend);
      final refreshing = controller.refresh();
      await Future<void>.delayed(Duration.zero);
      await controller.close();
      backend.listing!.complete([backend.microphone]);
      await refreshing;
      expect(backend.selected, isEmpty);
    },
  );

  test('Native desktop microphone selection is passed as sourceId, not playback deviceId', () {
    final constraints = voiceMicrophoneConstraints('chosen-microphone');
    final audio = constraints['audio'] as Map;
    expect(
      audio['optional'],
      contains(equals({'sourceId': 'chosen-microphone'})),
    );
    expect(audio.containsKey('deviceId'), false);
    expect(constraints['video'], false);
    expect(
      ((voiceMicrophoneConstraints(null)['audio'] as Map)['optional'] as List)
          .any((value) => (value as Map).containsKey('sourceId')),
      false,
    );
  });

  testWidgets('Device dialog selects without capturing microphone', (
    tester,
  ) async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VoiceDevicesDialog(devices: controller),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Микрофон'), findsOneWidget);
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Microphone').last);
    await tester.pumpAndSettle();
    expect(controller.state.input, 'mic');
    expect(backend.selected, [backend.microphone]);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    expect(controller.isClosed, false);
    await controller.close();
  });

  test('Input and output choices are independent', () async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    await controller.refresh();
    await controller.select(backend.microphone);
    await controller.select(backend.speaker);
    expect(controller.state.input, 'mic');
    expect(controller.state.output, 'speaker');
    expect(backend.selected, [backend.microphone, backend.speaker]);
    await controller.close();
  });

  test('Выбор по ID сохраняется после смены объектов при обновлении', () async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    addTearDown(controller.close);
    await controller.refresh();
    final old = controller.state.devices.first;
    backend.available = [
      VoiceDevice(old.id, old.label, input: true),
      backend.speaker,
    ];
    await controller.refresh();
    await controller.select(old);
    expect(controller.state.input, old.id);
  });

  test('Фоновое перечисление не теряет смену настроек рации', () async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    addTearDown(controller.close);
    await controller.refresh();
    backend.listing = Completer<List<VoiceDevice>>();
    final refresh = controller.refresh();
    final change = controller.updateAudio(
      controller.state.audio.copyWith(pushToTalk: true),
    );
    backend.listing!.complete([backend.microphone, backend.speaker]);
    await refresh;
    await change;
    expect(controller.state.audio.pushToTalk, true);
    expect((await SavedVoiceDevicePreferences().load()).audio.pushToTalk, true);
  });

  testWidgets('Подтверждённый микрофон показан после повторного открытия', (
    tester,
  ) async {
    final backend = DevicesBackend();
    var controller = VoiceDevices(backend: backend);
    Widget dialog() => MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: VoiceDevicesDialog(devices: controller),
    );
    await tester.pumpWidget(dialog());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Microphone').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>).first,
          )
          .value,
      'mic',
    );
    await tester.pumpWidget(const SizedBox());
    await controller.close();
    controller = VoiceDevices(backend: DevicesBackend());
    addTearDown(controller.close);
    await tester.pumpWidget(dialog());
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>).first,
          )
          .value,
      'mic',
    );
    expect(controller.state.error, isEmpty);
  });

  testWidgets('Неудачный выбор не показывает неприменённый микрофон', (
    tester,
  ) async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    addTearDown(controller.close);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: VoiceDevicesDialog(devices: controller),
      ),
    );
    await tester.pumpAndSettle();
    backend.error = StateError('Микрофон отключён');
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Microphone').last);
    await tester.pumpAndSettle();
    expect(controller.state.input, isNull);
    expect(
      tester
          .widget<DropdownButton<String>>(
            find.byType(DropdownButton<String>).first,
          )
          .value,
      isNull,
    );
    expect(find.textContaining('Микрофон отключён'), findsOneWidget);
  });

  test('Failed switching preserves the previous choice', () async {
    final backend = DevicesBackend();
    final controller = VoiceDevices(backend: backend);
    await controller.refresh();
    await controller.select(backend.microphone);
    backend.error = StateError('unplugged');
    await controller.select(backend.speaker);
    expect(controller.state.input, 'mic');
    expect(controller.state.output, isNull);
    expect(controller.state.error, contains('unplugged'));
    expect(controller.state.busy, false);
    await controller.close();
  });

  test(
    'Serializes switching and safely ignores completion after close',
    () async {
      final backend = DevicesBackend()..pending = Completer<void>();
      final controller = VoiceDevices(backend: backend);
      await controller.refresh();
      final switching = controller.select(backend.microphone);
      await controller.select(backend.speaker);
      expect(backend.selected, [backend.microphone]);
      await controller.close();
      backend.pending!.complete();
      await switching;
    },
  );
}
