import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';

import 'shell_test.dart' show TestVault;

class _SemanticsBinding extends AutomatedTestWidgetsFlutterBinding {
  final nodes = <int, List<int>>{};
  final orphanUpdates = <int>[];

  @override
  ui.SemanticsUpdateBuilder createSemanticsUpdateBuilder() =>
      _UpdateBuilder(this);

  void apply(Map<int, List<int>> updates) {
    // AXTree получает приращения: каждый обновлённый узел должен оставаться
    // достижимым от корня после применения очередного пакета.
    nodes.addAll(updates);
    final reachable = <int>{};
    void visit(int id) {
      if (!reachable.add(id)) return;
      for (final child in nodes[id] ?? <int>[]) {
        visit(child);
      }
    }

    visit(0);
    orphanUpdates.addAll(updates.keys.where((id) => !reachable.contains(id)));
    nodes.removeWhere((id, _) => !reachable.contains(id));
  }
}

class _UpdateBuilder extends Fake implements ui.SemanticsUpdateBuilder {
  _UpdateBuilder(this.binding);
  final _SemanticsBinding binding;
  final updates = <int, List<int>>{};

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #updateNode) {
      final args = invocation.namedArguments;
      updates[args[#id] as int] = List<int>.from(
        args[#childrenInTraversalOrder] as Iterable<int>,
      );
      return null;
    }
    if (invocation.memberName == #updateCustomAction) return null;
    return super.noSuchMethod(invocation);
  }

  @override
  ui.SemanticsUpdate build() {
    binding.apply(updates);
    return ui.SemanticsUpdateBuilder().build();
  }
}

class _NamedController extends ChatController {
  _NamedController() : super(TestVault());
  @override
  String get spaceTitle => 'Тестовое пространство';
}

class _Presence extends ServerPresence {
  _Presence() : super(probe: (_) async => null);
  bool? available;
  @override
  bool? online(String origin) => available;
}

void main() {
  final binding = _SemanticsBinding();
  testWidgets('Смена подсказок не отправляет узлы вне дерева доступности', (
    tester,
  ) async {
    const origin = 'http://127.0.0.1:8080';
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    final controller = ChatController(TestVault());
    addTearDown(controller.dispose);
    final preferences = AppPreferences()..origins.add(origin);
    final presence = _Presence();
    final workspaces = ServerWorkspaces(
      vault: TestVault(),
      create: (_) => _NamedController(),
      resume: (_, _) async {},
    );
    addTearDown(preferences.dispose);
    addTearDown(workspaces.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        home: SpaceShell(
          preferences: preferences,
          controller: controller,
          presence: presence,
          workspaces: workspaces,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    final server = find.byKey(const ValueKey('server-tab-$origin'));
    final add = find.widgetWithIcon(IconButton, Icons.add).first;
    final strings = AppLocalizations.of(tester.element(server))!;
    for (final available in [null, true, false]) {
      presence.available = available;
      presence.publishState();
      await tester.pumpAndSettle();
      var expected = 'Тестовое пространство · $origin';
      if (available != null) {
        expected +=
            '\n${available ? strings.serverNowOnline('127.0.0.1') : strings.serverNowOffline('127.0.0.1')}';
      }
      expect(tester.widget<IconButton>(server).tooltip, expected);
      expect(tester.getSemantics(server).getSemanticsData().tooltip, expected);
      for (final button in [server, add]) {
        await mouse.moveTo(tester.getCenter(button));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350));
      }
    }
    await mouse.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    semantics.dispose();
    expect(binding.orphanUpdates, isEmpty);
    await tester.pumpWidget(const SizedBox());
    presence.dispose();
  });
}
