import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'stream_test.dart' show Session, connect;

class DeliverySession extends Session {
  final keys = <String>[];
  Completer<Content>? reply;
  @override
  Future<Content> send(String text, String key) {
    keys.add(key);
    reply = Completer<Content>();
    return reply!.future;
  }
}

void main() {
  test(
    'Нет подтверждения не означает доставку; повтор сохраняет ключ',
    () async {
      final session = DeliverySession();
      final controller = await connect(session);
      addTearDown(controller.dispose);
      final sending = controller.stream.firstWhere(
        (state) => state.sendStatus == MessageSendStatus.sending,
      );
      final queued = controller.send('Текст');
      await sending;
      expect(await queued, true);
      expect(controller.sendStatus, MessageSendStatus.sending);
      expect(controller.messages, isEmpty);
      final unconfirmed = controller.stream.firstWhere(
        (state) => state.sendStatus == MessageSendStatus.unconfirmed,
      );
      session.reply!.completeError(const GrpcError.unavailable());
      await unconfirmed;
      final key = controller.pendingMessages.single.key;
      final retryStarted = controller.stream.firstWhere(
        (state) => state.sendStatus == MessageSendStatus.sending,
      );
      await controller.retryPending(key);
      await retryStarted;
      final accepted = controller.stream.firstWhere(
        (state) => state.sendStatus == MessageSendStatus.accepted,
      );
      session.reply!.complete(
        Content(
          id: 'server-1',
          channelId: 'general',
          text: 'Текст',
          authorId: 'u_test',
          sequence: Int64.ONE,
          revision: Int64.ONE,
          createdAtUnixMs: Int64(1760000000123),
        ),
      );
      await accepted;
      expect(session.keys[0], session.keys[1]);
      expect(controller.pendingMessages, isEmpty);
      expect(controller.sendStatus, MessageSendStatus.accepted);
      expect(controller.messages.single.createdAtUnixMs, Int64(1760000000123));
      await controller.disconnect();
      expect(controller.sendStatus, MessageSendStatus.idle);
    },
  );
  testWidgets(
    'Время и одна отметка сервера помещаются в узкий пузырёк; неизвестное время скрыто',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final locale in ['ru', 'zh', 'en']) {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: MessageBubble(
                text: 'Сообщение',
                author: '',
                mine: true,
                accepted: true,
                sentAt: DateTime(2026, 10, 11, 14, 35),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byTooltip(
            lookupAppLocalizations(Locale(locale)).messageAccepted,
          ),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MessageBubble(text: 'Старое', author: '', mine: false),
          ),
        ),
      );
      expect(find.byType(Tooltip), findsNothing);
    },
  );
}
