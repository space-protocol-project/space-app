import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing_selection.dart';
import 'package:space_client/ui/pairing_selection.dart';

class SelectionVault implements IdentityVault {
  bool saved = false;
  @override
  Future<DeviceRecord?> load(String origin) async => saved
      ? DeviceRecord(
          origin: origin,
          serverId: 's',
          serverKey: '',
          rootSeed: [],
          deviceSeed: [],
        )
      : null;
  @override
  Future<void> save(DeviceRecord record) async {
    saved = true;
  }
}

class SelectionController extends ChatController {
  SelectionController(super.vault);
  int inspections = 0;
  Completer<void>? gate;
  @override
  Future<void> inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
    DeviceRecord? savedRecord,
  }) async {
    inspections++;
    await gate?.future;
    preview = Discovery(Uri.parse(address), 'srv_test', List.filled(32, 1));
  }
}

void main() {
  test(
    'Подготовка затрагивает только выбранное пространство и фиксирует режим',
    () async {
      final a = SelectionController(SelectionVault()),
          b = SelectionController(SelectionVault());
      final cubit = PairingSelectionCubit(() => {'http://a': a, 'http://b': b});
      cubit.select('http://a', true);
      cubit.mode(true);
      await cubit.prepare();
      expect(cubit.state.prepared, isTrue);
      expect(a.inspections, 1);
      expect(b.inspections, 0);
      cubit.select('http://b', true);
      cubit.mode(false);
      expect(cubit.state.origins, {'http://a'});
      expect(cubit.state.fullManagement, isTrue);
      await cubit.close();
      await a.close();
      await b.close();
    },
  );
  test('Поздний discovery после отмены не открывает запросы', () async {
    final a = SelectionController(SelectionVault())..gate = Completer<void>();
    final cubit = PairingSelectionCubit(() => {'http://a': a});
    cubit.select('http://a', true);
    final operation = cubit.prepare();
    while (a.inspections == 0) {
      await Future<void>.delayed(Duration.zero);
    }
    cubit.reset();
    a.gate!.complete();
    await operation;
    expect(cubit.state.prepared, isFalse);
    expect(cubit.state.origins, isEmpty);
    await cubit.close();
    await a.close();
  });
  for (final locale in ['ru', 'en', 'zh']) {
    testWidgets('Выбор пространств: $locale, узкий экран и крупный шрифт', (
      tester,
    ) async {
      final controller = SelectionController(SelectionVault());
      addTearDown(controller.close);
      tester.view.physicalSize = const Size(390, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(locale),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            ...AppLocalizations.localizationsDelegates,
            AdminLocalizations.delegate,
          ],
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: PairingSelectionPanel(
                  controllers: () => {'http://a': controller},
                  onConnected: (_, _) async {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(controller.inspections, 0);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
  test(
    'Выбор ограничен известными пространствами и не создаёт grant',
    () async {
      final vault = SelectionVault(), controllers = <String, ChatController>{};
      for (var index = 0; index < 14; index++) {
        controllers['http://space$index'] = ChatController(vault);
      }
      final cubit = PairingSelectionCubit(() => controllers);
      cubit.select('http://unknown', true);
      expect(cubit.state.origins, isEmpty);
      for (final origin in controllers.keys) {
        cubit.select(origin, true);
      }
      expect(cubit.state.origins.length, 12);
      expect(cubit.state.fullManagement, isFalse);
      cubit.mode(true);
      expect(cubit.state.fullManagement, isTrue);
      cubit.reset();
      expect(cubit.state.origins, isEmpty);
      expect(cubit.state.fullManagement, isFalse);
      expect(vault.saved, isFalse);
      await cubit.close();
      for (final controller in controllers.values) {
        await controller.close();
      }
    },
  );
  test(
    'Сохранённая личность блокирует всю подготовку до сетевых запросов',
    () async {
      final vault = SelectionVault()..saved = true;
      final controller = ChatController(vault);
      final cubit = PairingSelectionCubit(() => {'http://space': controller});
      cubit.select('http://space', true);
      await cubit.prepare();
      expect(cubit.state.prepared, isFalse);
      expect(cubit.state.busy, isFalse);
      expect(cubit.state.error, isNotEmpty);
      expect(controller.preview, isNull);
      await cubit.close();
      await controller.close();
    },
  );
}
