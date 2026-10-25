// Два отдельных процесса Flutter. Только собственный loopback-стенд; без записи аудио.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_activity.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_client/src/voice_network.dart';
import 'package:space_client/src/voice_signaling.dart';
import 'package:space_client/src/voice_audio_settings.dart';
import 'package:space_client/src/voice_device_preferences.dart';
import 'package:space_client/src/voice_devices.dart';
import 'package:space_client/src/voice_shortcut.dart';
import 'package:space_client/src/voice_platform.dart';
import 'package:space_client/src/voice_transmission.dart';
import 'package:space_client/ui/voice_rooms.dart';
import 'package:space_client/l10n/app_localizations.dart';

import 'home_vault.dart';
part 'voice_desktop_checks.dart';
part 'voice_android_checks.dart';

class ProbePreferences implements VoiceDevicePreferences {
  VoiceDeviceChoice value = VoiceDeviceChoice(audio: voiceDefaultAudio);
  @override
  Future<VoiceDeviceChoice> load() async => value;
  @override
  Future<void> save(VoiceDeviceChoice choice) async {
    value = choice;
  }
}

class ProbeMedia extends NativeVoiceMedia {
  ProbeMedia(this.work, this.role) : super(playbackVolume: 0);
  final Directory work;
  final String role;
  final levels = VoiceAudioLevels();
  @override
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]) async {
    await flag(work, '$role-media', 'offer');
    final clock = Stopwatch()..start();
    final result = await super.offer(
      Platform.isAndroid ? AndroidUsbVoiceNetwork(settings) : settings,
    );
    await flag(work, '$role-offer-ms', '${clock.elapsedMilliseconds}');
    final types = RegExp(r' typ ([a-z]+)')
        .allMatches(result)
        .map((match) => match[1]!)
        .toSet();
    await flag(work, '$role-candidate-types', types.join(','));
    if (settings.relayOnly && types.any((type) => type != 'relay')) {
      throw StateError('Прямой кандидат в режиме только TURN: $types');
    }
    if (settings.relayOnly && !types.contains('relay')) {
      throw StateError(
        'TURN не выдал relay-кандидат; проверьте сетевой интерфейс и доступность ретранслятора',
      );
    }
    await flag(work, '$role-media', 'offered');
    return result;
  }

  @override
  Future<void> answer(String sdp) async {
    levels.configure(sdp);
    await flag(
      work,
      '$role-answer-tracks',
      sdp
          .split('\n')
          .where(
            (line) =>
                line.startsWith('m=') ||
                line.startsWith('a=mid:') ||
                line.startsWith('a=msid:'),
          )
          .join('\n'),
    );
    await flag(work, '$role-media', 'answer');
    final clock = Stopwatch()..start();
    await super.answer(sdp);
    await flag(work, '$role-answer-ms', '${clock.elapsedMilliseconds}');
    await flag(work, '$role-media', 'answered');
  }
}

Future<void> waitUntil(bool Function() ready) async {
  final deadline = DateTime.now().add(const Duration(seconds: 60));
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Истекло ожидание проверки');
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }
}

Future<void> flag(Directory work, String name, String value) async {
  if (Platform.isAndroid) {
    await androidProbeRequest(name, value: value);
    return;
  }
  final temporary = File('${work.path}/$name.tmp');
  await temporary.writeAsString(value, flush: true);
  await temporary.rename('${work.path}/$name');
}

Future<void> barrier(Directory work, String name) async {
  if (Platform.isAndroid) {
    await androidProbeBarrier(name);
    return;
  }
  await waitUntil(() => File('${work.path}/$name').existsSync());
}

Future<Map<String, int>> packetCounts(NativeVoiceMedia media) async {
  var sent = 0, received = 0, samples = 0;
  for (final report in await media.statistics()) {
    final values = report.values;
    int number(String key) => int.tryParse('${values[key] ?? 0}') ?? 0;
    if (report.type == 'outbound-rtp') {
      sent += number('packetsSent');
    }
    if (report.type == 'inbound-rtp') {
      received += number('packetsReceived');
      samples += number('totalSamplesReceived');
    }
  }
  return {'sent': sent, 'received': received, 'samples': samples};
}

