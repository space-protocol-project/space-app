import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/app_updates_view.dart';

Map<String, dynamic> release(String tag, {bool draft = false}) => {
  'tag_name': tag,
  'draft': draft,
  'html_url': 'https://github.com/$appRepository/releases/tag/$tag',
  'assets': [
    for (final name in appReleaseAssets) {'name': name},
  ],
  'body': '- Исправления',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Версии сравниваются численно, preview предшествует обычному выпуску',
    () {
      expect(
        AppVersion.parse('v0.2.10')!.compareTo(AppVersion.parse('0.2.9+2')!),
        greaterThan(0),
      );
      expect(
        AppVersion.parse('0.3.0-rc.2')!
            .compareTo(AppVersion.parse('0.3.0-rc.10')!),
        lessThan(0),
      );
      expect(
        AppVersion.parse('0.3.0')!.compareTo(AppVersion.parse('0.3.0-rc.10')!),
        greaterThan(0),
      );
      for (final value in [
        'main',
        '01.2.3',
        'v0.2',
        '0.2.0-..',
        '0.2.0-rc.01',
      ]) {
        expect(AppVersion.parse(value), isNull);
      }
    },
  );
  test(
    'Версия берётся из включённого в сборку pubspec, включая build number',
    () async {
      final expected = RegExp(
        r'^version: (.+)$',
        multiLine: true,
      ).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1);
      expect(await installedAppVersion(), expected);
    },
  );
  test(
    'Проверка выбирает новый полный релиз и не отправляет авторизацию сервера',
    () async {
      final updates = AppUpdates(
        readVersion: () async => '0.2.9+2',
        client: MockClient((request) async {
          expect(request.url.host, 'api.github.com');
          expect(request.url.path, '/repos/$appRepository/releases');
          expect(request.headers.containsKey('authorization'), false);
          return http.Response(
            jsonEncode([
              release('v0.2.10'),
              release('v0.2.9'),
              release('v9.0.0', draft: true),
            ]),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          );
        }),
      );
      addTearDown(updates.dispose);
      await updates.check();
      expect(updates.status, AppUpdateStatus.available);
      expect(updates.release!.tag, 'v0.2.10');
    },
  );
  test('Неполный релиз и ссылка на посторонний адрес не принимаются', () {
    expect(AppRelease.fromJson(release('v0.3.0')..['assets'] = []), isNull);
    expect(
      AppRelease.fromJson(
        release('v0.3.0')..['html_url'] = 'https://example.org/download',
      ),
      isNull,
    );
  });
  test(
    'Ошибка GitHub допускает повтор; параллельная проверка не запускается',
    () async {
      var calls = 0;
      final response = Completer<http.Response>();
      final updates = AppUpdates(
        readVersion: () async => '0.2.0+2',
        client: MockClient((_) {
          calls++;
          return calls == 1
              ? response.future
              : Future.value(
                  http.Response.bytes(
                    utf8.encode(jsonEncode([release('v0.2.0')])),
                    200,
                  ),
                );
        }),
      );
      addTearDown(updates.dispose);
      final first = updates.check();
      await Future<void>.delayed(Duration.zero);
      await updates.check();
      expect(calls, 1);
      response.complete(http.Response('rate limit', 403));
      await first;
      expect(updates.status, AppUpdateStatus.failed);
      await updates.check();
      expect(updates.status, AppUpdateStatus.current);
    },
  );
  testWidgets(
    'Настройки показывают версию, результат проверки и изменения на узком экране',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final updates = AppUpdates(
        readVersion: () async => '0.2.0+2',
        client: MockClient(
          (_) async => http.Response.bytes(
            utf8.encode(jsonEncode([release('v0.3.0')])),
            200,
          ),
        ),
      );
      addTearDown(updates.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppPreferences().theme,
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: AppUpdatesView(updates: updates),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Версия 0.2.0+2'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('check-app-updates')));
      await tester.pumpAndSettle();
      expect(find.text('Доступна версия v0.3.0'), findsOneWidget);
      expect(find.text('Открыть выпуск'), findsOneWidget);
      await tester.tap(find.text('Изменения'));
      await tester.pumpAndSettle();
      expect(find.text('- Исправления'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
