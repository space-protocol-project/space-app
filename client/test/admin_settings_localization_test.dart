import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_api/space_api.dart';

void main() {
  testWidgets('Язык настроек меняется без потери черновика и прав', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final locale = ValueNotifier(const Locale('ru'));
    addTearDown(locale.dispose);
    final api = SettingsGateway();
    await tester.pumpWidget(
      ValueListenableBuilder<Locale>(
        valueListenable: locale,
        builder: (_, language, _) => MaterialApp(
          locale: language,
          supportedLocales: AdminLocalizations.supportedLocales,
          localizationsDelegates: AdminLocalizations.localizationsDelegates,
          home: AdminPage(
            autoConnect: true,
            login: ({bool create = false}) async => {
              'origin': 'http://127.0.0.1:8080',
              'serverId': 'server',
              'principalId': 'owner',
              'role': 'owner',
              'token': 'session',
              'expires': 4102444800,
              'administrative': true,
            },
            gateway: (_) => api,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final name = find.widgetWithText(TextField, 'Название пространства');
    await tester.ensureVisible(name);
    await tester.enterText(name, 'Мой 未保存 draft');
    for (final language in ['zh', 'en', 'ru']) {
      locale.value = Locale(language);
      await tester.pumpAndSettle();
      final strings = lookupAdminLocalizations(Locale(language));
      expect(find.text(strings.settingsLoaded), findsOneWidget);
      final field = find.widgetWithText(TextField, strings.spaceName);
      expect(tester.widget<TextField>(field).controller!.text, 'Мой 未保存 draft');
      expect(tester.takeException(), isNull);
    }
    locale.value = const Locale('en');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save settings'));
    await tester.tap(find.text('Save settings'));
    await tester.pumpAndSettle();
    expect(api.saved!['title'], 'Мой 未保存 draft');
    expect(api.saved!['chatTitle'], 'Общий чат');
    expect(api.saved!['registrationPolicy'], 'closed');
    expect(api.saved!['expectedRevision'], '1');
    expect(find.text('Settings saved on the server.'), findsOneWidget);
    locale.value = const Locale('zh');
    await tester.pumpAndSettle();
    expect(find.text('设置已保存到服务器。'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class SettingsGateway extends SpaceGateway {
  SettingsGateway() : super(Uri.parse('http://127.0.0.1:8080'));
  Map<String, dynamic>? saved;
  @override
  Future<Map<String, dynamic>> call(
    String path, {
    String token = '',
    Map<String, dynamic>? body,
    String? method,
  }) async {
    if (path.endsWith('/setup')) return {'initialized': true};
    if (path.endsWith('/settings')) {
      if (method == 'PATCH') saved = body;
      return {
        'settings': {
          'title': body?['title'] ?? 'Space',
          'chatTitle': 'Общий чат',
          'chatEnabled': true,
          'registrationPolicy': 'closed',
          'revision': '1',
        },
      };
    }
    return {};
  }
}
