import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart'
    show CommunityMention;
import 'package:space_client/src/personal_notifications_controller.dart';
import 'package:space_client/src/personal_notification_target.dart';
import 'package:space_client/src/personal_inbox_controller.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart' show Content;

import 'support/personal_notifications.dart';

void main() {
  late PersonalTestWorkspace fixture;
  late PersonalNotificationsController controller;
  final delivered = <List<int>>[];
  var accepted = true;
  setUp(() async {
    fixture = PersonalTestWorkspace();
    await fixture.start();
    delivered.clear();
    accepted = true;
    controller = PersonalNotificationsController(
      fixture.workspaces,
      interval: null,
      deliver: (_, notices) async {
        delivered.add(notices.map((n) => n.sequence.toInt()).toList());
        return accepted;
      },
    );
  });
  tearDown(() async {
    await controller.close();
    fixture.dispose();
  });

  test('Начальная граница не уведомляет об истории; пачки ограничены и не теряются', () async {
    for (var i = 1; i <= 70; i++) {
      fixture.api.add(personalNotice(i));
    }
    controller.setDeliveryEnabled(true);
    await controller.poll();
    expect(delivered, isEmpty);
    for (var i = 71; i <= 140; i++) {
      fixture.api.add(personalNotice(i));
    }
    for (var i = 0; i < 3; i++) {
      await controller.poll();
    }
    expect(delivered.map((batch) => batch.length), [32, 32, 6]);
    expect(delivered.expand((n) => n), List.generate(70, (i) => i + 71));
    await controller.poll();
    expect(delivered, hasLength(3));
  });

  test('Отказ адаптера сохраняет пачку для повтора', () async {
    controller.setDeliveryEnabled(true);
    await controller.poll();
    fixture.api.add(personalNotice(1));
    accepted = false;
    await controller.poll();
    accepted = true;
    await controller.poll();
    await controller.poll();
    expect(delivered, [
      [1],
      [1],
    ]);
  });

  test(
    'Смена режима во время запроса отменяет доставку и заново задаёт границу',
    () async {
      controller.setDeliveryEnabled(true);
      await controller.poll();
      fixture.api.add(personalNotice(1));
      fixture.api.listGate = Completer<void>();
      final pending = controller.poll();
      await Future<void>.delayed(Duration.zero);
      controller.setDeliveryEnabled(false);
      fixture.api.listGate!.complete();
      await pending;
      fixture.api.listGate = null;
      controller.setDeliveryEnabled(true);
      await controller.poll();
      expect(delivered, isEmpty);
      fixture.api.add(personalNotice(2));
      await controller.poll();
      expect(delivered, [
        [2],
      ]);
    },
  );

  test('Повторное подключение той же личности дочитывает события', () async {
    controller.setDeliveryEnabled(true);
    await controller.poll();
    await fixture.chatController.disconnect();
    controller.synchronize();
    fixture.api.add(personalNotice(1));
    await fixture.workspaces.refresh();
    controller.synchronize();
    await controller.poll();
    expect(delivered, [
      [1],
    ]);
  });

  test('Другая личность не получает запоздалую запись и старую цель', () async {
    controller.setDeliveryEnabled(true);
    await controller.poll();
    fixture.api.add(personalNotice(1));
    final previous = controller.state.scopes.single.target(personalNotice(1));
    fixture.api.listGate = Completer<void>();
    final pending = controller.poll();
    await Future<void>.delayed(Duration.zero);
    fixture.session.principal = 'u_other';
    controller.synchronize();
    fixture.api.listGate!.complete();
    await pending;
    fixture.api.listGate = null;
    await controller.poll();
    expect(delivered, isEmpty);
    expect(await controller.resolve(previous), isNull);
    fixture.api.add(personalNotice(1));
    await controller.poll();
    expect(delivered, [
      [1],
    ]);
  });

  test('Отзыв ACL во время запроса отбрасывает тело страницы', () async {
    controller.setDeliveryEnabled(true);
    await controller.poll();
    fixture.api.add(personalNotice(1));
    fixture.api.listGate = Completer<void>();
    final pending = controller.poll();
    await Future<void>.delayed(Duration.zero);
    fixture.session.availableChannels.single.permissions.read = false;
    controller.synchronize();
    fixture.api.listGate!.complete();
    await pending;
    expect(delivered, isEmpty);
    expect(controller.state.scopes, isEmpty);
  });

  test(
    'Повтор доступного раздела после отказа начинает с новой границы',
    () async {
      controller.setDeliveryEnabled(true);
      await controller.poll();
      fixture.api.add(personalNotice(1));
      fixture.api.listError = const GrpcError.permissionDenied();
      await controller.poll();
      expect(controller.state.scopes, isEmpty);
      fixture.api.listError = null;
      await controller.poll();
      expect(controller.state.scopes, hasLength(1));
      expect(delivered, isEmpty);
      fixture.api.add(personalNotice(2));
      await controller.poll();
      expect(delivered, [
        [2],
      ]);
    },
  );

  test('Некорректная страница не продвигает доставку', () async {
    controller.setDeliveryEnabled(true);
    await controller.poll();
    fixture.api.add(personalNotice(1));
    fixture.api.alter = (page) => page
      ..hasMore = true
      ..nextSequence = Int64.ZERO;
    await controller.poll();
    expect(delivered, isEmpty);
    fixture.api.alter = null;
    await controller.poll();
    expect(delivered, [
      [1],
    ]);
  });

  test(
    'Список: страницы, явный просмотр и возврат к первой странице',
    () async {
      for (var i = 1; i <= 55; i++) {
        fixture.api.add(personalNotice(i));
      }
      final inbox = PersonalInboxController(controller, interval: null);
      addTearDown(inbox.close);
      await Future<void>.delayed(Duration.zero);
      expect(inbox.state.items, hasLength(50));
      expect(inbox.state.hasMore, isTrue);
      await inbox.next();
      expect(inbox.state.items, hasLength(5));
      expect(inbox.state.after, 50);
      await inbox.previous();
      expect(inbox.state.after, 0);
      await inbox.markRead(inbox.state.items.first);
      expect(fixture.api.readIds.single, ['pn_1']);
      expect(inbox.state.items.any((n) => n.id == 'pn_1'), isFalse);
      await inbox.refresh();
      expect(inbox.state.after, 0);
      expect(inbox.state.items.first.id, 'pn_2');
    },
  );

  test('Ошибка просмотра не рисует успешное подтверждение', () async {
    fixture.api.add(personalNotice(1));
    final inbox = PersonalInboxController(controller, interval: null);
    addTearDown(inbox.close);
    await Future<void>.delayed(Duration.zero);
    fixture.api.markError = const GrpcError.unavailable();
    await inbox.markRead(inbox.state.items.single);
    expect(inbox.state.failed, isTrue);
    expect(inbox.state.items, hasLength(1));
  });

  test('Сохранённая цель проверяет формат и границы', () {
    expect(
      PersonalNotificationTarget.decode('["personal","o","p","c",1,"pn_1"]'),
      isNotNull,
    );
    for (final payload in [
      '[]',
      '["personal","o","p","c",0,"id"]',
      '["personal","o","p","c",1,"",0]',
    ]) {
      expect(PersonalNotificationTarget.decode(payload), isNull);
    }
  });

  test('Просмотр чата подтверждает только выбранные обращения и допускает повтор после сбоя', () async {
    fixture.api.add(personalNotice(1));
    final selected = Content(
      id: 'content-1',
      channelId: 'general',
      mentions: [CommunityMention(principalId: 'u_test')],
    );
    final ordinary = Content(
      id: 'content-2',
      channelId: 'general',
      text: '@u_test',
    );
    final deleted = selected.deepCopy()
      ..id = 'deleted'
      ..deleted = true;
    final foreign = selected.deepCopy()
      ..id = 'foreign'
      ..channelId = 'team';
    fixture.api.markError = const GrpcError.unavailable();
    await controller.markVisibleChat(fixture.chatController, [selected]);
    expect(fixture.api.chatIds, isEmpty);
    fixture.api.markError = null;
    await controller.markVisibleChat(fixture.chatController, [
      selected,
      ordinary,
      deleted,
      foreign,
    ]);
    expect(fixture.api.chatIds.single, ['content-1']);
    await controller.markVisibleChat(fixture.chatController, [selected]);
    expect(fixture.api.chatIds, hasLength(1));
  });
}
