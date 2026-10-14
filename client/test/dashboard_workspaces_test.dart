import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart'
    show MemoryHistory, CatalogSession, ChannelVault, MemoryPositions, chat;

class DashboardSession extends CatalogSession {
  DashboardSession(this.name) {
    availableChannels = [
      chat('general')..title = 'Общий · $name',
      chat('team')..title = 'Команда · $name',
    ];
  }
  final String name;
  int closes = 0;
  Completer<Content>? pendingSend;
  @override
  Future<Content> send(String text, String key) =>
      pendingSend?.future ?? super.send(text, key);
  @override
  String get spaceTitle => name;
  @override
  Future<void> close() async {
    closes++;
    await super.close();
  }
}

void main() {
  for (final width in [390.0, 1680.0]) {
    testWidgets('Главная, отдельные серверы и черновики: $width', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = Size(width, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const first = 'http://127.0.0.1:8080', second = 'http://127.0.0.1:8081';
      final vault = ChannelVault();
      final sessions = {
        first: DashboardSession('Основа'),
        second: DashboardSession('Мастерская'),
      };
      late ServerWorkspaces workspaces;
      await tester.runAsync(() async {
        workspaces = ServerWorkspaces(
          vault: vault,
          create: (origin) => ChatController(
            vault,
            positions: MemoryPositions(),
            historyStore: MemoryHistory(),
            openSession: (_, _) async => sessions[origin]!,
          ),
          resume: (origin, controller) async {
            controller.preview = Discovery(
              localOrigin(origin),
              'srv_${sessions[origin]!.name}',
              List.filled(32, 1),
            );
            await controller.connect();
          },
        );
        await workspaces.synchronize([first, second]);
        await workspaces.refresh();
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      final preferences = AppPreferences()..origins.addAll([first, second]);
      final presence = ServerPresence(probe: (_) async => true);
      await presence.watch([first, second]);
      final boundary = GlobalKey();
      if (Platform.environment['SPACE_DASHBOARD_PREVIEW'] == '1') {
        for (final font in {
          'Nunito': 'assets/fonts/Nunito-Variable.ttf',
          'Nunito Sans': 'assets/fonts/NunitoSans-Variable.ttf',
          'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
        }.entries) {
          final loader = FontLoader(font.key)
            ..addFont(rootBundle.load(font.value));
          await loader.load();
        }
      }
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: preferences.theme,
            locale: const Locale('ru'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AdminLocalizations.delegate,
              ...AppLocalizations.localizationsDelegates,
            ],
            home: SpaceShell(
              preferences: preferences,
              workspaces: workspaces,
              presence: presence,
            ),
          ),
        ),
      );
      await tester.runAsync(() async {
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text('Все ваши пространства — рядом.'), findsOneWidget);
      expect(workspaces[first]!.connected, true);
      expect(workspaces[second]!.connected, true);
      if (Platform.environment['SPACE_DASHBOARD_PREVIEW'] == '1' &&
          width == 1680) {
        await tester.runAsync(() async {
          await precacheImage(
            const AssetImage('assets/branding/space-app-icon.png'),
            boundary.currentContext!,
          );
        });
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('../docs/assets/guides/space-dashboard.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      if (width == 1680) {
        for (final key in [
          'dashboard-tab',
          'server-tab-$first',
          'server-tab-$second',
          'home-server-details-tab',
        ]) {
          expect(tester.getSize(find.byKey(ValueKey(key))), const Size(48, 48));
        }
        await tester.tap(find.byKey(const ValueKey('server-tab-$first')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        for (final name in ['Общий · Основа', 'Команда · Основа']) {
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('server-chats')),
              matching: find.text(name),
            ),
            findsOneWidget,
          );
        }
        for (final name in ['Обсуждения', 'Лента', 'Встречи']) {
          expect(find.widgetWithText(ListTile, name), findsNothing);
        }
        await tester.enterText(
          find.byKey(const ValueKey('chat-draft')),
          'Черновик сервера A',
        );
        tester.testTextInput.hide();
        await tester.tap(find.byKey(const ValueKey('server-tab-$second')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .controller!
              .text,
          isEmpty,
        );
        await tester.enterText(
          find.byKey(const ValueKey('chat-draft')),
          'Черновик сервера B',
        );
        tester.testTextInput.hide();
        await tester.tap(find.byKey(const ValueKey('dashboard-tab')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(find.text('Все ваши пространства — рядом.'), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('server-tab-$first')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .controller!
              .text,
          'Черновик сервера A',
        );
        expect(sessions[first]!.closes, 0);
        expect(sessions[second]!.closes, 0);
        final acknowledgement = Completer<Content>();
        sessions[first]!.pendingSend = acknowledgement;
        await tester.enterText(
          find.byKey(const ValueKey('chat-draft')),
          'Одинаковый текст',
        );
        await tester.tap(find.byTooltip('Отправить'));
        await tester.pump();
        await tester.tap(find.byKey(const ValueKey('server-tab-$second')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('chat-draft')),
          'Одинаковый текст',
        );
        acknowledgement.complete(
          Content(id: 'sent', channelId: 'general', text: 'Одинаковый текст'),
        );
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        });
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .controller!
              .text,
          'Одинаковый текст',
        );
        tester.testTextInput.hide();
        await tester.tap(find.byKey(const ValueKey('server-tab-$first')));
        await tester.runAsync(() async {
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('chat-draft')))
              .controller!
              .text,
          isEmpty,
        );
      }
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      workspaces.dispose();
      presence.dispose();
      preferences.dispose();
    });
  }
}
