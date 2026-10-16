import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/src/chat_history.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import 'chat_history_test.dart' show HistoryKeys;
import 'stream_test.dart' as fixture;

class ReactingSession extends fixture.Session implements MessageReactions {
  Content content = Content(
    id: 'message-1',
    channelId: 'general',
    text: 'Сообщение',
    authorId: 'author',
    revision: Int64.ONE,
    sequence: Int64.ONE,
  );
  @override
  Future<List<Content>> messages() async => [content];
  @override
  Future<Content> setReaction(
    Content message,
    String emoji,
    bool active,
  ) async {
    content = content.deepCopy()..revision += Int64.ONE;
    content.reactions.clear();
    if (active) {
      content.reactions.add(
        Reaction(emoji: emoji, principalIds: [principalId]),
      );
    }
    return content;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Ответ и событие другого устройства обновляют реакцию без дубля сообщения',
    () async {
      final session = ReactingSession();
      final controller = await fixture.connect(session);
      addTearDown(controller.dispose);
      expect(
        await controller.setReaction(
          controller.state.messages.single,
          '👍',
          true,
        ),
        true,
      );
      expect(controller.state.messages.single.reactions.single.principalIds, [
        'u_test',
      ]);
      final removed = session.content.deepCopy()..revision += Int64.ONE;
      removed.reactions.clear();
      session.streams.single.add(
        SubscribeResponse(
          cursor: 'event-2',
          event: Event(
            cursor: 'event-2',
            type: 'content.updated',
            content: removed,
          ),
        ),
      );
      await fixture.settle();
      expect(controller.state.messages, hasLength(1));
      expect(controller.state.messages.single.reactions, isEmpty);
      session.streams.single.add(
        SubscribeResponse(
          cursor: 'event-3',
          event: Event(
            cursor: 'event-3',
            type: 'content.updated',
            content: session.content,
          ),
        ),
      );
      await fixture.settle();
      expect(controller.state.messages.single.reactions, isEmpty);
    },
  );

  test(
    'Реакции восстанавливаются из зашифрованной локальной истории',
    () async {
      SharedPreferences.setMockInitialValues({});
      final keys = HistoryKeys();
      final now = DateTime.now();
      final history =
          ChatHistory(
              serverId: 'server',
              principalId: 'user',
              grantId: 'device',
            )
            ..channels = [
              Channel(
                id: 'general',
                permissions: ChannelPermissions(read: true),
              ),
            ];
      history.merge([
        Content(
          id: '1',
          channelId: 'general',
          text: 'Текст',
          revision: Int64(2),
          reactions: [
            Reaction(emoji: '❤️', principalIds: ['user', 'other']),
          ],
        ),
      ], now);
      await LocalChatHistory(storage: keys)
          .write('https://reactions.test', history);
      final restored = await LocalChatHistory(storage: keys)
          .read('https://reactions.test');
      expect(
        restored!.messages('general', now).single.reactions.single.principalIds,
        ['user', 'other'],
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys().map(prefs.get).join(), isNot(contains('❤️')));
    },
  );
}
