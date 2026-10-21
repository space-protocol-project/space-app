part of 'voice_desktop_probe.dart';

// Доступен только в отдельной debug-сборке. adb reverse ведёт к одноразовому
// loopback-стенду; ключи и профиль установленного Space не используются.
const _androidProbe = 'http://127.0.0.1:8766';
bool androidProbeRecovery = false;

class AndroidUsbVoiceNetwork extends VoiceNetworkSettings {
  AndroidUsbVoiceNetwork(this.source) : super.local();
  final VoiceNetworkSettings source;

  @override
  Map<String, dynamic> get peerConfiguration => {
    ...source.peerConfiguration,
    'iceServers': [
      for (final entry in source.iceServers)
        {
          ...entry,
          'urls': [
            for (final url in entry['urls'] as List<String>)
              url.replaceFirst(RegExp(r'(?<=turn:)[^:]+'), '127.0.0.1'),
          ],
        },
    ],
  };
}

Future<String?> androidProbeRequest(String name, {String? value}) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse('$_androidProbe/$name');
    final request = await client.openUrl(value == null ? 'GET' : 'PUT', uri);
    if (value != null) {
      final bytes = utf8.encode(value);
      request.contentLength = bytes.length;
      request.add(bytes);
    }
    final response = await request.close().timeout(const Duration(seconds: 5));
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw StateError('Ошибка стенда: ${response.statusCode}');
    }
    return body;
  } finally {
    client.close(force: true);
  }
}

Future<void> androidProbeBarrier(String name) async {
  final clock = Stopwatch()..start();
  while (await androidProbeRequest(name) == null) {
    if (clock.elapsed > const Duration(seconds: 60)) {
      throw StateError('Нет этапа $name');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<List<String>> androidProbeArguments() async {
  final config = jsonDecode(
    (await androidProbeRequest('config'))!,
  ) as Map<String, dynamic>;
  final id = config['id'] as String;
  androidProbeRecovery = config['recovery'] == true;
  if (!RegExp(r'^[a-f0-9]{32}$').hasMatch(id)) {
    throw StateError('Неверный стенд');
  }
  return [
    config['origin'] as String,
    '${Directory.systemTemp.path}/voice-check-$id',
    'B',
  ];
}

void showAndroidProbe(VoiceController controller) => runApp(
  MaterialApp(
    theme: ThemeData.dark(),
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      appBar: AppBar(title: const Text('Space · Android ↔ Windows')),
      body: VoiceParticipants(controller: controller),
      bottomNavigationBar: VoiceCallBar(controller: controller),
    ),
  ),
);

Future<void> checkAndroidAudio(
  Directory work,
  VoiceController controller,
  ProbeMedia media,
) async {
  await controller.devices.updateAudio(
    voiceDefaultAudio.copyWith(pushToTalk: true),
  );
  voiceTouchTransmission.value = true;
  await expectTransmission(media, true);
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.inactive,
  );
  await expectTransmission(media, false);
  WidgetsBinding.instance.handleAppLifecycleStateChanged(
    AppLifecycleState.resumed,
  );
  await expectTransmission(media, false);
  voiceTouchTransmission.value = true;
  await expectTransmission(media, true);
  voiceTouchTransmission.value = false;
  await expectTransmission(media, false);
  final results = <String, Object>{};
  for (final mode in [
    VoiceNoiseSuppression.webrtc,
    VoiceNoiseSuppression.deepFilter,
  ]) {
    final clock = Stopwatch()..start();
    await controller.devices.updateAudio(VoiceAudioSettings(noiseMode: mode));
    if (controller.state.muted) await controller.toggleMicrophone();
    if (controller.state.muted) throw StateError(controller.state.error);
    final before = await packetCounts(media);
    await Future<void>.delayed(const Duration(seconds: 3));
    final after = await packetCounts(media);
    if (after['sent']! <= before['sent']! ||
        after['samples']! <= before['samples']!) {
      throw StateError('Нет аудио после включения $mode');
    }
    final processing = await const MethodChannel('FlutterWebRTC.Method')
        .invokeMapMethod<String, dynamic>('spaceVoiceProcessingStats');
    results[mode.name] = {
      'milliseconds': clock.elapsedMilliseconds,
      ...after,
      'processing': processing,
    };
  }
  await controller.devices.updateAudio(voiceDefaultAudio);
  if (controller.state.muted) await controller.toggleMicrophone();
  await flag(work, 'B-processing', jsonEncode(results));
  await flag(work, 'B-background-ready', 'ready');
  await androidProbeBarrier('background-started');
  final before = await packetCounts(media);
  await Future<void>.delayed(const Duration(seconds: 4));
  final after = await packetCounts(media);
  if (controller.state.muted ||
      after['sent']! <= before['sent']! ||
      after['samples']! <= before['samples']!) {
    throw StateError('Разговор остановился в фоне');
  }
  await flag(work, 'B-background-pass', jsonEncode(after));
  await androidProbeBarrier(
    androidProbeRecovery ? 'background-checked' : 'foreground-restored',
  );
}
