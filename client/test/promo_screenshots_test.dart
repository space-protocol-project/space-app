import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/components.dart';
import 'package:space_client/ui/home_panel.dart';
import 'package:space_client/ui/panels.dart';

import 'admin_channels_panel_test.dart' show ChannelServer;

void main() {
  testWidgets('Экспорт актуальных общих Flutter-форм для промогалереи', (
    tester,
  ) async {
    final output = Platform.environment['SPACE_PROMO_SCREENSHOTS'];
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final font in {
      'Nunito': 'assets/fonts/Nunito-Variable.ttf',
      'Nunito Sans': 'assets/fonts/NunitoSans-Variable.ttf',
      'JetBrains Mono': 'assets/fonts/JetBrainsMono-Variable.ttf',
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
    }.entries) {
      final loader = FontLoader(font.key)..addFont(rootBundle.load(font.value));
      await loader.load();
    }
    final preferences = AppPreferences();
    addTearDown(preferences.dispose);
    Future<void> capture(
      String name,
      String title,
      Widget view, {
      String? focus,
    }) async {
      final boundary = GlobalKey();
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
            home: Scaffold(
              body: PageBody(
                title: title,
                description: 'Space · общие формы приложения',
                children: [view],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      if (focus != null) {
        await tester.tap(find.text(focus));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      await tester.runAsync(() async {
        final image =
            await (boundary.currentContext!.findRenderObject()
                    as RenderRepaintBoundary)
                .toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        await Directory(output!).create(recursive: true);
        await File('$output/$name.png')
            .writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
      });
      await tester.pumpWidget(const SizedBox());
    }

    await capture(
      'settings',
      'Личные настройки',
      SettingsPanel(preferences: preferences),
    );
    final channels = ChannelServer();
    await capture(
      'channels',
      'Каналы и права доступа',
      ChannelsPanel(call: channels.call),
      focus: 'Общий чат',
    );
    final members = [
      {'principalId': 'u_${'1' * 64}', 'role': 'owner', 'revision': '1'},
      {'principalId': 'u_${'2' * 64}', 'role': 'admin', 'revision': '1'},
      {'principalId': 'u_${'3' * 64}', 'role': 'member', 'revision': '1'},
      {'principalId': 'u_${'4' * 64}', 'role': 'reader', 'revision': '1'},
    ];
    await capture(
      'members',
      'Управление участниками',
      MembersPanel(
        owner: true,
        call: (path, {body, method}) async => {'members': members},
      ),
    );
    final invite = {
      'id': 'in_demo',
      'role': 'member',
      'uses': 2,
      'maxUses': 8,
      'expiresAt': '${DateTime(2027, 1, 20).millisecondsSinceEpoch ~/ 1000}',
    };
    await capture(
      'invites',
      'Приглашения',
      InvitesPanel(
        origin: 'https://203.0.113.10:8443',
        call: (path, {body, method}) async => {
          'invites': [invite],
        },
      ),
    );
    await capture(
      'devices',
      'Ваши устройства',
      DevicesPanel(
        currentGrantId: 'dg_demo_desktop',
        hasRootAuthority: true,
        onRevoked: () {},
        revoke: (_, _) async {},
        call: (path, {body, method}) async => {
          'devices': [
            {
              'id': 'dg_demo_desktop',
              'expiresAt': '4102444800',
              'scopes': [
                'chat.read',
                'chat.write',
                'device.manage',
                'space.manage',
              ],
            },
            {
              'id': 'dg_demo_laptop',
              'expiresAt': '4102444800',
              'scopes': ['chat.read', 'chat.write'],
            },
            {
              'id': 'dg_demo_recovery',
              'expiresAt': '4102444800',
              'scopes': ['chat.read', 'device.manage'],
              'recovery': true,
            },
          ],
        },
      ),
    );
    final home = HomeController()..ip = '203.0.113.10';
    addTearDown(home.dispose);
    await capture(
      'home',
      'Мой домашний сервер',
      HomePanel(
        home: home,
        onStart: (_) async {},
        onStop: () async {},
        openAdministration: () {},
      ),
    );
    await capture(
      'pairing',
      'Подключение нового устройства',
      PairingStartView(
        busy: false,
        connectionBusy: false,
        connected: false,
        code: 'pc_DEMO_PAIRING_CODE',
        signatureVerified: true,
        verification: 'ABCD-EFGH',
        error: '',
        onStart: () {},
        onAccept: () {},
        onCancel: () {},
      ),
    );
    final boundary = GlobalKey();
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
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => askRecoveryPassword(context, creating: true),
                  child: const Text('Защита карточки восстановления'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Защита карточки восстановления'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final image =
          await (boundary.currentContext!.findRenderObject()
                  as RenderRepaintBoundary)
              .toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await File('$output/identity.png')
          .writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
    expect(tester.takeException(), isNull);
  }, skip: Platform.environment['SPACE_PROMO_SCREENSHOTS'] == null);
}
