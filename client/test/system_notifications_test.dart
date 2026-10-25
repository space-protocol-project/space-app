import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/system_notifications.dart';
import 'package:space_client/src/notification_targets.dart';

import 'chat_history_test.dart' show HistoryKeys;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Отзыв доступа во время сохранения отменяет карточку и её цель',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final saved = _DelayedTargets();
      final service = SystemNotifications(savedTargets: saved);
      addTearDown(service.dispose);
      final shown = <Object?>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemNotifications.activationChannel, (
            call,
          ) async {
            if (call.method == 'show') shown.add(call.arguments);
            return null;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            ),
      );
      var allowed = true;
      final pending = service.show(
        id: 1,
        title: 'Space',
        body: 'Новое сообщение',
        target: ['personal', 'https://saved.example', 'me', 'forum', 1, 'pn_1'],
        permitted: () => allowed,
      );
      await saved.entered.future;
      allowed = false;
      saved.resume.complete();
      await pending;
      expect(shown, isEmpty);
      expect(await saved.take(saved.token!), isNull);
    },
  );
  for (final platform in [
    TargetPlatform.macOS,
    TargetPlatform.linux,
    TargetPlatform.android,
  ]) {
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

class _DelayedTargets extends NotificationTargets {
  _DelayedTargets() : super(storage: HistoryKeys());
  final entered = Completer<void>(), resume = Completer<void>();
  String? token;
  @override
  Future<String> save(int id, String payload) async {
    token = await super.save(id, payload);
    entered.complete();
    await resume.future;
    return token!;
  }
}
