import 'dart:async';
import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/local_failure.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/src/voice_media.dart';
import 'package:space_client/src/voice_network.dart';
import 'package:space_client/src/voice_recovery.dart';

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

class RecoveryApi extends FakeVoiceApi {
  RecoveryApi(super.log);
  Object? configurationError, joinError, updateError;
  Completer<JoinVoiceRoomResponse>? nextJoin;
  Completer<void>? pendingLeave;
  int configurations = 0, joins = 0;
  final left = <String>[];
  @override
  Future<VoiceNetworkSettings> configure(String room) async {
    configurations++;
    if (configurationError case final error?) throw error;
    return super.configure(room);
  }

  @override
  Future<JoinVoiceRoomResponse> join(String room, String offer) async {
    joins++;
    if (joinError case final error?) throw error;
    final pending = nextJoin;
    nextJoin = null;
    return pending?.future ??
        JoinVoiceRoomResponse(
          sessionId: 'session-$joins',
          answerSdp: 'answer',
          state: roster,
        );
  }

  @override
  Future<VoiceRoomState> update(
    String room,
    String id,
    bool muted,
    bool deafened,
  ) async {
    if (updateError case final error?) throw error;
    return super.update(room, id, muted, deafened);
  }

  @override
  Future<void> leave(String room, String id) async {
    left.add(id);
    await pendingLeave?.future;
    await super.leave(room, id);
  }
}

class SilentVoiceMedia extends FakeVoiceMedia {
  SilentVoiceMedia(super.log);
  @override
  Future<void> answer(String sdp) async {
    log.add('answer:connecting');
  }
}

class BrokenCloseMedia extends FakeVoiceMedia {
  BrokenCloseMedia(super.log);
  @override
  Future<void> close() async {
    await super.close();
    throw StateError('Не удалось закрыть медиа');
  }
}

class HoldingVoiceMedia extends FakeVoiceMedia {
  HoldingVoiceMedia(super.log);
  final pending = Completer<String>();
  @override
  Future<String> offer([
    VoiceNetworkSettings settings = const VoiceNetworkSettings.local(),
  ]) => pending.future;
}

class VoiceHarness {
  VoiceHarness(
    this.clock, {
    bool holdFirstOffer = false,
    Duration? signalingTimeout,
    FakeVoiceMedia Function(List<String>)? firstMedia,
  }) {
    api = RecoveryApi(log);
    controller = VoiceController(
      mediaFactory: () {
        final item = media.isEmpty && firstMedia != null
            ? firstMedia(log)
            : holdFirstOffer && media.isEmpty
            ? HoldingVoiceMedia(log)
            : FakeVoiceMedia(log);
        media.add(item);
        return item;
      },
      heartbeat: const Duration(seconds: 3),
      signalingTimeout: signalingTimeout ?? const Duration(seconds: 15),
    );
  }
  final FakeAsync clock;
  final log = <String>[];
  final media = <FakeVoiceMedia>[];
  late final RecoveryApi api;
  late final VoiceController controller;
  void start() {
    unawaited(controller.join(api, 'room', 'Комната'));
    clock.flushMicrotasks();
  }

  void breakMedia() {
    media.last.stream.add(VoiceMediaStatus.failed);
    clock.flushMicrotasks();
  }

  void dispose() {
    unawaited(controller.close());
    clock.flushMicrotasks();
    expect(clock.pendingTimers, isEmpty);
  }
}

