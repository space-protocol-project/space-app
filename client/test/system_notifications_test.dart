import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/system_notifications.dart';
import 'package:space_client/src/notification_targets.dart';

import 'chat_history_test.dart' show HistoryKeys;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  for (final platform in [TargetPlatform.macOS, TargetPlatform.linux]) {
    test('Разрешение ОС проверяется на $platform', () async {
      debugDefaultTargetPlatformOverride = platform;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      var allowed = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            SystemNotifications.activationChannel,
            (call) async => call.method == 'permission' ? allowed : null,
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            ),
      );
      final service = SystemNotifications(
        savedTargets: NotificationTargets(storage: HistoryKeys()),
      );
      addTearDown(service.dispose);
      expect(await service.requestPermission(), isFalse);
      allowed = true;
      expect(await service.requestPermission(), isTrue);
    });
  }
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
      final saved = NotificationTargets(storage: HistoryKeys());
      final service = SystemNotifications(savedTargets: saved);
      final nativeCalls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemNotifications.activationChannel, (
            call,
          ) async {
            nativeCalls.add(call);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            ),
      );
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
      final sent = nativeCalls.where((call) => call.method == 'show').toList();
      expect(sent, hasLength(2));
      expect(
        jsonEncode(sent.last.arguments),
        isNot(contains('secret.example')),
      );
      Future<void> click() async {
        await service.activate((sent.last.arguments as Map)['token'] as String);
        await Future<void>.delayed(Duration.zero);
      }

      await click();
      expect(jsonDecode(taps.single).last, 2);
      await service.show(
        id: 99,
        title: 'Space',
        body: 'Новое сообщение',
        target: ['https://secret.example', 'me', 'general', 3],
      );
      await service.clear();
      final clear = nativeCalls.lastWhere((call) => call.method == 'clear');
      expect((clear.arguments as Map)['ids'], [99]);
      await click();
      expect(taps, hasLength(1));
    });
  }
}
