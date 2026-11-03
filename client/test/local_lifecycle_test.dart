import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';
import 'package:space_client/src/extensions_p1/local_sessions.dart';

import 'support/local_lifecycle_fixture.dart';

void main() {
  late Directory directory;
  late LifecycleFixture fixture;
  setUp(() {
    directory = Directory.systemTemp.createTempSync('lifecycle-');
    fixture = LifecycleFixture('${directory.path}/registry');
  });
  tearDown(() {
    fixture.host.close();
    directory.deleteSync(recursive: true);
  });

  test('полный цикл, разрешение, активный вызов и восстановление', () async {
    await fixture.act(LocalLifecycleAction.install);
    expect(fixture.entry['state'], 'disabled');
    await fixture.act(LocalLifecycleAction.enable);
    expect(
      () => fixture.host.beginRead(
        fixture.session,
        'games',
        fixture.authority.root,
      ),
      throwsStateError,
    );
    await fixture.act(LocalLifecycleAction.grant);
    final lease = fixture.host.beginRead(
      fixture.session,
      'games',
      fixture.authority.root,
    );
    expect(lease.deliver('data'), 'data');
    await fixture.act(LocalLifecycleAction.disable);
    expect(lease.isCancelled, isTrue);
    expect(() => lease.deliver('late'), throwsStateError);
    await expectLater(
      fixture.act(LocalLifecycleAction.drained),
      throwsStateError,
    );
    lease.close();
    await fixture.act(LocalLifecycleAction.drained);
    await fixture.act(LocalLifecycleAction.prepare, plan: fixture.plan());
    await fixture.act(LocalLifecycleAction.advance);
    expect(fixture.entry['data'], '{}');
    fixture.reopen();
    expect(fixture.entry['state'], 'ready');
    await fixture.act(LocalLifecycleAction.publish);
    expect(fixture.entry['package'], 'b' * 64);
    expect(jsonDecode(fixture.entry['data']! as String), {'step': 1});
    expect(fixture.record['history'], ['2' * 32]);
    expect(fixture.record['data_revision'], 1);
    fixture.reopen();
    expect(fixture.record['history'], ['2' * 32]);
    await fixture.act(LocalLifecycleAction.remove);
    await fixture.act(LocalLifecycleAction.purge);
    expect(fixture.record['present'], false);
    expect(fixture.entry['data'], 'null');
    await expectLater(
      fixture.act(LocalLifecycleAction.install),
      throwsStateError,
    );
    await expectLater(
      fixture.act(LocalLifecycleAction.purge),
      throwsStateError,
    );
  });

  test('abort, quarantine, recover, reopen и обновление только кода', () async {
    await fixture.act(LocalLifecycleAction.install);
    await fixture.act(LocalLifecycleAction.prepare, plan: fixture.plan());
    await fixture.act(LocalLifecycleAction.abort);
    expect(fixture.entry['staged'], isNull);
    await fixture.act(
      LocalLifecycleAction.prepare,
      plan: fixture.plan(codeOnly: true),
    );
    await fixture.act(LocalLifecycleAction.quarantine);
    expect(fixture.entry['staged'], isNotNull);
    await fixture.act(LocalLifecycleAction.recover);
    expect(fixture.entry['staged'], isNull);
    await fixture.act(
      LocalLifecycleAction.prepare,
      plan: fixture.plan(codeOnly: true),
    );
    await fixture.act(LocalLifecycleAction.publish);
    expect(fixture.entry['package'], 'c' * 64);
    await fixture.act(LocalLifecycleAction.enable);
    await fixture.act(LocalLifecycleAction.reopen);
    expect(fixture.entry['state'], 'disabled');
  });

  test(
    'отзыв во время чтения и повторное согласие не оживляют старый ответ',
    () async {
      await fixture.act(LocalLifecycleAction.install);
      await fixture.act(LocalLifecycleAction.enable);
      await fixture.act(LocalLifecycleAction.grant);
      final stale = fixture.command(
        LocalLifecycleAction.revoke,
        root: fixture.authority.root,
      );
      final lease = fixture.host.beginRead(
        fixture.session,
        'games',
        fixture.authority.root,
      );
      await fixture.host.execute(fixture.session, stale);
      expect(() => lease.deliver('late'), throwsStateError);
      await expectLater(
        fixture.host.execute(fixture.session, stale),
        throwsStateError,
      );
      lease.close();
      await fixture.act(LocalLifecycleAction.grant);
      expect(() => lease.deliver('late'), throwsStateError);
      final next = fixture.host.beginRead(
        fixture.session,
        'games',
        fixture.authority.root,
      );
      expect(next.deliver(1), 1);
      next.close();
    },
  );

  test('чужая сессия и блокировка отзывают допуск и сохраняются', () async {
    await fixture.act(LocalLifecycleAction.install);
    await fixture.act(LocalLifecycleAction.enable);
    await fixture.act(LocalLifecycleAction.grant);
    final other = LocalExtensionSessions().unlock('device', 'profile', 'owner');
    expect(() => fixture.host.snapshot(other), throwsStateError);
    final lease = fixture.host.beginRead(
      fixture.session,
      'games',
      fixture.authority.root,
    );
    fixture.sessions.lock();
    expect(lease.isCancelled, true);
    expect(() => lease.deliver('late'), throwsStateError);
    expect(() => fixture.host.snapshot(fixture.session), throwsStateError);
    lease.close();
    fixture.session = fixture.sessions.unlock('device', 'profile', 'owner');
    expect(fixture.entry['state'], 'disabled');
    expect(
      (fixture.record['grants']! as Map).values.every(
        (g) => (g as Map)['active'] == false,
      ),
      true,
    );
    fixture.reopen();
    expect(fixture.entry['state'], 'disabled');
    expect(
      (fixture.record['audit']! as List).any(
        (e) => (e as Map)['action'] == 'lock',
      ),
      true,
    );
  });

  test('блокировка во время проверки запрещает поздний COMMIT', () async {
    await fixture.act(LocalLifecycleAction.install);
    fixture.authority.barrier = Completer<void>();
    final operation = fixture.act(LocalLifecycleAction.enable);
    final expectation = expectLater(operation, throwsStateError);
    fixture.sessions.lock();
    fixture.authority.barrier!.complete();
    await expectation;
    fixture.session = fixture.sessions.unlock('device', 'profile', 'owner');
    expect(fixture.entry['state'], 'disabled');
  });

  test('конкурентные команды фиксируют только одну ревизию', () async {
    await fixture.act(LocalLifecycleAction.install);
    fixture.authority.barrier = Completer<void>();
    final command = fixture.command(LocalLifecycleAction.enable);
    final first = fixture.host.execute(fixture.session, command);
    final second = fixture.host.execute(fixture.session, command);
    final rejected = expectLater(second, throwsStateError);
    fixture.authority.barrier!.complete();
    await first;
    await rejected;
    expect(fixture.record['revision'], 2);
  });

  test(
    'проверки пакета, согласия, плана и миграции не меняют снимок',
    () async {
      await fixture.act(LocalLifecycleAction.install);
      final before = fixture.host.snapshot(fixture.session).encode();
      fixture.authority.trusted = false;
      await expectLater(
        fixture.act(LocalLifecycleAction.enable),
        throwsStateError,
      );
      fixture.authority.trusted = true;
      fixture.authority.consent = false;
      await expectLater(
        fixture.act(LocalLifecycleAction.enable),
        throwsStateError,
      );
      fixture.authority.consent = true;
      final plan = fixture.plan()..['source'] = 'f' * 64;
      await expectLater(
        fixture.act(LocalLifecycleAction.prepare, plan: plan),
        throwsStateError,
      );
      expect(fixture.host.snapshot(fixture.session).encode(), before);
      await fixture.act(LocalLifecycleAction.prepare, plan: fixture.plan());
      fixture.authority.migrationOk = false;
      final pending = fixture.host.snapshot(fixture.session).encode();
      await expectLater(
        fixture.act(LocalLifecycleAction.advance),
        throwsStateError,
      );
      expect(fixture.host.snapshot(fixture.session).encode(), pending);
    },
  );

  test(
    'restore проверяет владельца и не восстанавливает активный grant',
    () async {
      await fixture.act(LocalLifecycleAction.install);
      await fixture.act(LocalLifecycleAction.enable);
      await fixture.act(LocalLifecycleAction.grant);
      final saved = fixture.entry;
      fixture.authority.saved = (
        scope: 'other/profile',
        instance: 'games',
        entry: saved,
      );
      await expectLater(
        fixture.act(LocalLifecycleAction.restore),
        throwsStateError,
      );
      fixture.authority.saved = (
        scope: 'device/profile',
        instance: 'games',
        entry: saved,
      );
      final revision = fixture.record['revision']! as int;
      await fixture.act(LocalLifecycleAction.restore);
      expect(fixture.entry['state'], 'disabled');
      expect(fixture.record['revision'], revision + 1);
      expect(
        (fixture.record['grants']! as Map).values.every(
          (g) => (g as Map)['active'] == false,
        ),
        true,
      );
    },
  );

  for (final phase in ['before', 'partial', 'after']) {
    test(
      'ошибка $phase закрывает допуск, восстановление сохраняет атомарность',
      () async {
        await fixture.act(LocalLifecycleAction.install);
        await fixture.act(LocalLifecycleAction.enable);
        await fixture.act(LocalLifecycleAction.grant);
        final lease = fixture.host.beginRead(
          fixture.session,
          'games',
          fixture.authority.root,
        );
        await expectLater(
          fixture.act(
            LocalLifecycleAction.revoke,
            root: fixture.authority.root,
            checkpoint: (point) {
              if (point == phase) throw StateError('injected');
            },
          ),
          throwsStateError,
        );
        expect(lease.isCancelled, true);
        expect(() => fixture.host.snapshot(fixture.session), throwsStateError);
        lease.close();
        fixture.reopen();
        final audit = fixture.record['audit']! as List;
        expect(
          audit.any((e) => (e as Map)['action'] == 'revoke'),
          phase == 'after',
        );
        expect(fixture.entry['state'], 'disabled');
        expect(
          (fixture.record['grants']! as Map).values.every(
            (g) => (g as Map)['active'] == false,
          ),
          true,
        );
      },
    );
  }
}
