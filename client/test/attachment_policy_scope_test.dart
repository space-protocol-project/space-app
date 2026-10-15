import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/rpc_clients.dart';

import 'channels_test.dart';

class PolicySession extends CatalogSession
    implements AttachmentPolicy, AttachmentSession {
  PolicySession(this.attachmentsEnabled);
  @override
  bool attachmentsEnabled;
  final content = Content(
    id: 'file-message',
    channelId: 'general',
    text: 'Текст',
    attachments: [Asset(id: 'file', name: 'photo.png')],
  );
  @override
  Future<List<Content>> messages() async => [content];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'Политика вложений независима у серверов и обновляется без потери файлов',
    () async {
      Future<ChatController> open(PolicySession session, int port) async {
        final controller = ChatController(
          ChannelVault(),
          openSession: (_, _) async => session,
          positions: MemoryPositions(),
          historyStore: MemoryHistory(),
        );
        controller.preview = Discovery(
          localOrigin('http://127.0.0.1:$port'),
          'srv_test',
          List.filled(32, 1),
        );
        await controller.connect();
        await settle();
        addTearDown(() async {
          await controller.disconnect();
          controller.dispose();
        });
        return controller;
      }

      final first = PolicySession(false), second = PolicySession(true);
      final a = await open(first, 8081), b = await open(second, 8082);
      expect(a.attachmentSession, isNull);
      expect(a.messages.single.attachments, isEmpty);
      expect(b.attachmentSession, same(second));
      expect(b.messages.single.attachments.single.name, 'photo.png');
      first.attachmentsEnabled = true;
      first.change(first.availableChannels);
      await settle();
      expect(a.state.messages.single.attachments.single.name, 'photo.png');
      second.attachmentsEnabled = false;
      second.change(second.availableChannels);
      await settle();
      expect(b.state.messages.single.attachments, isEmpty);
      expect(a.attachmentSession, same(first));
      expect(second.content.attachments.single.name, 'photo.png');
    },
  );
}
