import 'package:fixnum/fixnum.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import '../../test/channels_test.dart' show CatalogSession, chat;

class GallerySession extends CatalogSession implements SpaceAdministration {
  GallerySession() {
    availableChannels = [
      chat('general')..title = 'Общий чат',
      chat('ideas')..title = 'Идеи и планы',
    ];
  }

  @override
  String get principalId => 'Алексей';
  @override
  String get spaceTitle => 'Круг друзей';
  @override
  bool get canManageSpace => true;
  @override
  bool get needsOwnerSetup => false;

  @override
  Future<List<Content>> messages() async => [
    for (final (index, entry) in const [
      ('Мария', 'Всем привет! Теперь у нас своё пространство для общения.'),
      ('Мария', 'Здесь можно делиться идеями и сохранять важное.'),
      ('Алексей', 'Отлично! Создал отдельный канал для наших планов.'),
      ('Илья', 'Давайте соберём там идеи для следующей встречи.'),
      ('Алексей', 'Договорились. Хорошие мысли добавим в избранное.'),
    ].indexed)
      Content(
        id: 'gallery-$index',
        channelId: selectedChannelId,
        authorId: entry.$1,
        text: entry.$2,
        sequence: Int64(index + 1),
        createdAtUnixMs: Int64(
          DateTime(2026, 10, 14, 18, 30 + index).millisecondsSinceEpoch,
        ),
      ),
  ];

  @override
  Future<Map<String, dynamic>> adminIdentity() async => {
    'origin': 'https://friends.example',
    'role': 'owner',
    'administrative': true,
    'token': '',
    'expires': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
    'principalId': principalId,
    'serverId': 'srv_gallery',
  };

  @override
  Future<Map<String, dynamic>> adminRequest(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async => {
    'initialized': true,
    'settings': {
      'title': spaceTitle,
      'chatTitle': 'Общий чат',
      'chatEnabled': true,
      'registrationPolicy': 'closed',
      'revision': '1',
    },
    'channels': availableChannels
        .map((channel) => channel.toProto3Json())
        .toList(),
    'members': [
      for (final (index, role) in ['owner', 'admin', 'member'].indexed)
        {
          'principalId': 'u_${'${index + 1}' * 64}',
          'role': role,
          'revision': '1',
        },
    ],
    'invites': [],
  };
}
