import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/connection_panel.dart';

class _Vault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

class _Controller extends ChatController {
  _Controller() : super(_Vault());
  String inspectedAddress = '', token = '';
  @override
  bool get canWrite => connected;
  @override
  Future<void> inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
  }) async {
    inspectedAddress = address;
    final input = parseConnectionInput(
      address,
      invitationToken: invitationToken,
    );
    token = input.invitationToken;
    preview = Discovery(
      input.origin,
      'srv_${'a' * 32}',
      List.filled(32, 1),
      tlsFingerprint: input.tlsFingerprint,
    );
    fingerprint = 'b' * 64;
    invitationRole = 'reader';
    notifyListeners();
  }

  @override
  Future<void> connect({
    DeviceRecord? restoredRecord,
    String pairingId = '',
    String setupCode = '',
  }) async {
    connected = true;
    notifyListeners();
  }
}

Widget localized(Locale locale, Widget child) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

void main() {
  for (final locale in [
    const Locale('ru'),
    const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    const Locale('en'),
  ]) {
    testWidgets(
      'Подключение ${locale.toLanguageTag()}: приглашение, TLS и узкое окно',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(430, 900);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final controller = _Controller();
        addTearDown(controller.dispose);
        final strings = lookupAppLocalizations(locale);
        var connected = 0;
        await tester.pumpWidget(
          localized(
            locale,
            ConnectionPanel(
              controller: controller,
              onConnected: (_) async {
                connected++;
              },
            ),
          ),
        );
        final url =
            'https://203.0.113.10:8443#invite=iv_${'c' * 43}&tls=${'d' * 64}';
        await tester.enterText(find.byType(TextField).first, url);
        await tester.tap(find.text(strings.checkServer));
        await tester.pumpAndSettle();
        expect(controller.inspectedAddress, url);
        expect(controller.token, 'iv_${'c' * 43}');
        expect(find.text(strings.serverKeyFingerprint), findsOneWidget);
        expect(find.text(strings.tlsCertificateFingerprint), findsOneWidget);
        expect(find.text(strings.readerInvitation), findsOneWidget);
        await tester.ensureVisible(find.text(strings.trustAndConnect));
        await tester.tap(find.text(strings.trustAndConnect));
        await tester.pumpAndSettle();
        expect(connected, 1);
        expect(controller.connected, true);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('Смена языка сохраняет черновик чата и переводит отправку', (
    tester,
  ) async {
    final controller = _Controller()..connected = true;
    addTearDown(controller.dispose);
    for (final locale in [
      const Locale('ru'),
      const Locale('en'),
      const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    ]) {
      await tester.pumpWidget(
        localized(
          locale,
          ChatView(controller: controller, openConnection: () {}),
        ),
      );
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('chat-draft'));
      if (locale.languageCode == 'ru') {
        await tester.enterText(field, 'Черновик不丢失 — draft');
      }
      final widget = tester.widget<TextField>(field);
      expect(widget.controller!.text, 'Черновик不丢失 — draft');
      expect(
        widget.decoration!.hintText,
        lookupAppLocalizations(locale).messageHint,
      );
      expect(
        find.byTooltip(lookupAppLocalizations(locale).sendMessage),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
