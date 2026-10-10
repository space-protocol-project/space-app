import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

void main() {
  testWidgets(
    'Восстановление: узкий экран, крупный текст и ограничения полномочий',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final code = TextEditingController(), entered = TextEditingController();
      addTearDown(code.dispose);
      addTearDown(entered.dispose);
      var scans = 0;
      void action() {}
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: RecoveryToolsView(
                  connected: false,
                  hasServer: true,
                  hasDeviceManagement: false,
                  hasRootAuthority: false,
                  canRotate: false,
                  pending: false,
                  message: '',
                  pairingCode: code,
                  pairingEntered: entered,
                  pairingCheck: '',
                  pairingPrepared: false,
                  devices: const [],
                  currentGrantId: '',
                  onRotate: action,
                  onRenewRotation: action,
                  onFinishRotation: action,
                  onPreparePairing: action,
                  onApprovePairing: action,
                  onPairingCodeChanged: (_) {},
                  onExport: action,
                  onRestore: action,
                  onScan: () => scans++,
                  onRefreshDevices: action,
                  onRevoke: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Сменить корневой ключ'), findsNothing);
      final export = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Сохранить карточку'),
      );
      expect(export.onPressed, isNull);
      await tester.ensureVisible(find.text('Сканировать камерой'));
      await tester.tap(find.text('Сканировать камерой'));
      await tester.pumpAndSettle();
      expect(scans, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Сопряжение: подключение доступно только после проверки подписи',
    (tester) async {
      var accepted = 0;
      Widget view(bool verified) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PairingStartView(
              busy: false,
              connectionBusy: false,
              connected: false,
              code: 'pc_test',
              signatureVerified: verified,
              verification: 'ABCD-EFGH',
              error: '',
              onStart: () {},
              onAccept: () => accepted++,
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpWidget(view(false));
      await tester.pumpAndSettle();
      expect(find.text('Код совпадает — подключиться'), findsNothing);
      expect(find.text('ABCD-EFGH'), findsOneWidget);
      await tester.pumpWidget(view(true));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Код совпадает — подключиться'));
      expect(accepted, 1);
    },
  );

  testWidgets(
    'Пароль карточки: длина, совпадение и повторное открытие без секрета',
    (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async =>
                    result = await askRecoveryPassword(context, creating: true),
                child: const Text('Карточка'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Карточка'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'короткий');
      await tester.tap(find.text('Зашифровать'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(
        find.text('Пароль слишком короткий или значения не совпадают.'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byType(TextField).first,
        'случайные слова пароль',
      );
      await tester.enterText(
        find.byType(TextField).last,
        'случайные слова пароль',
      );
      await tester.tap(find.text('Зашифровать'));
      await tester.pumpAndSettle();
      expect(result, 'случайные слова пароль');
      await tester.tap(find.text('Карточка'));
      await tester.pumpAndSettle();
      expect(find.text('случайные слова пароль'), findsNothing);
      await tester.tap(find.text('Отмена'));
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Камера: ошибка, смена камеры, повтор и отмена', (tester) async {
    String? selected;
    var retries = 0, canceled = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RecoveryCameraView(
            cameras: const ['first', 'second'],
            selected: 'first',
            starting: false,
            error: 'Камера остановлена',
            preview: null,
            onSelect: (v) => selected = v,
            onRestart: () => retries++,
            onCancel: () => canceled++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Камера 2 — second').last);
    await tester.pumpAndSettle();
    expect(selected, 'second');
    await tester.tap(find.text('Включить снова'));
    await tester.tap(find.text('Отмена'));
    expect(retries, 1);
    expect(canceled, 1);
  });
}
