import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/secure_vault.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const storage = PlatformKeyStorage();
  late List<MethodCall> calls;
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    calls = [];
  });
  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'macOS сохраняет имя записи и использует системный login Keychain',
    () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return call.method == 'read' ? 'existing-key' : null;
      });
      expect(await storage.read(key: 'identity'), 'existing-key');
      await storage.write(key: 'identity', value: 'next-key');
      await storage.delete(key: 'identity');
      expect(calls.take(3).map((call) => call.method), [
        'read',
        'write',
        'delete',
      ]);
      for (final call in calls) {
        final args = call.arguments as Map;
        final options = args['options'] as Map;
        expect(args['key'], 'identity');
        expect(options['usesDataProtectionKeychain'], 'false');
        expect(options['synchronizable'], 'false');
        expect(options['accountName'], 'flutter_secure_storage_service');
      }
    },
  );

  test('Отказ Keychain не превращается в отсутствие ключа или сброс', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      throw PlatformException(code: 'locked-keychain');
    });
    await expectLater(
      storage.read(key: 'identity'),
      throwsA(isA<PlatformException>()),
    );
    await expectLater(
      storage.write(key: 'identity', value: 'next'),
      throwsA(isA<PlatformException>()),
    );
    expect(calls.map((call) => call.method), ['read', 'write']);
  });

  test('Отсутствие записи не вызывает миграцию или создание ключа', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    expect(await storage.read(key: 'missing'), isNull);
    expect(calls, isNotEmpty);
    expect(calls.every((call) => call.method == 'read'), isTrue);
  });
}
