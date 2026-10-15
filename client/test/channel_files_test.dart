import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/rpc_clients.dart';
import 'package:space_client/ui/channel_files.dart';

import 'attachments_test.dart';

class ChannelSession extends FilesSession {
  final requests = <ListChannelAssetsRequest>[];
  final replies = <Completer<ListChannelAssetsResponse>>[];
  @override
  Future<ListChannelAssetsResponse> listChannelAssets(
    ListChannelAssetsRequest request,
  ) {
    requests.add(request);
    final reply = Completer<ListChannelAssetsResponse>();
    replies.add(reply);
    return reply.future;
  }
}

void main() {
  test('Фильтр сбрасывает страницы и игнорирует запоздалый ответ', () async {
    final session = ChannelSession();
    final files = ChannelFilesController(session, 'chat');
    addTearDown(files.close);
    final first = files.load();
    final filtered = files.selectAuthor('alice');
    session.replies[1].complete(
      ListChannelAssetsResponse(
        assets: [Asset(id: 'a')],
        nextCursor: 'a',
        authors: {'alice': 'Алиса'}.entries,
      ),
    );
    await filtered;
    session.replies[0].complete(
      ListChannelAssetsResponse(assets: [Asset(id: 'wrong')]),
    );
    await first;
    expect(files.state.files.single.id, 'a');
    final next = files.load();
    expect(session.requests.last.after, 'a');
    expect(session.requests.last.authorId, 'alice');
    expect(session.requests.last.channelId, 'chat');
    session.replies.last.complete(
      ListChannelAssetsResponse(
        assets: [Asset(id: 'b')],
        authors: {'alice': 'Алиса'}.entries,
      ),
    );
    await next;
    expect(files.state.files.map((a) => a.id), ['a', 'b']);
    expect(files.state.more, false);
  });

  testWidgets('Панель растёт до границы, затем прокручивается', (tester) async {
    Future<double> height(int count) async {
      final session = ChannelSession();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topRight,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 360,
                  maxWidth: 280,
                ),
                child: ChannelFilesPanel(
                  key: ObjectKey(session),
                  session: session,
                  channel: 'chat',
                ),
              ),
            ),
          ),
        ),
      );
      session.replies.single.complete(
        ListChannelAssetsResponse(
          assets: List.generate(
            count,
            (i) => Asset(id: '$i', authorId: 'alice', name: 'file-$i.txt'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      return tester.getSize(find.byType(ChannelFilesPanel)).height;
    }

    final empty = await height(0);
    final single = await height(1);
    final many = await height(20);
    expect(empty, lessThan(single));
    expect(single, lessThan(many));
    expect(many, 360);
    final list = find.descendant(
      of: find.byType(ChannelFilesPanel),
      matching: find.byType(ListView),
    );
    await tester.drag(list, const Offset(0, -250));
    await tester.pumpAndSettle();
    final scrollable = tester.state<ScrollableState>(
      find.descendant(of: list, matching: find.byType(Scrollable)).first,
    );
    expect(scrollable.position.pixels, greaterThan(0));
  });

  for (final width in [280.0, 480.0]) {
    testWidgets('Панель вложений и фильтр на ширине $width', (tester) async {
      final session = ChannelSession();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SizedBox(
              width: width,
              child: ChannelFilesPanel(session: session, channel: 'chat'),
            ),
          ),
        ),
      );
      session.replies.single.complete(
        ListChannelAssetsResponse(
          assets: [Asset(id: 'file', authorId: 'alice', name: 'photo.jpg')],
          authors: {'alice': 'Алиса'}.entries,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('photo.jpg'), findsOneWidget);
      expect(find.text('Вложения чата'), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Алиса').last);
      await tester.pump();
      expect(session.requests.last.authorId, 'alice');
      session.replies.last.complete(
        ListChannelAssetsResponse(authors: {'alice': 'Алиса'}.entries),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
