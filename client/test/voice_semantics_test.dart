import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/ui/voice_devices.dart';

import 'voice_devices_test.dart' show DevicesBackend;
import 'support/semantics_update_binding.dart';

void main() {
  final binding = SemanticsUpdateBinding();
  testWidgets('Ползунки в диалоге не отправляют узлы вне дерева доступности', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1100, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    final devices = VoiceDevices(backend: DevicesBackend());
    await devices.refresh();
    await devices.updateAudio(
      const VoiceAudioSettings(automaticSensitivity: false),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => VoiceDevicesDialog(devices: devices),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsNWidgets(3));
    await tester.drag(find.byType(Slider).first, const Offset(40, 0));
    await tester.pumpAndSettle();
    expect(devices.state.audio.inputGain, greaterThan(1));
    await tester.tap(find.text('Обновить устройства'));
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Закрыть'));
    await tester.pumpAndSettle();
    expect(binding.orphanUpdates, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await devices.close();
    semantics.dispose();
  });
}
