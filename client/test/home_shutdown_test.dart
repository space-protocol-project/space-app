import 'support/chat_outbox.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/home_operation_progress.dart';

import 'channels_test.dart'
    show CatalogSession, ChannelVault, MemoryPositions, MemoryHistory;

class _HangingSession extends CatalogSession {
  final closed = Completer<void>();
  @override
  Future<void> close() => closed.future;
  Future<void> finish() async {
    closed.complete();
    await super.close();
  }
}

void main() {
  testWidgets('Проценты отключения видны сразу, включая ожидание клиента', (
    tester,
  ) async {
    final home = HomeController()..running = true;
    final closing = Completer<void>();
    addTearDown(home.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocBuilder<HomeController, HomeState>(
            bloc: home,
            builder: (_, _) => HomeOperationProgress(home: home),
          ),
        ),
      ),
    );
    final stop = home.stop(disconnectClient: () => closing.future);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(home.busy, true);
    expect(home.phase, HomePhase.stopping);
    expect(find.text('5%'), findsOneWidget);
    expect(
      tester
          .widget<CircularProgressIndicator>(
            find.byType(CircularProgressIndicator),
          )
          .value,
      .05,
    );
    closing.complete();
    await stop;
    await tester.pumpAndSettle();
    expect(home.busy, false);
    expect(home.running, false);
    expect(home.phase, HomePhase.stopped);
    expect(find.text('100%'), findsOneWidget);
  });
  test(
    'Незавершающееся закрытие клиента не оставляет busy и допускает новый вход',
    () async {
      final hanging = _HangingSession();
      final next = CatalogSession();
      var opens = 0;
      final controller = ChatController(
        ChannelVault(),
        positions: MemoryPositions(),
        historyStore: MemoryHistory(),
        outboxStore: MemoryChatOutbox(),
        openSession: (_, _) async => opens++ == 0 ? hanging : next,
      );
      final discovery = Discovery(
        Uri.parse('http://127.0.0.1:8080'),
        'srv_test',
        List.filled(32, 1),
      );
      controller.preview = discovery;
      await controller.connect();
      await controller.disconnect().timeout(const Duration(seconds: 7));
      expect(controller.busy, false);
      expect(controller.connected, false);
      expect(controller.preview, isNull);
      controller.preview = discovery;
      await controller.connect();
      expect(controller.connected, true);
      controller.dispose();
      await hanging.finish();
    },
  );
}
