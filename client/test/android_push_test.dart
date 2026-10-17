import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/android_push.dart';
import 'package:space_client/src/system_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Android: выключение и удаление пространства передаются службе',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final calls = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemNotifications.activationChannel, (
            call,
          ) async {
            calls.add(call);
            return null;
          });
      addTearDown(() {
        debugDefaultTargetPlatformOverride = null;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            );
      });
      final push = AndroidPush();
      await push.sync(enabled: true, origins: ['https://saved.example']);
      await push.sync(enabled: false, origins: []);
      expect(calls.map((call) => call.method), ['pushSync', 'pushSync']);
      expect(calls.last.arguments, {'enabled': false, 'origins': []});
    },
  );
  test(
    'Android: холодный запуск получает одноразовую локальную цель',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      var consumed = false;
      const target = '["https://saved.example","principal","general",42]';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemNotifications.activationChannel, (
            call,
          ) async {
            if (call.method == 'initial') {
              return 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
            }
            if (call.method == 'take' && !consumed) {
              consumed = true;
              return target;
            }
            return null;
          });
      final service = SystemNotifications();
      addTearDown(() async {
        await service.dispose();
        debugDefaultTargetPlatformOverride = null;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              SystemNotifications.activationChannel,
              null,
            );
      });
      final delivered = service.targets.stream.first;
      await service.listenForActivation(enabled: true);
      expect(await delivered, target);
      expect(consumed, isTrue);
    },
  );
}
