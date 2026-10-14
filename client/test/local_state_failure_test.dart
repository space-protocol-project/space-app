import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/key_vault.dart';
import 'package:space_client/src/local_failure.dart';
import 'package:space_client/src/recovery_qr.dart';
import 'package:space_client/ui/connection_panel.dart';

import 'channels_test.dart' show ChannelSession, ChannelVault, MemoryPositions;

class BrokenPositions extends MemoryPositions {
  @override
  Future<Map<String, dynamic>> load(String scope) async =>
      throw StateError('private storage');
}

class JournalStorage implements SecureKeyStorage {
  String value = '[]';
  @override
  Future<String?> read({required String key}) async => value;
  @override
  Future<void> write({required String key, required String value}) async {}
  @override
  Future<void> delete({required String key}) async {}
}

void main() {
  test('Ошибки QR сохраняют код через isolate', () async {
    await expectLater(
      compute(pngInWorker, 'x' * 4000),
      throwsA(
        isA<LocalFailure>().having(
          (e) => e.code,
          'code',
          LocalFailureCode.qrTooLarge,
        ),
      ),
    );
    await expectLater(
      compute(artifactInWorker, Uint8List(16385)),
      throwsA(
        isA<LocalFailure>().having(
          (e) => e.code,
          'code',
          LocalFailureCode.qrFileTooLarge,
        ),
      ),
    );
  });
  test('Журнал отклоняет JSON неверного типа и неверную кодировку', () async {
    final storage = JournalStorage();
    final vault = KeyIdentityVault(storage);
    for (final value in ['[]', '{broken', 'x' * 65537]) {
      storage.value = value;
      await expectLater(
        vault.loadRotation('https://example.org'),
        throwsA(
          isA<LocalFailure>().having(
            (e) => e.code,
            'code',
            LocalFailureCode.keyJournalInvalid,
          ),
        ),
      );
    }
  });
  testWidgets('Ошибка чтения позиций переводится без потери канала и сессии', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final session = ChannelSession();
    final controller =
        ChatController(
            ChannelVault(),
            positions: BrokenPositions(),
            openSession: (_, _) async => session,
          )
          ..preview = Discovery(
            Uri.parse('https://example.org'),
            'srv_test',
            List.filled(32, 1),
          );
    addTearDown(controller.dispose);
    await controller.connect();
    expect(controller.failureCode, LocalFailureCode.positionsLoad);
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
          lookupAppLocalizations(Locale(language)).failurePositionsLoad,
        ),
        findsOneWidget,
      );
      expect(find.textContaining('private storage'), findsNothing);
      expect(controller.connected, true);
      expect(controller.channelId, 'general');
      expect(tester.takeException(), isNull);
    }
  });
}
