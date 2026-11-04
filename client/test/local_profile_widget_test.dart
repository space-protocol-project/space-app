import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/extensions_p1/local_profile_record.dart';
import 'package:space_client/src/extensions_p1/local_profile_verifier.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/ui/local_extension_session_scope.dart';
import 'package:space_client/ui/local_profile_unlock.dart';

import 'fixtures/directory.dart';

class WidgetVerifier extends LocalProfileVerifier {
  WidgetVerifier() : super(DirectoryStorage(), lockPath: () async => 'unused');
  bool exists = false;
  bool broken = false;
  int calls = 0;
  bool? creating;
  Completer<void>? pause;
  @override
  Future<bool> hasProfile() async {
    if (broken) throw StateError('unavailable');
    return exists;
  }

  @override
  Future<LocalProfileIdentity> verify(
    String password, {
    required bool create,
    required bool Function() active,
  }) async {
    calls++;
    creating = create;
    await pause?.future;
    if (!active())
      throw const LocalProfileException(LocalProfileFailure.cancelled);
    if (password != 'valid password')
      throw const LocalProfileException(LocalProfileFailure.denied);
    return (device: 'device', profile: 'profile', actor: 'owner');
  }
}

void main() {
  late WidgetVerifier service;
  late LocalSessionCubit access;
  final password = find.byKey(const ValueKey('local-profile-password'));
  final confirmation = find.byKey(const ValueKey('local-profile-confirm'));
  Future<void> mount(WidgetTester tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final navigator = GlobalKey<NavigatorState>();
    access = LocalSessionCubit(
      authenticate: () => showDialog<LocalProfileIdentity>(
        context: navigator.currentContext!,
        builder: (_) => LocalProfileUnlockDialog(service: service),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (_, child) =>
            LocalExtensionSessionScope(access: access, child: child!),
        home: Scaffold(body: LocalProfileAccessCard(access: access)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Разблокировать'));
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester, String value) async {
    await tester.enterText(password, value);
    if (confirmation.evaluate().isNotEmpty)
      await tester.enterText(confirmation, value);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => service = WidgetVerifier());
  tearDown(() async => access.close());

  testWidgets(
    'настройка требует совпадения и передаёт профиль в настоящую сессию',
    (tester) async {
      await mount(tester);
      await tester.enterText(password, 'valid password');
      await tester.enterText(confirmation, 'different');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();
      expect(service.calls, 0);
      expect(find.text('Пароли не совпадают.'), findsOneWidget);
      await submit(tester, 'valid password');
      expect(service.creating, true);
      expect(access.session.profile, 'profile');
      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.text('Заблокировать'));
      await tester.pumpAndSettle();
      expect(() => access.session, throwsStateError);
    },
  );

  testWidgets('неверный пароль оставляет форму открытой и очищает ввод', (
    tester,
  ) async {
    service.exists = true;
    await mount(tester);
    expect(confirmation, findsNothing);
    await submit(tester, 'wrong password');
    expect(() => access.session, throwsStateError);
    expect(tester.widget<TextField>(password).controller!.text, isEmpty);
    await submit(tester, 'valid password');
    expect(service.creating, false);
    expect(access.state, LocalSessionStatus.unlocked);
  });

  testWidgets(
    'фон во время проверки закрывает форму и отклоняет поздний ответ',
    (tester) async {
      service.exists = true;
      service.pause = Completer<void>();
      await mount(tester);
      await tester.enterText(password, 'valid password');
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pumpAndSettle();
      service.pause!.complete();
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.byType(AlertDialog), findsNothing);
      expect(access.state, LocalSessionStatus.locked);
      expect(() => access.session, throwsStateError);
    },
  );

  testWidgets('ошибка хранилища не предлагает пересоздание профиля', (
    tester,
  ) async {
    service.broken = true;
    await mount(tester);
    expect(password, findsNothing);
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(FilledButton),
      ),
      findsNothing,
    );
    expect(service.calls, 0);
    expect(() => access.session, throwsStateError);
  });
}
