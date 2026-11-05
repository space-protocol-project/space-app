import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/app_shutdown.dart';
import 'package:space_client/src/extensions_p1/local_session_cubit.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_record.dart';
import 'package:space_client/ui/local_extension_session_scope.dart';

import 'support/local_lifecycle_fixture.dart';

const identity = (device: 'device', profile: 'profile', actor: 'owner');

void main() {
  testWidgets('первый вход требует активного окна и явного действия', (
    tester,
  ) async {
    var authentications = 0;
    final access = LocalSessionCubit(
      authenticate: () async {
        authentications++;
        return identity;
      },
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(
      LocalExtensionSessionScope(access: access, child: const SizedBox()),
    );
    expect(find.byType(LocalExtensionSessionScope), findsOneWidget);
    for (final state in [
      AppLifecycleState.detached,
      AppLifecycleState.hidden,
      AppLifecycleState.inactive,
    ]) {
      tester.binding.handleAppLifecycleStateChanged(state);
      expect(await access.unlock(), false);
      expect(authentications, 0);
    }
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(access.state, LocalSessionStatus.locked);
    expect(authentications, 0);
    expect(await access.unlock(), true);
    expect(authentications, 1);
    await tester.pumpWidget(const SizedBox());
    await access.close();
  });

  test('без службы аутентификации доступ закрыт', () async {
    final access = LocalSessionCubit()..setForeground(true);
    expect(await access.unlock(), false);
    expect(access.state, LocalSessionStatus.unavailable);
    expect(() => access.session, throwsStateError);
    await access.close();
  });

  test('один запрос, поздний ответ после блокировки не разблокирует', () async {
    final pending = Completer<LocalProfileIdentity?>();
    var calls = 0;
    final access = LocalSessionCubit(
      authenticate: () {
        calls++;
        return pending.future;
      },
    )..setForeground(true);
    final first = access.unlock();
    final second = access.unlock();
    access.lock();
    pending.complete(identity);
    expect(await first, false);
    expect(await second, false);
    expect(calls, 1);
    expect(() => access.session, throwsStateError);
    await access.close();
  });

  test('ошибка, отмена и неверный профиль не дают сессию', () async {
    for (final callback in <LocalProfileAuthenticator>[
      () async => null,
      () async => throw StateError('denied'),
      () async => (device: '', profile: 'profile', actor: 'owner'),
    ]) {
      final access = LocalSessionCubit(authenticate: callback)
        ..setForeground(true);
      expect(await access.unlock(), false);
      expect(access.state, LocalSessionStatus.locked);
      expect(() => access.session, throwsStateError);
      await access.close();
    }
  });

  test('завершение и закрытие запрещают позднюю разблокировку', () async {
    final pending = Completer<LocalProfileIdentity?>();
    final access = LocalSessionCubit(authenticate: () => pending.future)
      ..setForeground(true);
    final operation = access.unlock();
    await access.close();
    pending.complete(identity);
    expect(await operation, false);
    expect(await access.unlock(), false);
  });

  testWidgets('уход в фон отзывает настоящую сессию и чтение реестра', (
    tester,
  ) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final access = LocalSessionCubit(authenticate: () async => identity);
    final directory = Directory.systemTemp.createTempSync('scope-');
    final host = LocalLifecycleHost.open(
      '${directory.path}/registry',
      device: 'device',
      profile: 'profile',
      sessions: access.sessions,
      authority: FixtureAuthority(),
    );
    await tester.pumpWidget(
      LocalExtensionSessionScope(access: access, child: const SizedBox()),
    );
    expect(await access.unlock(), true);
    final session = access.session;
    await host.execute(
      session,
      LocalLifecycleCommand(
        action: LocalLifecycleAction.install,
        installation: 'games',
        instance: 'games',
        revision: 0,
        generation: host.snapshot(session).generation,
        package: 'a' * 64,
      ),
    );
    for (final action in [
      LocalLifecycleAction.enable,
      LocalLifecycleAction.grant,
    ]) {
      final record = lifecycleOf(host.snapshot(session).entries['games']!);
      await host.execute(
        session,
        LocalLifecycleCommand(
          action: action,
          installation: 'games',
          instance: 'games',
          revision: record['revision']! as int,
          generation: record['generation']! as String,
        ),
      );
    }
    final lease = host.beginRead(session, 'games', '1' * 32);
    expect(lease.deliver('before'), 'before');
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    expect(lease.isCancelled, true);
    expect(() => lease.deliver('late'), throwsStateError);
    lease.close();
    expect(() => host.snapshot(session), throwsStateError);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    expect(access.state, LocalSessionStatus.locked);
    expect(await access.unlock(), true);
    expect(
      host.snapshot(access.session).entries['games']!['state'],
      'disabled',
    );
    await tester.pumpWidget(const SizedBox());
    expect(() => access.session, throwsStateError);
    expect(await access.unlock(), false);
    host.close();
    await access.close();
    directory.deleteSync(recursive: true);
  });

  testWidgets(
    'завершение блокирует сессию до prepare, даже при ошибке остановки',
    (tester) async {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      final access = LocalSessionCubit(authenticate: () async => identity);
      final shutdown = AppShutdown();
      await tester.pumpWidget(
        LocalExtensionSessionScope(
          access: access,
          shutdown: shutdown,
          child: const SizedBox(),
        ),
      );
      await access.unlock();
      shutdown.prepare = () async {
        expect(() => access.session, throwsStateError);
        throw StateError('stop_failed');
      };
      expect(await shutdown.request(), false);
      expect(await access.unlock(), false);
      await tester.pumpWidget(const SizedBox());
      await access.close();
      await shutdown.close();
    },
  );

  testWidgets('замена области отзывает старый контекст', (tester) async {
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    final first = LocalSessionCubit(authenticate: () async => identity);
    final second = LocalSessionCubit(authenticate: () async => identity);
    await tester.pumpWidget(
      LocalExtensionSessionScope(access: first, child: const SizedBox()),
    );
    await first.unlock();
    await tester.pumpWidget(
      LocalExtensionSessionScope(access: second, child: const SizedBox()),
    );
    expect(() => first.session, throwsStateError);
    expect(second.state, LocalSessionStatus.locked);
    await tester.pumpWidget(const SizedBox());
    await first.close();
    await second.close();
  });
}
