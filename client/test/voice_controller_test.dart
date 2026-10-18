import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_client/src/voice_network.dart';
import 'package:space_client/src/voice_signaling.dart';

class FakeVoiceMedia implements VoiceMedia {
  FakeVoiceMedia(this.log)
    : stream = StreamController<VoiceMediaStatus>.broadcast(
        sync: true,
        onCancel: () => log.add("media:cancel"),
      );
  final List<String> log;
  final StreamController<VoiceMediaStatus> stream;
  bool denied = false, closed = false;
  @override
  Stream<VoiceMediaStatus> get changes => stream.stream;
  @override
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]) async {
    log.add('offer');
    return 'audio offer';
  }

  @override
  Future<void> answer(String sdp) async {
    log.add('answer');
    stream.add(VoiceMediaStatus.connected);
  }

  @override
  Future<void> microphone(bool enabled) async {
    log.add('microphone:$enabled');
    if (enabled && denied) {
      throw StateError('Разрешение микрофона отклонено');
    }
  }

  @override
  Future<void> deafen(bool enabled) async {
    log.add('deafen:$enabled');
  }

  @override
  Future<void> close() async {
    closed = true;
    log.add('media:close');
    unawaited(stream.close());
  }
}

class FakeVoiceApi implements VoiceSignaling {
  FakeVoiceApi(this.log)
    : closing = StreamController<void>.broadcast(
        sync: true,
        onCancel: () => log.add("api:cancel"),
      );
  final List<String> log;
  final StreamController<void> closing;
  Completer<JoinVoiceRoomResponse>? pending;
  bool failed = false, canPublish = true, configurationDenied = false;
  @override
  Stream<void> get disconnected => closing.stream;
  @override
  Future<VoiceNetworkSettings> configure(String room) async {
    log.add('configure');
    if (configurationDenied) {
      throw StateError('Доступ к комнате отозван');
    }
    return const VoiceNetworkSettings.local();
  }

  VoiceRoomState get roster => VoiceRoomState(
    capacity: 2,
    canPublish: canPublish,
    participants: [
      VoiceParticipant(sessionId: 'local', nickname: 'Алиса', muted: true),
      VoiceParticipant(sessionId: 'other', nickname: 'Борис', muted: false),
    ],
  );
  JoinVoiceRoomResponse get reply => JoinVoiceRoomResponse(
    sessionId: 'local',
    answerSdp: 'audio answer',
    state: roster,
  );
  @override
  Future<JoinVoiceRoomResponse> join(String room, String offer) async {
    log.add('join');
    return pending?.future ?? reply;
  }

  @override
  Future<VoiceRoomState> update(
    String room,
    String id,
    bool muted,
    bool deafened,
  ) async {
    log.add('update:$muted:$deafened');
    if (failed) {
      throw StateError('Сеть недоступна');
    }
    return roster;
  }

  @override
  Future<void> leave(String room, String id) async {
    log.add('leave:$id');
  }
}