Future<Map<String, int>> waitForAudio(NativeVoiceMedia media) async {
  final deadline = DateTime.now().add(const Duration(seconds: 15));
  while (true) {
    final counts = await packetCounts(media);
    if (counts['sent']! > 0 &&
        counts['received']! > 0 &&
        counts['samples']! > 0) {
      return counts;
    }
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('Нет двустороннего аудио: $counts');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> scenario(Directory work, String origin, String role) async {
  await flag(work, '$role-progress', 'connect');
  final server = await discover(origin);
  if (server.voiceRoomsVersion != 3) {
    throw StateError('Нет поддержки голоса');
  }
  final session = await SpaceSession.connect(server, HomeVault());
  final mediaInstances = <ProbeMedia>[];
  final devices = VoiceDevices(preferences: ProbePreferences());
  final controller = VoiceController(
    mediaFactory: () {
      final media = ProbeMedia(work, role);
      mediaInstances.add(media);
      return media;
    },
    audioDevices: devices,
    heartbeat: const Duration(milliseconds: 250),
  );
  try {
    await devices.refresh();
    final input = Platform.environment['SPACE_VOICE_INPUT_ID'];
    if (input != null) {
      final selected = devices.state.devices
          .where((device) => device.input && device.id == input)
          .firstOrNull;
      if (selected == null) throw StateError('Указанный вход недоступен');
      await devices.select(selected);
    }
    await updateParticipantName(session, role == 'A' ? 'Алиса' : 'Борис');
    String room;
    if (role == 'A') {
      if (session.role != 'owner') {
        throw StateError('Стенд не создал владельца');
      }
      room = (await session.createVoiceRoom('Разговор двух клиентов')).id;
      await flag(work, 'room', room);
    } else {
      await barrier(work, 'room');
      room = Platform.isAndroid
          ? (await androidProbeRequest('room'))!
          : await File('${work.path}/room').readAsString();
    }
    await flag(work, '$role-progress', 'join');
    await controller
        .join(SessionVoiceSignaling(session), room, 'Проверка голоса')
        .timeout(const Duration(seconds: 20));
    await waitUntil(
      () =>
          controller.state.phase == VoicePhase.connected ||
          controller.state.phase == VoicePhase.failed,
    );
    if (controller.state.phase != VoicePhase.connected) {
      throw StateError(controller.state.error);
    }
    if (!controller.state.muted) {
      throw StateError('Микрофон включился при входе');
    }
    await flag(work, '$role-joined', 'ready');
    await barrier(work, role == 'A' ? 'B-joined' : 'A-joined');
    await waitUntil(() => controller.state.roster?.participants.length == 2);
    if (Platform.isAndroid) showAndroidProbe(controller);
    await flag(work, '$role-progress', 'microphone');
    // Оба процесса используют один физический аудиодрайвер стенда.
    // Разрешения открываем по очереди, затем передаём одновременно.
    if (role == 'B') {
      await barrier(work, 'A-microphone');
    }
    await controller.toggleMicrophone();
    if (controller.state.muted) {
      throw StateError('Микрофон не включён: ${controller.state.error}');
    }
    await flag(work, '$role-microphone', 'ready');
    await barrier(work, role == 'A' ? 'B-microphone' : 'A-microphone');
    final counts = await waitForAudio(mediaInstances.last);
    final statistics = await mediaInstances.last.statistics();
    await flag(
      work,
      '$role-inbound-stats',
      jsonEncode([
        for (final report in statistics.where((r) => r.type == 'inbound-rtp'))
          {'id': report.id, 'type': report.type, ...report.values},
      ]),
    );
    final incoming = statistics
        .where((report) => report.type == 'inbound-rtp')
        .toList();
    if (incoming.isEmpty ||
        incoming.any(
          (report) => mediaInstances.last.levels.outputSlot(report) == null,
        )) {
      throw StateError('Не удалось сопоставить полученные дорожки участникам');
    }
    final people = controller.state.roster!.participants;
    if (people.any((person) => !person.hasAudioSlot())) {
      throw StateError('Сервер не передал места участников');
    }
    await flag(work, '$role-audio', jsonEncode(counts));
    await barrier(work, role == 'A' ? 'B-audio' : 'A-audio');
    await checkPushToTalk(controller, mediaInstances.last);
    if (Platform.isAndroid) {
      await checkAndroidAudio(work, controller, mediaInstances.last);
    }
    await flag(work, '$role-ptt', 'passed');
    await barrier(work, role == 'A' ? 'B-ptt' : 'A-ptt');
    if (Platform.environment['SPACE_VOICE_RECOVERY_CHECK'] == '1' ||
        androidProbeRecovery) {
      await checkReconnect(work, role, controller, mediaInstances);
    }
    await flag(work, '$role-progress', 'controls');
    if (role == 'A') {
      await aliceControls(work, controller);
    } else {
      await borisControls(work, controller);
    }
    await flag(
      work,
      '$role.json',
      jsonEncode({
        'success': true,
        'pid': pid,
        ...counts,
        'role': role,
        'pushToTalk': true,
        'input': devices.state.input,
        'reconnected': mediaInstances.length > 1,
      }),
    );
  } catch (error, stack) {
    await flag(work, '$role-failure', '$error\n$stack');
    rethrow;
  } finally {
    try {
      await controller.close().timeout(const Duration(seconds: 5));
    } finally {
      await session.close().timeout(const Duration(seconds: 5));
    }
  }
}

Future<void> aliceControls(Directory work, VoiceController controller) async {
  await controller.toggleMicrophone();
  if (!controller.state.muted) {
    throw StateError('Микрофон не выключился');
  }
  await flag(work, 'A-muted', 'ready');
  await barrier(work, 'B-deafened');
  await waitUntil(
    () =>
        controller.state.roster?.participants.any(
          (p) => p.nickname == 'Борис' && p.deafened,
        ) ==
        true,
  );
  await controller.leave();
  await flag(work, 'A-left', 'ready');
  await barrier(work, 'B-left');
}

Future<void> borisControls(Directory work, VoiceController controller) async {
  await barrier(work, 'A-muted');
  await waitUntil(
    () =>
        controller.state.roster?.participants.any(
          (p) => p.nickname == 'Алиса' && p.muted,
        ) ==
        true,
  );
  await controller.toggleDeafened();
  if (!controller.state.deafened || !controller.state.muted) {
    throw StateError('Звук не выключился');
  }
  await flag(work, 'B-deafened', 'ready');
  await barrier(work, 'A-left');
  await waitUntil(() => controller.state.roster?.participants.length == 1);
  await controller.leave();
  await flag(work, 'B-left', 'ready');
}

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid &&
      const bool.fromEnvironment('SPACE_VOICE_ANDROID_CHECK')) {
    args = await androidProbeArguments();
  }
  if (!(Platform.isAndroid &&
          const bool.fromEnvironment('SPACE_VOICE_ANDROID_CHECK')) &&
      (Platform.environment['SPACE_VOICE_DESKTOP_CHECK'] != '1' ||
          !Platform.isWindows)) {
    exit(2);
  }
  if (args.length != 3) {
    exit(2);
  }
  final uri = Uri.parse(args[0]), work = Directory(args[1]), role = args[2];
  if (uri.scheme != 'http' ||
      !InternetAddress(uri.host).isLoopback ||
      !['A', 'B'].contains(role) ||
      !RegExp(r'voice-check-[a-f0-9]{32}$').hasMatch(work.path)) {
    exit(2);
  }
  runApp(
    const Directionality(textDirection: TextDirection.ltr, child: SizedBox()),
  );
  await WidgetsBinding.instance.endOfFrame;
  try {
    await scenario(work, args[0], role);
    exit(0);
  } catch (error, stack) {
    await flag(
      work,
      '$role.json',
      jsonEncode({
        'success': false,
        'error': error.toString(),
        'stack': stack.toString(),
        'pid': pid,
      }),
    );
    exit(1);
  }
}
