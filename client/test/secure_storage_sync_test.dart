import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/secure_vault.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('space/secure-storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test(
    'Android подтверждает запись без автоматического сброса ключей',
    () async {
      MethodCall? received;
      messenger.setMockMethodCallHandler(channel, (call) async {
        received = call;
        return null;
      });
      await syncSecureStorage(android: false);
      expect(received, isNull);
      await syncSecureStorage(android: true);
      expect(received!.method, 'flush');
      expect((received!.arguments as Map)['resetOnError'], 'false');
    },
  );

  test('Ошибка синхронизации не считается успешным сохранением', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'secure_storage_sync');
    });
    await expectLater(
      syncSecureStorage(android: true),
      throwsA(isA<PlatformException>()),
    );
  });
}
