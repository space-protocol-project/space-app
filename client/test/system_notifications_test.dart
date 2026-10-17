import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/system_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final platform in [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ]) {
    test('Системный адаптер: замена, нажатие и очистка на $platform', () async {
      debugDefaultTargetPlatformOverride = platform;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      const channel = MethodChannel('local_notifier');
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call);
            return call.method == 'setup' ? true : null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      final service = SystemNotifications();
      addTearDown(service.dispose);
      final taps = <String>[];
      final subscription = service.targets.stream.listen(taps.add);
      addTearDown(subscription.cancel);
      await service.show(
        id: 42,
        title: 'Space',
        body: 'Новое сообщение',
        target: ['https://secret.example', 'me', 'general', 1],
      );
      await service.show(
        id: 42,
        title: 'Space',
        body: 'Новое сообщение',
        target: ['https://secret.example', 'me', 'general', 2],
      );
      final sent = calls.where((call) => call.method == 'notify').toList();
      expect(sent, hasLength(2));
      final actions = (sent.last.arguments as Map)['actions'] as List;
      expect(actions.length, platform == TargetPlatform.linux ? 1 : 0);
      expect(
        jsonEncode(sent.last.arguments),
        isNot(contains('secret.example')),
      );
      Future<void> click() async {
        await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .handlePlatformMessage(
              'local_notifier',
              const StandardMethodCodec().encodeMethodCall(
                MethodCall(
                  platform == TargetPlatform.linux
                      ? 'onLocalNotificationClickAction'
                      : 'onLocalNotificationClick',
                  {'notificationId': 'space-42', 'actionIndex': 0},
                ),
              ),
              (_) {},
            );
        await Future<void>.delayed(Duration.zero);
      }

      await click();
      expect(jsonDecode(taps.single).last, 2);
      await service.clear();
      await click();
      expect(taps, hasLength(1));
    });
  }
}
