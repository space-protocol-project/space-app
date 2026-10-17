import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_notifications.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/notification_settings.dart';

Channel channel(int sequence, {bool read = true, bool encrypted = false}) =>
    Channel(
      id: 'general',
      title: 'Чат',
      latestMessageSequence: Int64(sequence),
      permissions: ChannelPermissions(visible: true, read: read),
      mlsGroupId: encrypted ? [1] : [],
    );
ChatState state(
  int sequence, {
  String principal = 'me',
  bool connected = true,
  bool read = true,
  bool encrypted = false,
  List<Content> messages = const [],
  int unread = 1,
}) => ChatState(
  origin: 'https://saved.example',
  principalId: principal,
  connected: connected,
  channels: [channel(sequence, read: read, encrypted: encrypted)],
  messages: messages,
  unreadCounts: {'general': unread},
);

void main() {
  testWidgets('Включение на узком экране не сохраняется при отказе системы', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = AppPreferences();
    addTearDown(preferences.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 390,
            child: NotificationSettings(
              preferences: preferences,
              requestPermission: () async => false,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(DropdownButtonFormField<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Скрывать содержимое').last);
    await tester.pumpAndSettle();
    expect(preferences.notificationMode, 0);
    expect(
      find.text(
        'Не удалось разрешить уведомления. Проверьте системные настройки.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
  test('Нажатие не принимает подменённую личность, закрытый канал или неверную цель', () {
    final target = ChatNotificationTarget.decode(
      '["https://saved.example","me","general",2]',
    )!;
    expect(target.accessible(state(2)), isTrue);
    expect(target.accessible(state(2, principal: 'other')), isFalse);
    expect(target.accessible(state(2, read: false)), isFalse);
    expect(target.accessible(state(2, encrypted: true)), isFalse);
    for (final payload in [
      '{}',
      '[]',
      '[1,2,3,4]',
      '["x","me","general",-1]',
      'не JSON',
    ]) {
      expect(ChatNotificationTarget.decode(payload), isNull);
    }
  });
  test('Начальная история, повторы, откат и переподключение не дублируют уведомления', () {
    final tracker = ChatNotificationTracker();
    expect(tracker.observe(state(100)), isEmpty);
    expect(tracker.observe(state(101)).single.sequence, 101);
    expect(tracker.observe(state(101)), isEmpty);
    expect(tracker.observe(state(99)), isEmpty);
    expect(tracker.observe(state(101, connected: false)), isEmpty);
    expect(tracker.observe(state(101)), isEmpty);
    expect(tracker.observe(state(110)).single.sequence, 110);
  });
  test('Настройки и границы личности, прав, прочтения и MLS', () {
    final tracker = ChatNotificationTracker();
    tracker.observe(state(1));
    expect(tracker.observe(state(2, principal: 'other')), isEmpty);
    expect(tracker.observe(state(3, read: false)), isEmpty);
    expect(tracker.observe(state(4)), isEmpty);
    expect(tracker.observe(state(5, unread: 0)), isEmpty);
    expect(tracker.observe(state(6, encrypted: true)), isEmpty);
    tracker.retainOrigins([]);
    expect(tracker.observe(state(7)), isEmpty);
  });
  test(
    'Собственное, удалённое и правка уже известного сообщения не уведомляют',
    () {
      final tracker = ChatNotificationTracker();
      tracker.observe(state(1));
      final message = Content(
        id: 'm',
        channelId: 'general',
        authorId: 'me',
        sequence: Int64(2),
      );
      expect(tracker.observe(state(2, messages: [message])), isEmpty);
      message.authorId = 'other';
      message.sequence = Int64(3);
      message.deleted = true;
      expect(tracker.observe(state(3, messages: [message])), isEmpty);
      message.deleted = false;
      message.revision = Int64(5);
      expect(tracker.observe(state(3, messages: [message])), isEmpty);
    },
  );
  test('Режим по умолчанию выключен и сохраняется после перезапуска', () async {
    SharedPreferences.setMockInitialValues({});
    final first = AppPreferences();
    await first.load();
    expect(first.notificationMode, 0);
    await first.changeNotifications(1);
    final second = AppPreferences();
    await second.load();
    expect(second.notificationMode, 1);
    await second.changeNotifications(99);
    expect(second.notificationMode, 0);
    first.dispose();
    second.dispose();
  });
}
