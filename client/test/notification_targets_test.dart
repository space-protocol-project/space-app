import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/notification_targets.dart';
import 'package:space_client/src/system_notifications.dart';

import 'chat_history_test.dart' show HistoryKeys;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final payload = jsonEncode(['https://saved.example', 'me', 'general', 7]);
  test(
    'Цель переживает новый экземпляр, ключ одноразовый и непрозрачный',
    () async {
      final keys = HistoryKeys();
      final first = NotificationTargets(storage: keys);
      final token = await first.save(42, payload);
      expect(NotificationTargets.tokenPattern.hasMatch(token), isTrue);
      final restarted = NotificationTargets(storage: keys);
      expect(await restarted.take('wrong'), isNull);
      expect(await restarted.take(token), payload);
      expect(await restarted.take(token), isNull);
    },
  );
  test(
    'Замена, срок действия, лимит и выключение отзывают старые цели',
    () async {
      final keys = HistoryKeys();
      var now = DateTime.utc(2026, 10, 17);
      final store = NotificationTargets(storage: keys, now: () => now);
      final old = await store.save(1, payload);
      final replaced = await store.save(1, payload);
      expect(await store.take(old), isNull);
      for (var i = 2; i <= 65; i++) {
        await store.save(i, payload);
      }
      expect(await store.take(replaced), isNull);
      final expired = await store.save(100, payload);
      now = now.add(const Duration(days: 8));
      expect(await store.take(expired), isNull);
      final cleared = await store.save(100, payload);
      await store.clear();
      expect(await store.take(cleared), isNull);
    },
  );
  test(
    'Параллельные записи не теряются; повреждённый payload не сохраняется',
    () async {
      final store = NotificationTargets(storage: HistoryKeys());
      final tokens = await Future.wait(
        List.generate(12, (i) => store.save(i, payload)),
      );
      expect(tokens.toSet(), hasLength(12));
      expect(await Future.wait(tokens.map(store.take)), everyElement(payload));
      await expectLater(store.save(99, '[]'), throwsArgumentError);
    },
  );
  for (final enabled in [true, false]) {
    test(
      'Холодный запуск: ожидание слушателя, одноразовое нажатие, режим $enabled',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final store = NotificationTargets(storage: HistoryKeys());
        final token = await store.save(42, payload);
        final service = SystemNotifications(savedTargets: store);
        addTearDown(service.dispose);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              (call) async => call.method == 'initial' ? token : null,
            );
        addTearDown(
          () => TestDefaultBinaryMessengerBinding
              .instance
              .defaultBinaryMessenger
              .setMockMethodCallHandler(
                SystemNotifications.activationChannel,
                null,
              ),
        );
        final taps = <String>[];
        final subscription = service.targets.stream.listen(taps.add);
        addTearDown(subscription.cancel);
        await service.listenForActivation(enabled: enabled);
        await service.activate(token);
        await Future<void>.delayed(Duration.zero);
        expect(taps, enabled ? [payload] : isEmpty);
      },
    );
  }
}
