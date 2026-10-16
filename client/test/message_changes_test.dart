import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/ui/message_actions.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'stream_test.dart' as fixture;

class ChangingSession extends fixture.Session implements MessageChanges {
  Content message = Content(
    id: 'message-1',
    channelId: 'general',
    authorId: 'u_test',
    text: 'До изменения',
    revision: Int64.ONE,
    sequence: Int64.ONE,
  );
  Object? failure;

  @override
  Future<List<Content>> messages() async => [message];

  @override
  Future<Content> updateMessage(Content message, String text) async {
    if (failure != null) throw failure!;
    return this.message = message.deepCopy()
      ..text = text
      ..revision = message.revision + Int64.ONE
      ..updatedAtUnixMs = Int64(1000);
  }

  @override
  Future<Content> deleteMessage(Content message) async {
    if (failure != null) throw failure!;
    return this.message = message.deepCopy()
      ..text = ''
      ..deleted = true
      ..revision = message.revision + Int64.ONE;
  }
}

void main() {
  test('Правки, конфликт и удаление обновляют историю и избранное', () async {
    final session = ChangingSession();
    final controller = await fixture.connect(session);
    addTearDown(controller.dispose);
    final original = controller.state.messages.single;
    expect(controller.canChangeMessage(original), isTrue);
    expect(
      controller.canChangeMessage(original.deepCopy()..authorId = 'other'),
      isFalse,
    );
    await controller.toggleFavorite(original);
    expect(controller.isFavorite(original), isTrue);
    session.failure = const GrpcError.aborted('Конфликт');
    expect(await controller.updateMessage(original, 'Не сохранено'), isFalse);
    expect(controller.state.messages.single.text, 'До изменения');
    session.failure = null;
    expect(await controller.updateMessage(original, 'После изменения'), isTrue);
    expect(controller.state.messages.single.text, 'После изменения');
    // Старое событие не перезаписывает более свежий ответ операции.
    session.streams.single.add(
      SubscribeResponse(
        cursor: 'event-1',
        event: Event(
          cursor: 'event-1',
          type: 'content.created',
          content: original,
        ),
      ),
    );
    await fixture.settle();
    expect(controller.state.messages.single.text, 'После изменения');
    expect(
      await controller.deleteMessage(controller.state.messages.single),
      isTrue,
    );
    expect(controller.state.messages.single.deleted, isTrue);
    expect(controller.state.messages.single.text, isEmpty);
    expect(controller.isFavorite(original), isFalse);
    expect(
      controller.canChangeMessage(controller.state.messages.single),
      isFalse,
    );
    await controller.flushHistory();
  });

  test('События другого устройства изменяют и удаляют сообщение', () async {
    final session = ChangingSession();
    final controller = await fixture.connect(session);
    addTearDown(controller.dispose);
    await controller.toggleFavorite(session.message);
    final updated = session.message.deepCopy()
      ..text = 'Правка с другого устройства'
      ..revision = Int64(2);
    session.streams.single.add(
      SubscribeResponse(
        cursor: 'event-2',
        event: Event(
          cursor: 'event-2',
          type: 'content.updated',
          content: updated,
        ),
      ),
    );
    await fixture.settle();
    expect(controller.state.messages.single.text, updated.text);
    final deleted = updated.deepCopy()
      ..text = ''
      ..deleted = true
      ..revision = Int64(3);
    session.streams.single.add(
      SubscribeResponse(
        cursor: 'event-3',
        event: Event(
          cursor: 'event-3',
          type: 'content.deleted',
          content: deleted,
        ),
      ),
    );
    await fixture.settle();
    expect(controller.state.messages.single.deleted, isTrue);
    expect(controller.state.favorites, isEmpty);
    expect(controller.cursor, 'event-3');
  });

  testWidgets(
    'Редактор сохраняет введённый текст при ошибке и удаляет после подтверждения',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final session = ChangingSession();
      final controller = (await tester.runAsync(
        () => fixture.connect(session),
      ))!;
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: ChatView(controller: controller, openConnection: () {}),
          ),
        ),
      );
      await tester.enterText(
        find.byKey(const ValueKey('chat-draft')),
        'Черновик',
      );
      await tester.tap(find.byTooltip('Действия с сообщением'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Редактировать'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .controller!
            .text,
        'До изменения',
      );
      await tester.enterText(
        find.byKey(const ValueKey('chat-draft')),
        'Отменённая правка',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .controller!
            .text,
        'Черновик',
      );
      expect(controller.state.messages.single.text, 'До изменения');
      await tester.tap(find.byTooltip('Действия с сообщением'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Редактировать'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('chat-draft')),
        'Мой новый текст',
      );
      session.failure = const GrpcError.unavailable('Нет сети');
      await tester.runAsync(() async {
        await tester.tap(find.byTooltip('Сохранить'));
        await fixture.settle();
      });
      await tester.pumpAndSettle();
      expect(find.text('Мой новый текст'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
      session.failure = null;
      await tester.runAsync(() async {
        await tester.tap(find.byTooltip('Сохранить'));
        await fixture.settle();
      });
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(controller.state.messages.single.text, 'Мой новый текст');
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
            .controller!
            .text,
        'Черновик',
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: MessageActions(
              controller: controller,
              message: session.message,
              onEdit: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Действия с сообщением'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Удалить'));
      await tester.pumpAndSettle();
      expect(controller.state.messages.single.deleted, isFalse);
      await tester.runAsync(() async {
        await tester.tap(find.widgetWithText(FilledButton, 'Удалить'));
        await fixture.settle();
      });
      await tester.pumpAndSettle();
      expect(controller.state.messages.single.deleted, isTrue);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const Scaffold(
            body: MessageBubble(
              text: '',
              author: '',
              mine: true,
              deleted: true,
            ),
          ),
        ),
      );
      expect(find.text('Сообщение удалено'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