void main() {
  test('Потеря аудиофокуса выключает микрофон без выхода из комнаты', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      unawaited(h.controller.toggleMicrophone());
      clock.flushMicrotasks();
      expect(h.controller.state.muted, false);
      h.media.single.stream.add(VoiceMediaStatus.microphoneInterrupted);
      clock.flushMicrotasks();
      expect(h.controller.state.muted, true);
      expect(h.controller.state.phase, VoicePhase.connected);
      expect(h.controller.state.error, contains('Аудиофокус'));
      expect(h.media.single.closed, false);
      clock.elapse(const Duration(seconds: 2));
      expect(h.controller.state.muted, true);
      expect(h.media.length, 1);
      h.dispose();
    });
  });
  test('Ошибка обработки закрывает захват без повторного входа', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      h.media.single.stream.add(VoiceMediaStatus.processingFailed);
      clock.flushMicrotasks();
      expect(h.media.single.closed, true);
      expect(h.controller.state.phase, VoicePhase.failed);
      expect(h.controller.state.muted, true);
      clock.elapse(const Duration(minutes: 1));
      expect(h.media.length, 1);
      h.dispose();
    });
  });

  test('Потеря медиа: новое соединение, новый TURN, микрофон выключен', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      unawaited(h.controller.toggleMicrophone());
      clock.flushMicrotasks();
      expect(h.controller.state.muted, false);
      h.breakMedia();
      expect(h.media.first.closed, true);
      expect(
        h.controller.state.phase,
        VoicePhase.reconnecting,
        reason: h.controller.state.error,
      );
      expect(h.controller.state.muted, true);
      clock.elapse(const Duration(seconds: 1));
      expect(h.controller.state.phase, VoicePhase.connected);
      expect(h.api.configurations, 2);
      expect(h.media.length, 2);
      expect(h.controller.state.muted, true);
      expect(h.log.where((event) => event == 'microphone:true').length, 1);
      expect(h.api.left, ['session-1']);
      h.dispose();
    });
  });

  test(
    'Длительный обрыв: задержки увеличиваются, после сети вход без микрофона',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        h.api.configurationError = const GrpcError.unavailable('offline');
        h.breakMedia();
        clock.elapse(const Duration(seconds: 30));
        expect(h.api.configurations, 6); // 1, 3, 7, 15 и 30 секунд.
        clock.elapse(const Duration(minutes: 3));
        expect(h.api.configurations, 18);
        expect(
          h.controller.state.phase,
          VoicePhase.reconnecting,
          reason: h.controller.state.error,
        );
        h.api.configurationError = null;
        clock.elapse(const Duration(seconds: 15));
        expect(h.controller.state.phase, VoicePhase.connected);
        expect(h.controller.state.muted, true);
        expect(h.log, isNot(contains('microphone:true')));
        h.dispose();
      });
    },
  );

  test(
    'Старый серверный сеанс не создаёт дубль: повтор до истечения lease',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        h.api.joinError = const GrpcError.alreadyExists('старое подключение');
        h.breakMedia();
        clock.elapse(const Duration(seconds: 30));
        expect(h.api.joins, 6);
        expect(
          h.controller.state.phase,
          VoicePhase.reconnecting,
          reason: h.controller.state.error,
        );
        h.api.joinError = null;
        clock.elapse(const Duration(seconds: 15));
        expect(h.controller.state.phase, VoicePhase.connected);
        expect(h.api.joins, 7);
        h.dispose();
      });
    },
  );

  test('Ручной выход и закрытие пространства отменяют ожидающий повтор', () {
    for (final closeSpace in [false, true]) {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        h.breakMedia();
        if (closeSpace) {
          h.api.closing.add(null);
        } else {
          unawaited(h.controller.leave());
        }
        clock.flushMicrotasks();
        clock.elapse(const Duration(minutes: 2));
        expect(h.media.length, 1);
        expect(h.controller.state.phase, VoicePhase.idle);
        h.dispose();
      });
    }
  });

  test(
    'Разрешённый канал после потери lease восстанавливается, отозванный — нет',
    () {
      for (final revoked in [false, true]) {
        fakeAsync((clock) {
          final h = VoiceHarness(clock)..start();
          h.api.updateError = const GrpcError.notFound('сеанс потерян');
          if (revoked) {
            h.api.configurationError = const GrpcError.notFound(
              'канал недоступен',
            );
          }
          clock.elapse(const Duration(seconds: 3));
          expect(
            h.controller.state.phase,
            VoicePhase.reconnecting,
            reason: h.controller.state.error,
          );
          h.api.updateError = null;
          clock.elapse(const Duration(seconds: 1));
          expect(
            h.controller.state.phase,
            revoked ? VoicePhase.failed : VoicePhase.connected,
          );
          expect(h.api.joins, revoked ? 1 : 2);
          h.dispose();
        });
      }
    },
  );

  test('Отзыв допуска и недоверенный TLS прекращают повторные подключения', () {
    for (final error in [
      const GrpcError.permissionDenied('отозван'),
      const GrpcError.unauthenticated('отозван'),
      const HandshakeException('другой ключ'),
    ]) {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        h.api.configurationError = error;
        h.breakMedia();
        clock.elapse(const Duration(minutes: 1));
        expect(h.controller.state.phase, VoicePhase.failed);
        expect(h.media.length, 2);
        h.dispose();
      });
    }
  });

  test(
    'Отключение входящего звука сохраняется до согласования нового медиа',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        unawaited(h.controller.toggleDeafened());
        clock.flushMicrotasks();
        h.breakMedia();
        clock.elapse(const Duration(seconds: 1));
        expect(h.controller.state.deafened, true);
        expect(h.controller.state.muted, true);
        expect(
          h.log.lastIndexOf('deafen:true'),
          lessThan(h.log.lastIndexOf('update:true:true')),
        );
        expect(
          h.log.lastIndexOf('update:true:true'),
          lessThan(h.log.lastIndexOf('answer')),
        );
        h.dispose();
      });
    },
  );

  test(
    'Зависший старый ICE не блокирует новую попытку и не меняет её состояние',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(clock, holdFirstOffer: true)..start();
        final old = h.media.first as HoldingVoiceMedia;
        h.breakMedia();
        clock.elapse(const Duration(seconds: 1));
        expect(h.controller.state.phase, VoicePhase.connected);
        old.pending.complete('запоздалое предложение');
        clock.flushMicrotasks();
        expect(h.api.joins, 1);
        expect(h.controller.state.phase, VoicePhase.connected);
        h.dispose();
      });
    },
  );

  test(
    'Запоздавший Join после тайм-аута закрывает только свой серверный сеанс',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(
          clock,
          signalingTimeout: const Duration(seconds: 2),
        );
        final pending = Completer<JoinVoiceRoomResponse>();
        h.api.nextJoin = pending;
        h.start();
        clock.elapse(const Duration(seconds: 3));
        expect(h.controller.state.phase, VoicePhase.connected);
        pending.complete(
          JoinVoiceRoomResponse(
            sessionId: 'late',
            answerSdp: 'answer',
            state: h.api.roster,
          ),
        );
        clock.flushMicrotasks();
        expect(h.api.left, ['late']);
        expect(h.controller.state.phase, VoicePhase.connected);
        h.dispose();
      });
    },
  );

  test('Закрытие контроллера отменяет повторы и таймеры', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      h.breakMedia();
      h.dispose();
      clock.elapse(const Duration(minutes: 1));
      expect(h.media.length, 1);
    });
  });

  test('Классификация не повторяет ошибки безопасности и протокола', () {
    expect(
      canRecoverVoice(const LocalFailure(LocalFailureCode.tlsRejected, 'ключ')),
      false,
    );
    expect(canRecoverVoice(StateError('SDP')), false);
    expect(canRecoverVoice(const GrpcError.notFound()), false);
    expect(
      canRecoverVoice(const GrpcError.notFound(), missingSession: true),
      true,
    );
  });

  test(
    'После успешного восстановления задержка снова начинается с секунды',
    () {
      fakeAsync((clock) {
        final h = VoiceHarness(clock)..start();
        h.api.configurationError = const GrpcError.unavailable();
        h.breakMedia();
        clock.elapse(const Duration(seconds: 15));
        h.api.configurationError = null;
        clock.elapse(const Duration(seconds: 15));
        expect(h.controller.state.phase, VoicePhase.connected);
        final count = h.media.length;
        h.breakMedia();
        clock.elapse(const Duration(milliseconds: 999));
        expect(h.media.length, count);
        clock.elapse(const Duration(milliseconds: 1));
        expect(h.media.length, count + 1);
        h.dispose();
      });
    },
  );

  test('Отмена зависшего входа позволяет выбрать другую комнату', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock);
      final pending = Completer<JoinVoiceRoomResponse>();
      h.api.nextJoin = pending;
      h.start();
      unawaited(h.controller.leave());
      clock.flushMicrotasks();
      unawaited(h.controller.join(h.api, 'another', 'Другая'));
      clock.flushMicrotasks();
      expect(h.controller.state.room, 'another');
      pending.complete(
        JoinVoiceRoomResponse(
          sessionId: 'old',
          answerSdp: 'answer',
          state: h.api.roster,
        ),
      );
      clock.flushMicrotasks();
      expect(h.api.left, ['old']);
      expect(h.controller.state.room, 'another');
      expect(h.controller.state.phase, VoicePhase.connected);
      expect(h.media.last.closed, false);
      h.dispose();
    });
  });

  test('Закрытие пространства прерывает восстановление с зависшим Join', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      final pending = Completer<JoinVoiceRoomResponse>();
      h.api.nextJoin = pending;
      h.breakMedia();
      clock.elapse(const Duration(seconds: 1));
      h.api.closing.add(null);
      clock.flushMicrotasks();
      pending.complete(
        JoinVoiceRoomResponse(
          sessionId: 'old',
          answerSdp: 'answer',
          state: h.api.roster,
        ),
      );
      clock.flushMicrotasks();
      clock.elapse(const Duration(minutes: 1));
      expect(h.api.left, ['session-1', 'old']);
      expect(h.controller.state.phase, VoicePhase.idle);
      expect(h.media.length, 2);
      h.dispose();
    });
  });

  test('Зависший ICE завершается по тайм-ауту и не мешает новой попытке', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock, holdFirstOffer: true)..start();
      clock.elapse(const Duration(seconds: 16));
      expect(h.controller.state.phase, VoicePhase.connected);
      (h.media.first as HoldingVoiceMedia).pending.complete('old');
      clock.flushMicrotasks();
      expect(h.api.joins, 1);
      h.dispose();
    });
  });

  test('Медиа без подтверждения соединения также восстанавливается', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock, firstMedia: SilentVoiceMedia.new)..start();
      clock.elapse(const Duration(seconds: 46));
      expect(h.media.first.closed, true);
      expect(h.controller.state.phase, VoicePhase.connected);
      expect(h.controller.state.muted, true);
      h.dispose();
    });
  });

  test('Ошибка закрытия медиа запрещает автоматическое создание нового', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock, firstMedia: BrokenCloseMedia.new)..start();
      h.breakMedia();
      clock.elapse(const Duration(minutes: 1));
      expect(h.controller.state.phase, VoicePhase.failed);
      expect(h.media.length, 1);
      h.dispose();
    });
  });

  test('Выход во время очистки старого сеанса отменяет последующий повтор', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      h.api.pendingLeave = Completer<void>();
      h.breakMedia();
      unawaited(h.controller.leave());
      clock.flushMicrotasks();
      clock.elapse(const Duration(seconds: 10));
      expect(h.controller.state.phase, VoicePhase.idle);
      expect(h.media.length, 1);
      h.api.pendingLeave!.complete();
      clock.flushMicrotasks();
      h.dispose();
    });
  });

  test('Сбой запроса отключения звука сохраняет намерение пользователя', () {
    fakeAsync((clock) {
      final h = VoiceHarness(clock)..start();
      h.api.updateError = const GrpcError.unavailable();
      unawaited(h.controller.toggleDeafened());
      clock.flushMicrotasks();
      h.api.updateError = null;
      clock.elapse(const Duration(seconds: 1));
      expect(h.controller.state.phase, VoicePhase.connected);
      expect(h.controller.state.deafened, true);
      expect(h.controller.state.muted, true);
      h.dispose();
    });
  });
}