Future<void> waitFor(bool Function() condition) async {
  final until = DateTime.now().add(const Duration(seconds: 2));
  while (!condition()) {
    if (DateTime.now().isAfter(until)) {
      throw StateError('Ожидание не завершилось');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

void main() {
  test('Отказ конфигурации не запускает ICE или захват микрофона', () async {
    final log = <String>[];
    final media = FakeVoiceMedia(log),
        api = FakeVoiceApi(log)..configurationDenied = true;
    final controller = VoiceController(mediaFactory: () => media);
    addTearDown(controller.close);
    await controller.join(api, 'room', 'Комната');
    expect(controller.state.phase, VoicePhase.failed);
    expect(log, contains('configure'));
    expect(log, isNot(contains('offer')));
    expect(log, isNot(contains('microphone:true')));
    expect(media.closed, true);
  });
  test('Отзыв права говорить останавливает локальный микрофон', () async {
    final log = <String>[];
    final media = FakeVoiceMedia(log), api = FakeVoiceApi(log);
    final controller = VoiceController(
      mediaFactory: () => media,
      heartbeat: const Duration(milliseconds: 20),
    );
    addTearDown(controller.close);
    await controller.join(api, 'room', 'Комната');
    await controller.toggleMicrophone();
    final before = log.length;
    api.canPublish = false;
    await waitFor(() => !controller.state.canPublish);
    expect(controller.state.muted, true);
    expect(log.skip(before), contains('microphone:false'));
    expect(controller.state.phase, VoicePhase.connected);
  });
  test('Вход без микрофона, право сервера до захвата, звук и выход', () async {
    final log = <String>[];
    final api = FakeVoiceApi(log);
    final shared = FakeVoiceMedia(log);
    final controller = VoiceController(
      mediaFactory: () => shared,
      heartbeat: const Duration(days: 1),
    );
    addTearDown(controller.close);
    await controller.join(api, 'room', 'Комната');
    expect(controller.state.phase, VoicePhase.connected);
    expect(controller.state.roster!.participants.length, 2);
    expect(log, isNot(contains('microphone:true')));
    await controller.toggleMicrophone();
    expect(
      log.indexOf('update:false:false'),
      lessThan(log.indexOf('microphone:true')),
    );
    expect(controller.state.muted, false);
    await controller.toggleDeafened();
    expect(controller.state.deafened, true);
    expect(controller.state.muted, true);
    expect(log, contains('deafen:true'));
    await controller.toggleMicrophone();
    expect(log.where((e) => e == 'microphone:true').length, 1);
    await controller.toggleDeafened();
    expect(controller.state.deafened, false);
    expect(controller.state.muted, true);
    await controller.leave();
    expect(shared.closed, true);
    expect(log.indexOf('media:close'), lessThan(log.indexOf('leave:local')));
    expect(controller.state.phase, VoicePhase.idle);
  });

  test(
    'Отказ микрофона возвращает серверу muted, не разрывая прослушивание',
    () async {
      final log = <String>[];
      final media = FakeVoiceMedia(log)..denied = true;
      final api = FakeVoiceApi(log);
      final controller = VoiceController(
        mediaFactory: () => media,
        heartbeat: const Duration(days: 1),
      );
      addTearDown(controller.close);
      await controller.join(api, 'room', 'Комната');
      await controller.toggleMicrophone();
      expect(controller.state.phase, VoicePhase.connected);
      expect(controller.state.muted, true);
      expect(controller.state.busy, false);
      expect(controller.state.error, isNotEmpty);
      expect(log.last, 'update:true:false');
    },
  );

  test(
    'Выход до ответа Join закрывает позднее серверное подключение',
    () async {
      final log = <String>[];
      final media = FakeVoiceMedia(log),
          api = FakeVoiceApi(log)..pending = Completer();
      final controller = VoiceController(mediaFactory: () => media);
      addTearDown(controller.close);
      final joining = controller.join(api, 'room', 'Комната');
      await waitFor(() => log.contains('join'));
      await controller.leave();
      api.pending!.complete(api.reply);
      await joining;
      expect(media.closed, true);
      expect(log, contains('leave:local'));
      expect(controller.state.phase, VoicePhase.idle);
    },
  );

  test('Двойной вход не создаёт второй медиаклиент', () async {
    final log = <String>[];
    final api = FakeVoiceApi(log)..pending = Completer();
    var created = 0;
    final controller = VoiceController(
      mediaFactory: () {
        created++;
        return FakeVoiceMedia(log);
      },
    );
    addTearDown(controller.close);
    final first = controller.join(api, 'room', 'Комната');
    await waitFor(() => log.contains('join'));
    await controller.join(api, 'another', 'Другая');
    expect(created, 1);
    api.pending!.complete(api.reply);
    await first;
    expect(controller.state.room, 'room');
  });

  test('Обрыв сети завершает медиа и таймер', () async {
    final log = <String>[];
    final api = FakeVoiceApi(log), media = FakeVoiceMedia(log);
    final controller = VoiceController(
      mediaFactory: () => media,
      heartbeat: const Duration(milliseconds: 10),
    );
    addTearDown(controller.close);
    await controller.join(api, 'room', 'Комната');
    api.failed = true;
    await waitFor(() => controller.state.phase == VoicePhase.failed);
    expect(media.closed, true);
    final count = log.length;
    await Future<void>.delayed(const Duration(milliseconds: 35));
    expect(log.length, count);
  });

  test('Закрытие пространства немедленно завершает голос', () async {
    final log = <String>[];
    final api = FakeVoiceApi(log), media = FakeVoiceMedia(log);
    final controller = VoiceController(
      mediaFactory: () => media,
      heartbeat: const Duration(days: 1),
    );
    addTearDown(controller.close);
    await controller.join(api, 'room', 'Комната');
    api.closing.add(null);
    await waitFor(() => media.closed);
    await waitFor(() => controller.state.phase == VoicePhase.idle);
  });
}
