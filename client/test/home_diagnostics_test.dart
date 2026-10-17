import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_diagnostics.dart';
import 'package:space_client/src/home_installation.dart';
import 'package:space_client/src/home_runtime.dart';
import 'package:space_client/ui/home_diagnostics_panel.dart';

import 'support/temp_directory.dart';

Map<String, dynamic> diagnosticFixture() => {
  'format': 1,
  'external': 'unverified',
  'fingerprint': 'a' * 64,
  'server_id': 'srv_${'1' * 32}',
  'endpoints': [
    {'host': 'space.example.org', 'port': 9443, 'type': 'https', 'priority': 0},
  ],
  'checks': [
    {'code': 'local_ok', 'status': 'ok', 'target': '127.0.0.1:18443'},
    {'code': 'wan_shared', 'status': 'warning', 'target': '100.64.1.2'},
    {'code': 'external_unverified', 'status': 'unknown'},
  ],
};

Map<String, dynamic> observedFixture() => {
  ...diagnosticFixture(),
  'external': 'observed',
  'external_checked_at_unix_ms': DateTime.now().millisecondsSinceEpoch - 1000,
  'checks': [
    {
      'code': 'external_observed',
      'status': 'ok',
      'target': 'https://space.example.org:9443',
    },
  ],
};

class DiagnosticHome extends HomeController {
  String? enteredWAN;
  @override
  Future<void> diagnose({String wanIP = ''}) async {
    enteredWAN = wanIP;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Внешнее наблюдение требует свежего времени и известного адреса', () {
    final fixture = observedFixture();
    expect(HomeDiagnosis.fromJson(fixture).externalCheckedAt, isNotNull);
    for (final invalid in [
      {...fixture, 'external_checked_at_unix_ms': 0},
      {
        ...fixture,
        'external_checked_at_unix_ms':
            DateTime.now().millisecondsSinceEpoch + 10000,
      },
      {...fixture, 'external_checked_at_unix_ms': null},
      {...fixture, 'checks': <dynamic>[]},
      {...fixture, 'fingerprint': ''},
      {
        ...fixture,
        'checks': [
          {
            'code': 'external_observed',
            'status': 'ok',
            'target': 'https://other.example',
          },
        ],
      },
      {...fixture, 'external': 'unverified'},
    ]) {
      expect(() => HomeDiagnosis.fromJson(invalid), throwsFormatException);
    }
  });

  test(
    'Отчёт не приписывает внешнюю доступность и команда не содержит секретов',
    () {
      final report = HomeDiagnosis.fromJson(diagnosticFixture());
      expect(
        report.outsideCommand,
        contains("-endpoint 'https://space.example.org:9443'"),
      );
      expect(report.outsideCommand, contains('-fingerprint ${'a' * 64}'));
      expect(report.outsideCommand, isNot(contains('setup')));
      expect(() => report.checks.clear(), throwsUnsupportedError);
      for (final invalid in [
        {...diagnosticFixture(), 'external': 'verified'},
        {...diagnosticFixture(), 'server_id': 'srv_;command'},
        {...diagnosticFixture(), 'fingerprint': 'other'},
        {
          ...diagnosticFixture(),
          'checks': [
            {'code': 'x', 'status': 'ok', 'target': 'a\nb'},
          ],
        },
      ]) {
        expect(() => HomeDiagnosis.fromJson(invalid), throwsFormatException);
      }
    },
  );

  test('Диагностика проходит через событие, не скачивает runtime и не сохраняет WAN IP', () async {
    final root = await Directory.systemTemp.createTemp(
      'space-doctor-controller-',
    );
    addTearDown(
      () => deleteTestDirectory(root, prefix: 'space-doctor-controller-'),
    );
    final release = await bundledHomeRelease();
    final installation = HomeInstallation(root);
    final runtime = await installation.runtime(release).create(recursive: true);
    await File('${runtime.path}/installed.json')
        .writeAsString(jsonEncode({'sha256': release.sha256}));
    await File(
      '${runtime.path}/${Platform.isWindows ? 'space-server.exe' : 'space-server'}',
    ).writeAsString('fixture');
    await installation.selectInitial(release);
    final config = File('${root.path}/config.json');
    await config.writeAsString('{"ip":"space.example.org","port":9443}');
    final original = await config.readAsString();
    var calls = 0;
    final pending = Completer<Map<String, dynamic>>();
    final started = Completer<void>();
    final home = HomeController(
      directory: () async => root,
      release: () async => release,
      download: (_, _, _) async => fail('Загрузка не нужна для диагностики'),
      diagnoseTool: (actualRuntime, arguments) async {
        calls++;
        if (calls == 2) {
          started.complete();
          return pending.future;
        }
        if (calls == 3) throw const HomeDiagnosisUnsupported();
        expect(actualRuntime.path, runtime.path);
        expect(arguments, [
          'doctor',
          '-home-data',
          '${root.path}/data',
          '-json',
          '-wan-ip',
          '100.64.1.2',
        ]);
        return diagnosticFixture();
      },
    );
    addTearDown(home.dispose);
    await home.diagnose(wanIP: '100.64.1.2');
    expect(calls, 1);
    expect(home.diagnosis!.checks.first.code, 'local_ok');
    expect(home.diagnosisError, isNull);
    expect(home.diagnosing, false);
    expect(await config.readAsString(), original);
    await home.stop();
    expect(home.diagnosis, isNull);
    final checking = home.diagnose();
    await started.future;
    expect(home.diagnosing, true);
    await home.stop();
    pending.complete(diagnosticFixture());
    await checking;
    expect(
      home.diagnosis,
      isNull,
      reason: 'Остановка должна отклонять результат начатой ранее проверки',
    );
    expect(home.diagnosing, false);
    await home.diagnose();
    expect(home.diagnosisError, HomeDiagnosisError.unsupported);
    expect(home.diagnosis, isNull);
  });

  for (final width in [390.0, 1100.0]) {
    testWidgets(
      'Диагностика читается на $width и сохраняет WAN при смене языка',
      (tester) async {
        tester.view.physicalSize = Size(width, 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final home = DiagnosticHome();
        addTearDown(home.dispose);
        final view = HomeState(
          diagnosis: HomeDiagnosis.fromJson(diagnosticFixture()),
        );
        Future<void> show(Locale locale) => tester.pumpWidget(
          MaterialApp(
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HomeDiagnosticsPanel(home: home, view: view),
                ),
              ),
            ),
          ),
        );
        await show(const Locale('ru'));
        await tester.enterText(find.byType(TextField), '100.64.1.2');
        await tester.tap(find.text('Проверить'));
        expect(home.enteredWAN, '100.64.1.2');
        for (final locale in [
          const Locale('en'),
          const Locale('zh'),
          const Locale('ru'),
        ]) {
          await show(locale);
          await tester.pumpAndSettle();
          expect(
            tester.widget<TextField>(find.byType(TextField)).controller!.text,
            '100.64.1.2',
          );
          expect(tester.takeException(), isNull);
        }
        expect(find.textContaining('Извне не проверено'), findsOneWidget);
        expect(find.textContaining('100.64.0.0/10'), findsOneWidget);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: SingleChildScrollView(
                child: HomeDiagnosticsPanel(
                  home: home,
                  view: HomeState(
                    diagnosis: HomeDiagnosis.fromJson(observedFixture()),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Последнее внешнее подключение:'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
