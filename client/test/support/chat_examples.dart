import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';

import '../attachments_test.dart' show FilesSession;
import '../shell_test.dart' show TestController;

class ExampleFiles extends FilesSession {
  final pictures = <String, Uint8List>{};
  final assets = <String, Asset>{};

  Future<void> prepare() async {
    for (var i = 0; i < 3; i++) {
      final bytes = await landscape(i);
      final id = 'photo-$i';
      pictures[id] = bytes;
      assets[id] = Asset(
        id: id,
        channelId: 'general',
        authorId: 'Мария',
        name: ['Горное озеро.png', 'Вечер в горах.png', 'Тихая бухта.png'][i],
        mediaType: 'image/png',
        byteSize: Int64(bytes.length),
        sha256: sha256.convert(bytes).bytes,
      );
    }
  }

  @override
  Future<DownloadChunkResponse> downloadChunk(
    DownloadChunkRequest request,
  ) async {
    final bytes = pictures[request.assetId]!;
    return DownloadChunkResponse(
      asset: assets[request.assetId],
      data: bytes.sublist(request.offset.toInt()),
      nextOffset: Int64(bytes.length),
    );
  }
}

Future<Uint8List> landscape(int index) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final palettes = [
    [const Color(0xffa6c0b0), const Color(0xff4b6d65), const Color(0xff799f99)],
    [const Color(0xffdfb18a), const Color(0xff685d72), const Color(0xffa2828d)],
    [const Color(0xffb7c1bc), const Color(0xff616f62), const Color(0xff8caeaa)],
  ];
  final colors = palettes[index];
  canvas.drawRect(
    const Rect.fromLTWH(0, 0, 600, 400),
    Paint()..color = colors[0],
  );
  canvas.drawCircle(
    const Offset(460, 90),
    36,
    Paint()..color = const Color(0xfff9e5b3),
  );
  final mountains = Path()
    ..moveTo(0, 245)
    ..lineTo(140, 95 + index * 20)
    ..lineTo(270, 240)
    ..lineTo(385, 135)
    ..lineTo(600, 270)
    ..lineTo(600, 400)
    ..lineTo(0, 400)
    ..close();
  canvas.drawPath(mountains, Paint()..color = colors[1]);
  canvas.drawRect(
    const Rect.fromLTWH(0, 270, 600, 130),
    Paint()..color = colors[2],
  );
  final shore = Path()
    ..moveTo(0, 290)
    ..quadraticBezierTo(180, 320, 250, 400)
    ..lineTo(0, 400)
    ..close();
  canvas.drawPath(shore, Paint()..color = colors[1]);
  final picture = recorder.endRecording();
  final image = await picture.toImage(600, 400);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return data!.buffer.asUint8List();
}

class ExampleController extends TestController {
  ExampleController(this.example, this.files);
  final String example;
  final ExampleFiles files;
  @override
  String get principalId => 'Алексей';
  @override
  String get spaceTitle => 'Наше пространство';
  @override
  String get chatTitle => 'Общий чат';
  @override
  bool get canReact => true;
  @override
  AttachmentSession get attachmentSession => files;
  @override
  bool isFavorite(Content message) =>
      example == 'favorites' && message.id != '4';
  @override
  List<Content> get messages => switch (example) {
    'reactions' => reactionMessages(),
    'files' => fileMessages(),
    'gallery' => galleryMessages(),
    'markdown' => markdownMessages(),
    _ => favoriteMessages(),
  };

  Content message(
    int id,
    String author,
    String text, {
    List<Asset> assets = const [],
    List<Reaction> reactions = const [],
  }) => Content(
    id: '$id',
    channelId: 'general',
    authorId: author,
    text: text,
    sequence: Int64(id),
    revision: Int64(1),
    createdAtUnixMs: Int64(
      DateTime(2026, 10, 17, 10, 30 + id).millisecondsSinceEpoch,
    ),
    attachments: assets,
    reactions: reactions,
  );

  List<Content> reactionMessages() => [
    message(
      1,
      'Мария',
      'Есть идея: в субботу выбраться за город. Кто с нами? 🌿',
      reactions: [
        Reaction(emoji: '👍', principalIds: ['Алексей', 'Илья', 'Соня']),
        Reaction(emoji: '❤️', principalIds: ['Соня', 'Мария']),
        Reaction(emoji: '🔥', principalIds: ['Алексей', 'Илья']),
      ],
    ),
    message(
      2,
      'Алексей',
      'Я за! Возьму термос и настолки ☕ 🎲',
      reactions: [
        Reaction(emoji: '🎉', principalIds: ['Мария', 'Соня']),
        Reaction(emoji: '👍', principalIds: ['Илья']),
      ],
    ),
    message(3, 'Илья', 'Договорились. Встречаемся в 10:00 🚀'),
  ];

  List<Content> fileMessages() => [
    message(
      1,
      'Мария',
      'Собрала всё для встречи в одном сообщении. Сохраняйте 👇',
      assets: [
        Asset(id: 'pdf', name: 'План встречи.pdf', byteSize: Int64(248 * 1024)),
        Asset(
          id: 'zip',
          name: 'Материалы для команды.zip',
          byteSize: Int64(2516582),
        ),
        Asset(id: 'txt', name: 'Полезные ссылки.txt', byteSize: Int64(1540)),
      ],
    ),
    message(2, 'Алексей', 'Спасибо! Всё на месте, скачал 👍'),
  ];

  List<Content> galleryMessages() => [
    message(
      1,
      'Мария',
      'Вот несколько кадров с нашей прогулки 📷',
      assets: files.assets.values.toList(),
      reactions: [
        Reaction(emoji: '❤️', principalIds: ['Алексей', 'Илья', 'Соня']),
      ],
    ),
    message(2, 'Алексей', 'Как красиво! Первое фото — моё любимое 🌄'),
  ];

  List<Content> markdownMessages() => [
    message(
      1,
      'Илья',
      '**План на выходные**\n\nСначала *небольшая прогулка*, потом встреча всей командой.\n\n- Встречаемся в **10:00**\n- Берём воду и удобную обувь\n- Делимся фотографиями здесь\n\n> Главное — хорошая компания.\n\nПодробности — в [нашем проекте](https://space-protocol-project.github.io/space-protocol/).',
    ),
    message(
      2,
      'Алексей',
      'Для запуска сервера:\n\n```bash\nspace-server start\n```\n\nА короткие команды удобно писать так: `space-server doctor`.',
    ),
  ];

  List<Content> favoriteMessages() => [
    message(
      1,
      'Мария',
      'Важное: встречаемся в субботу в 10:00 у главного входа.',
    ),
    message(
      2,
      'Илья',
      'Код от калитки — 2408. Если потеряетесь, напишите сюда.',
    ),
    message(
      3,
      'Алексей',
      'Список вещей: термос, вода, плед и настолки. Всё возьму с собой.',
    ),
    message(4, 'Соня', 'Отлично, до встречи! 🌿'),
  ];
}
