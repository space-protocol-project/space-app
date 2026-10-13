import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/app_updates.dart';
import 'package:space_client/ui/app_updates_view.dart';

void main() {
  late Directory directory;
  late File file;
  final bytes = utf8.encode('проверенный установщик');
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('space-install-test-');
    file = await File('${directory.path}/setup.exe').writeAsBytes(bytes);
  });
  tearDown(() => directory.delete(recursive: true));

  AppUpdates model({
    required List<String> events,
    Directory? installed,
    Future<void> Function(File, List<String>)? launch,
  }) {
    final package = AppPackage(
      'Space-Setup-windows-x64.exe',
      Uri.parse('https://github.com'),
      bytes.length,
      'sha256:${sha256.convert(bytes)}',
    );
    return AppUpdates(
        platform: 'windows-x64',
        downloadDirectory: () async => directory,
        installationDirectory: () async => installed,
        closeApplication: () => events.add('close'),
        launchInstaller:
            launch ??
            (file, arguments) async {
              events.add('launch');
              expect(arguments, contains('/RELAUNCH'));
              expect(arguments, contains('/DIR=${installed!.path}'));
              expect(arguments, contains('/LOG=${directory.path}/install.log'));
              expect(arguments, contains('/NORESTART'));
            },
      )
      ..downloadedPackage = file
      ..status = AppUpdateStatus.available
      ..release = AppRelease(
        'v0.3.0',
        Uri.parse('https://github.com'),
        '',
        AppVersion.parse('0.3.0')!,
        {package.name: package},
      );
  }

  test('Подготовка и остановка предшествуют запуску; приложение закрывается после запуска', () async {
    final events = <String>[];
    final updates = model(events: events, installed: directory);
    addTearDown(updates.dispose);
    await updates.install(
      prepare: () async {
        events.add('stop');
      },
    );
    expect(events, ['stop', 'launch', 'close']);
    expect(updates.installFailed, false);
  });

  test('Копия из сборки и повреждённый пакет не запускают подготовку или установщик', () async {
    for (final installed in [null, directory]) {
      final events = <String>[];
      final updates = model(events: events, installed: installed);
      if (installed != null) await file.writeAsString('повреждение');
      await updates.install(
        prepare: () async {
          events.add('stop');
        },
      );
      expect(events, isEmpty);
      expect(updates.installFailed, true);
      updates.dispose();
    }
  });

  test(
    'Отказ остановки и подмена во время подготовки блокируют запуск и закрытие',
    () async {
      for (final corrupt in [false, true]) {
        final events = <String>[];
        final updates = model(events: events, installed: directory);
        await updates.install(
          prepare: () async {
            if (corrupt) {
              await file.writeAsString('подмена');
            } else {
              throw StateError('Сервер не остановился');
            }
          },
        );
        expect(events, isEmpty);
        expect(updates.installFailed, true);
        updates.dispose();
      }
    },
  );

  test(
    'Ошибка запуска оставляет приложение открытым; повтор допустим',
    () async {
      final events = <String>[];
      var calls = 0;
      final updates = model(
        events: events,
        installed: directory,
        launch: (_, _) async {
          if (++calls == 1) {
            throw const ProcessException('setup.exe', [], 'Ошибка запуска');
          }
          events.add('launch');
        },
      );
      addTearDown(updates.dispose);
      await updates.install(prepare: () async {});
      expect(events, isEmpty);
      expect(updates.installFailed, true);
      await updates.install(prepare: () async {});
      expect(events, ['launch', 'close']);
      expect(updates.installFailed, false);
    },
  );

  testWidgets(
    'Кнопка установки доступна установленной копии; копия сборки открывает выпуск',
    (tester) async {
      for (final installed in [null, directory]) {
        final events = <String>[];
        final updates = model(events: events, installed: installed);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppUpdatesView(
                updates: updates,
                prepareInstall: () async {
                  events.add('stop');
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('install-app-update')),
          installed == null ? findsNothing : findsOneWidget,
        );
        expect(find.text('Открыть выпуск'), findsOneWidget);
        if (installed != null) {
          expect(
            tester
                .widget<FilledButton>(
                  find.byKey(const ValueKey('install-app-update')),
                )
                .onPressed,
            isNotNull,
          );
        }
        await tester.pumpWidget(const SizedBox());
        updates.dispose();
      }
    },
  );
}
