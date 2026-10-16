import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/attachments.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/ui/attachment_gallery.dart';
import 'package:space_client/ui/attachment_widgets.dart';
import 'package:space_client/ui/message_bubble.dart';

import 'attachments_test.dart' show FilesSession;

class GallerySession extends FilesSession {
  final bytes = img.encodePng(img.Image(width: 32, height: 16));
  final requests = <String>[];
  bool broken = false;
  @override
  Future<DownloadChunkResponse> downloadChunk(
    DownloadChunkRequest request,
  ) async {
    requests.add(request.assetId);
    return DownloadChunkResponse(
      asset: imageAsset(request.assetId),
      data: broken ? Uint8List(bytes.length) : bytes,
      nextOffset: Int64(bytes.length),
    );
  }

  Asset imageAsset(String id) => Asset(
    id: id,
    name: '$id.png',
    mediaType: 'image/png',
    byteSize: Int64(bytes.length),
    sha256: sha256.convert(bytes).bytes,
  );
}

Future<void> settleImages(WidgetTester tester, int expected) async {
  for (var i = 0; i < 100; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 10)),
    );
    await tester.pump();
    final images = tester
        .widgetList<RawImage>(find.byType(RawImage))
        .where((image) => image.image != null);
    if (images.length >= expected) return;
  }
  fail('Изображения не загрузились');
}

Widget screen(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  test('Поддерживаемые растровые изображения и безопасные исключения', () {
    expect(isGalleryImage('photo.JPG'), isTrue);
    expect(isGalleryImage('no-extension', 'image/webp'), isTrue);
    expect(isGalleryImage('document.pdf'), isFalse);
    expect(isGalleryImage('vector.svg', 'image/svg+xml'), isFalse);
  });

  for (final width in [390.0, 1100.0]) {
    testWidgets(
      'Галерея из пяти изображений внутри бабла и обычный файл: $width',
      (tester) async {
        tester.view.physicalSize = Size(width, 1100);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final session = GallerySession();
        await tester.pumpWidget(
          screen(
            MessageBubble(
              text: 'Фотографии',
              author: 'Автор',
              mine: false,
              attachments: MessageAttachments(
                assets: [
                  for (var i = 0; i < 5; i++) session.imageAsset('image-$i'),
                  Asset(id: 'pdf', name: 'document.pdf'),
                ],
                session: session,
              ),
            ),
          ),
        );
        await settleImages(tester, 5);
        expect(find.byType(AttachmentGallery), findsOneWidget);
        expect(find.byType(AttachmentCard), findsOneWidget);
        expect(session.requests, isNot(contains('pdf')));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byType(RawImage).at(1));
        await tester.pump(const Duration(milliseconds: 300));
        await settleImages(tester, 6);
        expect(find.text('2 / 5'), findsOneWidget);
        await tester.tap(find.byIcon(Icons.chevron_right));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('3 / 5'), findsOneWidget);
        await tester.drag(find.byType(PageView), Offset(-width * .75, 0));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('4 / 5'), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byType(PageView), findsNothing);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('Подмена файла отклоняется; повтор загружает проверенные байты', (
    tester,
  ) async {
    final session = GallerySession()..broken = true;
    await tester.pumpWidget(
      screen(
        MessageAttachments(
          assets: [session.imageAsset('image')],
          session: session,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(
      tester
          .widgetList<RawImage>(find.byType(RawImage))
          .where((image) => image.image != null),
      isEmpty,
    );
    session.broken = false;
    await tester.tap(find.byIcon(Icons.refresh));
    await settleImages(tester, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  test('Отменённый предпросмотр не запрашивает файл', () async {
    final session = GallerySession();
    await expectLater(
      downloadAttachment(
        session,
        session.imageAsset('cancel'),
        cancelled: () => true,
      ),
      throwsStateError,
    );
    expect(session.requests, isEmpty);
  });
}
