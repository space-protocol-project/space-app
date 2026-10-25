import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/ui/chat_view.dart';

import 'feed_test.dart' show app;

import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/chat_outbox.dart';
import 'package:space_client/src/community_mentions_api.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/queued_mutation.dart';
import 'package:space_client/src/queued_mutation_projection.dart';

import 'channels_test.dart'
    show ChannelSession, ChannelVault, MemoryPositions, MemoryHistory;
import 'chat_outbox_test.dart' show eventually;
import 'community_mentions_test.dart' show MentionApi;
import 'support/chat_outbox.dart';

class MentionChat extends ChannelSession
    implements ChatMentionWriter, CommunityMentionSource, MessageChanges {
  @override
  final communityMentions = MentionApi();
  final accepted = <String, Content>{};
  final keys = <String>[];
  bool loseAck = false;
  @override
  Future<Content> sendMentioned(
    String channel,
    String text,
    String key,
    List<String> attachments,
    String reply,
    List<CommunityMention> mentions,
  ) async {
    keys.add(key);
    final content = accepted.putIfAbsent(
      key,
      () => Content(
        id: 'message-${accepted.length + 1}',
        channelId: channel,
        text: text,
        authorId: principalId,
        sequence: Int64(accepted.length + 1),
        revision: Int64.ONE,
        replyToId: reply,
        mentions: mentions,
      ),
    );
    if (loseAck) {
      loseAck = false;
      throw const GrpcError.unavailable();
    }
    return content.deepCopy();
  }

  @override
  Future<Content> updateMentioned(
    Content message,
    String text,
    List<CommunityMention> mentions,
  ) async => message.deepCopy()
    ..text = text
    ..revision = message.revision + Int64.ONE
    ..mentions.clear()
    ..mentions.addAll(mentions);
  @override
  Future<Content> updateMessage(Content message, String text) =>
      updateMentioned(message, text, []);
  @override
  Future<Content> deleteMessage(Content message) async => message.deepCopy()
    ..deleted = true
    ..text = ''
    ..mentions.clear();
}

Future<ChatController> connect(
  MentionChat session,
  MemoryChatOutbox outbox,
) async {
  final controller = ChatController(
    ChannelVault(),
    outboxStore: outbox,
    fileStore: EmptyQueuedFiles(),
    historyStore: MemoryHistory(),
    positions: MemoryPositions(),
    openSession: (_, _) async => session,
    retryDelay: (_) => const Duration(hours: 1),
  );
  controller.preview = Discovery(
    localOrigin('http://127.0.0.1:8080'),
    'srv_test',
    List.filled(32, 1),
  );
  await controller.connect();
  return controller;
}

CommunityMention mention() => CommunityMention(
  principalId: 'target',
  displayName: 'Маша',
  start: 0,
  length: 5,
);

void main() {
  test('потерянное подтверждение сохраняет ID адресата в очереди и повторяет тот же ключ', () async {
    final session = MentionChat()..loseAck = true;
    final outbox = MemoryChatOutbox();
    final controller = await connect(session, outbox);
    addTearDown(controller.close);
    expect(
      await controller.send('@Маша привет', mentions: [mention()]),
      isTrue,
    );
    await eventually(
      () =>
          session.keys.isNotEmpty &&
          controller.sendStatus == MessageSendStatus.unconfirmed,
    );
    final pending = controller.state.pendingMessages.single;
    final restored = PendingMessage.fromJson(
      jsonDecode(jsonEncode(pending.toJson())) as Map<String, dynamic>,
    );
    expect(restored.mentions.single.principalId, 'target');
    await controller.retryPending(pending.key);
    await eventually(() => controller.state.pendingMessages.isEmpty);
    expect(session.keys, [pending.key, pending.key]);
    expect(session.accepted, hasLength(1));
    expect(
      controller.state.messages.single.mentions.single.principalId,
      'target',
    );
    expect(
      await controller.updateMessage(
        controller.state.messages.single,
        '@Маша ещё',
        mentions: [mention()],
      ),
      isTrue,
    );
    expect(
      controller.state.messages.single.mentions.single.principalId,
      'target',
    );
  });

  test('метаданные правки переживают сохранение и зависимые ревизии; удаление снимает упоминания', () {
    final message = Content(
      id: 'm',
      channelId: 'general',
      text: '@Маша',
      authorId: 'u_test',
      sequence: Int64.ONE,
      revision: Int64.ONE,
      mentions: [mention()],
    );
    final change = QueuedMutation.forMessage(
      message,
      MutationKind.edit,
      mentions: [mention()],
    );
    final saved = PendingMessage(
      key: 'key',
      channelId: 'general',
      text: '@Маша текст',
      createdAt: 1,
      mutation: change,
    );
    final restored = PendingMessage.fromJson(
      jsonDecode(jsonEncode(saved.toJson())) as Map<String, dynamic>,
    );
    expect(
      restored.mutation!.following(2).mentions.single.principalId,
      'target',
    );
    expect(
      restored.mutation!.dependingOn('previous').mentions.single.principalId,
      'target',
    );
    final projected = projectQueuedMutations(
      [message],
      [restored],
      'u_test',
    ).single;
    expect(projected.mentions.single.principalId, 'target');
    final deletion = PendingMessage(
      key: 'delete',
      channelId: 'general',
      text: '',
      createdAt: 2,
      mutation: QueuedMutation.forMessage(message, MutationKind.delete),
    );
    expect(
      projectQueuedMutations([projected], [deletion], 'u_test').single.mentions,
      isEmpty,
    );
  });

  testWidgets('чат выбирает участника через @ и отправляет его ID', (
    tester,
  ) async {
    final session = MentionChat();
    final outbox = MemoryChatOutbox();
    final controller = (await tester.runAsync(() => connect(session, outbox)))!;
    await tester.pumpWidget(
      app(ChatView(controller: controller, openConnection: () {})),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('chat-draft')), '@');
    await tester.pumpAndSettle();
    await tester.tap(find.text('two'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Отправить'));
    await tester.pump();
    await tester.runAsync(() => eventually(() => session.accepted.isNotEmpty));
    await tester.pumpAndSettle();
    expect(session.accepted.values.single.mentions.single.principalId, 'two');
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    await tester.runAsync(()=>controller.close());
  });
}
