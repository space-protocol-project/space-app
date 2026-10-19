import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/voice_connection_info.dart';
import 'package:space_client/src/voice_controller.dart';
import 'package:space_client/ui/voice_connection_info.dart';

import 'voice_controller_test.dart' show FakeVoiceApi, FakeVoiceMedia;

StatsReport report(String id, String type, Map<String, dynamic> values) =>
    StatsReport(id, type, 0, values);

List<StatsReport> stats({String local = 'host', dynamic delay = 0.123}) => [
  report('transport', 'transport', {'selectedCandidatePairId': 'chosen'}),
  report('unused', 'candidate-pair', {
    'selected': true,
    'currentRoundTripTime': 9,
    'localCandidateId': 'relay',
  }),
  report('chosen', 'candidate-pair', {
    'currentRoundTripTime': delay,
    'localCandidateId': 'local',
    'remoteCandidateId': 'remote',
  }),
  report('local', 'local-candidate', {'candidateType': local}),
  report('remote', 'remote-candidate', {'candidateType': 'srflx'}),
];

class DiagnosticMedia extends FakeVoiceMedia implements VoiceConnectionMedia {
  DiagnosticMedia(super.log);
  Future<VoiceConnectionInfo> Function() read = () async =>
      const VoiceConnectionInfo(route: VoiceRoute.relay, roundTripMs: 42);
  int calls = 0;
  @override
  Future<VoiceConnectionInfo> connectionInfo() {
    calls++;
    return read();
  }
}

void main() {
  test('Маршрут берётся из transport, а не из посторонней пары ICE', () {
    final info = VoiceConnectionInfo.fromStats(stats());
    expect(info.route, VoiceRoute.direct);
    expect(info.roundTripMs, 123);
    expect(
      VoiceConnectionInfo.fromStats(stats(local: 'relay')).route,
      VoiceRoute.relay,
    );
    final remoteRelay = stats();
    remoteRelay.last.values['candidateType'] = 'relay';
    expect(VoiceConnectionInfo.fromStats(remoteRelay).route, VoiceRoute.relay);
  });

  test(
    'Нельзя угадать маршрут по nominated или неполному набору кандидатов',
    () {
      expect(VoiceConnectionInfo.fromStats([]).route, VoiceRoute.unknown);
      final nominated = [
        report('pair', 'candidate-pair', {'nominated': true}),
      ];
      expect(
        VoiceConnectionInfo.fromStats(nominated).route,
        VoiceRoute.unknown,
      );
      final missing = stats()..removeLast();
      expect(VoiceConnectionInfo.fromStats(missing).route, VoiceRoute.unknown);
      final selected = stats()
        ..removeAt(0)
        ..removeAt(0);
      selected.first.values['selected'] = true;
      expect(VoiceConnectionInfo.fromStats(selected).route, VoiceRoute.direct);
      selected.add(report('other', 'candidate-pair', {'selected': true}));
      expect(VoiceConnectionInfo.fromStats(selected).route, VoiceRoute.unknown);
    },
  );

  test('Отсутствующий или некорректный RTT не превращается в нулевой', () {
    for (final invalid in [null, -1, double.nan, double.infinity, 61, '0.1']) {
      expect(
        VoiceConnectionInfo.fromStats(stats(delay: invalid)).roundTripMs,
        isNull,
      );
    }
    expect(VoiceConnectionInfo.fromStats(stats(delay: 0)).roundTripMs, 0);
  });

  test(
    'Тайм-аут статистики не блокирует heartbeat и не восстанавливает медиа',
    () {
      fakeAsync((clock) {
        final log = <String>[];
        final media = DiagnosticMedia(log);
        final controller = VoiceController(mediaFactory: () => media);
        controller.join(FakeVoiceApi(log), 'room', 'Комната');
        clock.flushMicrotasks();
        expect(controller.state.connection.roundTripMs, 42);
        final pending = Completer<VoiceConnectionInfo>();
        media.read = () => pending.future;
        clock.elapse(const Duration(seconds: 3));
        clock.flushMicrotasks();
        final updates = log.where((item) => item.startsWith('update:')).length;
        clock.elapse(const Duration(seconds: 2));
        clock.flushMicrotasks();
        expect(controller.state.connection.route, VoiceRoute.unknown);
        expect(controller.state.phase, VoicePhase.connected);
        clock.elapse(const Duration(seconds: 1));
        clock.flushMicrotasks();
        expect(
          log.where((item) => item.startsWith('update:')).length,
          greaterThan(updates),
        );
        expect(media.closed, false);
        expect(media.calls, 2);
        expect(log, isNot(contains('microphone:true')));
        controller.leave();
        clock.flushMicrotasks();
        pending.complete(const VoiceConnectionInfo(roundTripMs: 999));
        clock.flushMicrotasks();
        expect(controller.state.phase, VoicePhase.idle);
        expect(controller.state.connection.roundTripMs, isNull);
        controller.close();
        clock.flushMicrotasks();
      });
    },
  );

  test('Поздняя статистика прежнего соединения не меняет новое', () {
    fakeAsync((clock) {
      final log = <String>[];
      final pending = Completer<VoiceConnectionInfo>();
      final old = DiagnosticMedia(log)..read = () => pending.future;
      final next = DiagnosticMedia(log);
      var first = true;
      final controller = VoiceController(
        mediaFactory: () {
          if (first) {
            first = false;
            return old;
          }
          return next;
        },
      );
      final api = FakeVoiceApi(log);
      controller.join(api, 'old', 'Прежняя');
      clock.flushMicrotasks();
      controller.join(api, 'new', 'Новая');
      clock.flushMicrotasks();
      expect(controller.state.room, 'new');
      expect(controller.state.connection.roundTripMs, 42);
      pending.complete(const VoiceConnectionInfo(roundTripMs: 999));
      clock.flushMicrotasks();
      expect(controller.state.connection.roundTripMs, 42);
      controller.close();
      clock.flushMicrotasks();
    });
  });

  test('Ошибка статистики не выключает разговор, следующий опрос возможен', () {
    fakeAsync((clock) {
      final log = <String>[];
      final media = DiagnosticMedia(log)
        ..read = () => throw StateError('Статистика недоступна');
      final controller = VoiceController(mediaFactory: () => media);
      controller.join(FakeVoiceApi(log), 'room', 'Комната');
      clock.flushMicrotasks();
      expect(controller.state.phase, VoicePhase.connected);
      expect(controller.state.connection.roundTripMs, isNull);
      media.read = () async => const VoiceConnectionInfo(roundTripMs: 78);
      clock.elapse(const Duration(seconds: 3));
      clock.flushMicrotasks();
      expect(controller.state.connection.roundTripMs, 78);
      expect(media.closed, false);
      controller.close();
      clock.flushMicrotasks();
    });
  });

  for (final locale in ['ru', 'en', 'zh']) {
    testWidgets('Диагностика помещается на узком экране: $locale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: VoiceConnectionDetails(
              info: VoiceConnectionInfo(
                route: VoiceRoute.relay,
                roundTripMs: 123,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('123'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
