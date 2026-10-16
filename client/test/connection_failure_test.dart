import 'support/chat_outbox.dart';
import 'channels_test.dart' show MemoryHistory;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/local_failure.dart';
import 'package:space_client/ui/connection_panel.dart';

import 'stream_test.dart' show Vault;

void main() {
  test('Коды gRPC не зависят от текста сервера', () {
    for (final entry in {
      StatusCode.permissionDenied: LocalFailureCode.permissionDenied,
      StatusCode.unauthenticated: LocalFailureCode.unauthenticated,
      StatusCode.resourceExhausted: LocalFailureCode.serverLimit,
      StatusCode.unavailable: LocalFailureCode.connectionFailed,
    }.entries) {
      expect(
        classifyFailure(GrpcError.custom(entry.key, 'private-server-data')),
        entry.value,
      );
    }
    expect(
      () => localOrigin('http://example.org'),
      throwsA(
        isA<LocalFailure>().having(
          (e) => e.code,
          'code',
          LocalFailureCode.addressInvalid,
        ),
      ),
    );
  });
  testWidgets(
    'Отказ в доступе меняет язык без повторного соединения и утечки текста',
    (tester) async {
      var calls = 0;
      final controller =
          ChatController(
              Vault(),
              historyStore: MemoryHistory(),
              outboxStore: MemoryChatOutbox(),
              openSession: (_, _) async {
                calls++;
                throw const GrpcError.permissionDenied('private-server-data');
              },
            )
            ..preview = Discovery(
              Uri.parse('https://example.org'),
              'srv_test',
              List.filled(32, 1),
            );
      addTearDown(controller.dispose);
      await controller.connect();
      expect(controller.connected, false);
      final locale = ValueNotifier(const Locale('ru'));
      addTearDown(locale.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<Locale>(
          valueListenable: locale,
          builder: (_, language, _) => MaterialApp(
            locale: language,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Scaffold(
              body: ConnectionPanel(
                controller: controller,
                onConnected: (_) async {},
                origin: 'https://example.org',
              ),
            ),
          ),
        ),
      );
      for (final language in ['ru', 'zh', 'en']) {
        locale.value = Locale(language);
        await tester.pumpAndSettle();
        expect(
          find.text(
            lookupAppLocalizations(Locale(language)).failurePermissionDenied,
          ),
          findsOneWidget,
        );
        expect(find.textContaining('private-server-data'), findsNothing);
        expect(find.text('https://example.org'), findsWidgets);
        expect(calls, 1);
        expect(tester.takeException(), isNull);
      }
      await controller.disconnect();
      expect(controller.failureCode, isNull);
    },
  );
}
