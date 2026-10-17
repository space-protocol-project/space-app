import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/mls/replies.dart';

Map<String, dynamic> item(String grant, int id, {String text = 'Текст'}) => {
  'grant_id': grant,
  'author_id': 'Участник',
  'message': {
    'id': List.filled(16, id),
    'text': text,
    'files': [
      {'name': 'Фото.png'},
    ],
  },
};

void main() {
  test(
    'Архив сохраняет только корректную ссылку без полей подменённой цитаты',
    () {
      final reference = mlsReplyReference(item('grant', 1));
      expect(
        checkedMlsReply({
          'reply': {...reference, 'text': 'Подмена'},
        }),
        reference,
      );
      expect(
        () => checkedMlsReply({
          'reply': {
            'grant_id': 'grant',
            'message_id': [1],
          },
        }),
        throwsStateError,
      );
      expect(
        () => checkedMlsReply({'reply': reference, 'reaction': {}}),
        throwsStateError,
      );
      expect(
        () => checkedMlsReply({'reply': reference, 'manager': 'grant'}),
        throwsStateError,
      );
    },
  );
  test('Ссылка различает сообщения разных устройств с одинаковым ID', () {
    final first = item('a', 1), second = item('b', 1);
    final reference = mlsReplyReference(second);
    expect(findMlsReply([first, second], reference), same(second));
    expect(reference.keys, unorderedEquals(['grant_id', 'message_id']));
    expect(findMlsReply([first], reference), isNull);
    expect(findMlsReply([second], null), isNull);
  });

  test(
    'Предпросмотр берёт актуальную историю без сохранённой копии текста',
    () {
      final source = item('a', 1);
      final reference = mlsReplyReference(source);
      (source['message'] as Map)['text'] = 'Актуальный текст';
      final preview = mlsReplyContent(findMlsReply([source], reference))!;
      expect(preview.text, 'Актуальный текст');
      expect(preview.authorId, 'Участник');
      expect(preview.attachments.single.name, 'Фото.png');
      expect(mlsReplyContent(findMlsReply([], reference)), isNull);
    },
  );
}
