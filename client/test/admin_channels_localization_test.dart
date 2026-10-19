import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'admin_channels_panel_test.dart' show ChannelServer, press, toggle;

void main() {
  testWidgets('Смена языка сохраняет название и несохранённые ACL', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final locale = ValueNotifier(const Locale('ru'));
    addTearDown(locale.dispose);
    final server = ChannelServer();
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, language, _) => MaterialApp(
          locale: language,
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChannelsPanel(call: server.call),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await press(tester, 'Общий чат');
    final name = find.byKey(const ValueKey('channel-title'));
    await tester.ensureVisible(name);
    await tester.enterText(name, 'Черновик 频道 draft');
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
    await toggle(tester, 'rule-0-read');
    for (final language in ['zh', 'en', 'ru']) {
      locale.value = Locale(language);
      await tester.pumpAndSettle();
      final strings = lookupAdminLocalizations(Locale(language));
      expect(find.text(strings.channelLoaded), findsOneWidget);
      expect(
        tester.widget<TextField>(name).controller!.text,
        'Черновик 频道 draft',
      );
      expect(
        tester
            .widget<CheckboxListTile>(find.byKey(const ValueKey('rule-0-read')))
            .value,
        false,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('rule-0-write')),
            )
            .value,
        false,
      );
      expect(server.access['general']!.first['permissions']['read'], true);
      expect(tester.takeException(), isNull);
    }
    locale.value = const Locale('en');
    await tester.pumpAndSettle();
    await press(tester, 'Save permissions');
    expect(server.access['general']!.first['role'], 'member');
    expect(server.access['general']!.last['role'], 'reader');
    expect(server.access['general']!.first['permissions']['read'], false);
    expect(server.access['general']!.first['permissions']['write'], false);
    await press(tester, 'Save chat');
    expect(server.channels['general']!['title'], 'Черновик 频道 draft');
    expect(server.channels['general']!['revision'], '3');
    locale.value = const Locale('zh');
    await tester.pumpAndSettle();
    expect(find.text('聊天设置已保存。'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
