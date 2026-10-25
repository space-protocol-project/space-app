import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/community_overview.dart';
import 'package:space_client/src/dashboard_controller.dart';
import 'package:space_client/src/generated/space/v1/community_overview.pb.dart';
import 'package:space_client/src/generated/space/v1/community_search.pb.dart';
import 'package:space_client/src/generated/space/v1/feed.pb.dart';
import 'package:space_client/src/generated/space/v1/forum.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';
import 'package:space_client/src/server_workspaces.dart';
import 'package:space_client/ui/dashboard_highlights.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/forum.dart';
import 'package:space_client/ui/shell.dart';

import 'channels_test.dart' show ChannelVault, MemoryHistory, MemoryPositions;
import 'support/chat_outbox.dart' show MemoryChatOutbox;
import 'feed_test.dart' show FakeFeed;
import 'forum_test.dart' show FakeForum;

const origin = 'http://127.0.0.1:8080';

Channel section(String id, String kind) => Channel(
  id: id,
  title: id,
  views: [View(type: kind)],
  permissions: ChannelPermissions(visible: true, read: true),
);

CommunityOverviewEntry entry(String id, String title, {int replies = 0}) =>
    CommunityOverviewEntry(
      content: CommunitySearchResult(
        id: id,
        parentId: id,
        title: title,
        snippet: title,
        kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FORUM_THREAD,
        createdAtUnix: Int64(20),
      ),
      unreadCount: Int64.ONE,
      readStateSupported: true,
      unreadRepliesToYou: Int64(replies),
      firstUnreadReplySequence: Int64(70),
    );

class OverviewApi implements CommunityOverviewApi {
  @override
  bool supported = true;
  @override
  List<Channel> sections = [section('forum', 'forum'), section('feed', 'feed')];
  final mentions = <CommunityOverviewEntry>[];
  final feedReplies = <CommunityOverviewEntry>[];
  final requests = <String>[];
  final failures = <String, Object>{};
  final waiting = <String, Completer<GetCommunityOverviewResponse>>{};
  @override
  Future<void> refresh() async {}
  @override
  Future<GetCommunityOverviewResponse> overview(String channel) async {
    requests.add(channel);
    if (failures[channel] case final error?) throw error;
    if (waiting[channel] case final pending?) return pending.future;
    if (channel == 'feed') {
      return GetCommunityOverviewResponse(
        recent: [entry('post', 'Новая публикация')..readStateSupported = false],
        mentions: mentions,
        repliesToYou: feedReplies,
      );
    }
    return GetCommunityOverviewResponse(
      recent: [entry('topic', 'Новая тема')],
      repliesToYou: [entry('mine', 'Моя тема', replies: 2)],
      canModerate: true,
      pendingReports: Int64(3),
    );
  }
}

class DashboardChat extends ChatController {
  DashboardChat(this.api)
    : super(
        ChannelVault(),
        positions: MemoryPositions(),
        historyStore: MemoryHistory(),
        outboxStore: MemoryChatOutbox(),
      ) {
    connected = true;
  }
  final OverviewApi api;
  final catalog = [section('chat', 'chat')];
  int unread = 0;
  @override
  CommunityOverviewApi get communityOverview => api;
  @override
  String get spaceTitle => 'Клуб';
  @override
  List<Channel> get channels => accessRemoved ? [] : catalog;
  @override
  int unreadCount(String id) => unread;
}

Widget localized(Widget child) => MaterialApp(
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

Future<void> flush() async {
  await Future<void>.delayed(const Duration(milliseconds: 20));
}

Future<
  ({DashboardChat chat, ServerWorkspaces workspaces, ServerPresence presence})
>
widgetFixture(WidgetTester tester, OverviewApi api, {int unread = 0}) async {
  return (await tester.runAsync(() async {
    final chat = DashboardChat(api)..unread = unread;
    final workspaces = ServerWorkspaces(vault: ChannelVault());
    final presence = ServerPresence(probe: (_) async => true);
    await workspaces.adopt(origin, chat, owned: false);
    return (chat: chat, workspaces: workspaces, presence: presence);
  }))!;
}

void main() {
  test(
    'частичный отказ не скрывает успешный раздел; отзыв удаляет старую выдачу',
    () async {
      final api = OverviewApi()
        ..failures['feed'] = const GrpcError.permissionDenied();
      final chat = DashboardChat(api);
      final workspaces = ServerWorkspaces(vault: ChannelVault());
      final presence = ServerPresence(probe: (_) async => true);
      await workspaces.adopt(origin, chat, owned: false);
      final controller = DashboardController(workspaces, presence)
        ..setActive(true);
      await flush();
      expect(controller.state.communities.single.channel.id, 'forum');
      expect(controller.state.failed, isTrue);
      api.failures['forum'] = const GrpcError.permissionDenied();
      await controller.refresh();
      expect(controller.state.communities, isEmpty);
      await controller.close();
      await workspaces.close();
      await presence.close();
      chat.dispose();
    },
  );

  test(
    'смена прав, отключение и поздние ответы не возвращают личные данные',
    () async {
      final api = OverviewApi()..sections = [section('forum', 'forum')];
      final pending = Completer<GetCommunityOverviewResponse>();
      api.waiting['forum'] = pending;
      final chat = DashboardChat(api);
      final workspaces = ServerWorkspaces(vault: ChannelVault());
      final presence = ServerPresence(probe: (_) async => true);
      await workspaces.adopt(origin, chat, owned: false);
      final controller = DashboardController(workspaces, presence)
        ..setActive(true);
      await flush();
      api.sections = [];
      workspaces.publishState();
      await flush();
      pending.complete(
        GetCommunityOverviewResponse(recent: [entry('secret', 'Секрет')]),
      );
      await flush();
      expect(controller.state.communities, isEmpty);
      final second = Completer<GetCommunityOverviewResponse>();
      api.sections = [section('forum', 'forum')];
      api.waiting['forum'] = second;
      final request = controller.refresh();
      await flush();
      api.sections.single.permissions.read = false;
      second.complete(
        GetCommunityOverviewResponse(recent: [entry('private', 'Личное')]),
      );
      await request;
      expect(controller.state.communities, isEmpty);
      controller.setActive(false);
      expect(controller.state.communities, isEmpty);
      await controller.close();
      await workspaces.close();
      await presence.close();
      chat.dispose();
    },
  );

  test('старый сервер не получает неподдерживаемые RPC', () async {
    final api = OverviewApi()..supported = false;
    final chat = DashboardChat(api);
    final workspaces = ServerWorkspaces(vault: ChannelVault());
    final presence = ServerPresence(probe: (_) async => true);
    await workspaces.adopt(origin, chat, owned: false);
    final controller = DashboardController(workspaces, presence)
      ..setActive(true);
    await flush();
    expect(api.requests, isEmpty);
    expect(controller.state.unsupported, isTrue);
    api.supported = true;
    api.sections = [
      section('denied', 'forum')..permissions.read = false,
      section('private', 'forum')..mlsGroupId = [1],
    ];
    await controller.refresh();
    expect(api.requests, isEmpty);
    await controller.close();
    await workspaces.close();
    await presence.close();
    chat.dispose();
  });

  testWidgets('упоминание и ответ ленты переходят к точному комментарию', (
    tester,
  ) async {
    final api = OverviewApi();
    api.mentions.add(
      CommunityOverviewEntry(
        content: CommunitySearchResult(
          id: 'mention-comment',
          parentId: 'post',
          snippet: 'Точный комментарий',
          sequence: Int64(70),
          kind: CommunitySearchKind.COMMUNITY_SEARCH_KIND_FEED_COMMENT,
        ),
      ),
    );
    api.feedReplies.add(
      entry('post', '', replies: 1)..content.snippet = 'Моя публикация',
    );
    final (chat: chat, workspaces: workspaces, presence: presence) =
        await widgetFixture(tester, api);
    final destinations = <DashboardCommunityTarget>[];
    await tester.pumpWidget(
      localized(
        DashboardHighlights(
          workspaces: workspaces,
          presence: presence,
          openSpace: (_) {},
          openChannel: (_, _) {},
          openCommunity: destinations.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mention = find.byKey(
      const ValueKey('dashboard-mention-$origin-mention-comment'),
    );
    await tester.ensureVisible(mention);
    await tester.tap(mention);
    expect(destinations.last.id, 'post');
    expect(destinations.last.replySequence, 70);
    expect(destinations.last.destination, DashboardDestination.feed);
    final reply = find.byKey(const ValueKey('dashboard-reply-$origin-post'));
    await tester.ensureVisible(reply);
    await tester.tap(reply);
    expect(destinations.last.replySequence, 70);
    await tester.pumpWidget(const SizedBox());
    workspaces.dispose();
    presence.dispose();
    chat.dispose();
  });

  testWidgets('переход из сводки ленты пропускает ранние комментарии', (
    tester,
  ) async {
    final api = FakeFeed();
    api.comments.add(
      FeedComment(
        id: 'late',
        postId: 'post',
        text: 'Адресный комментарий',
        sequence: Int64(70),
      ),
    );
    await tester.pumpWidget(
      localized(
        FeedArea(api: api, initialPost: 'post', initialReplySequence: 70),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Адресный комментарий'), findsOneWidget);
    expect(find.text('Первый комментарий'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final width in [360.0, 1280.0]) {
    testWidgets('блоки и переходы на ширине $width', (tester) async {
      tester.view.physicalSize = Size(width, 2200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = OverviewApi();
      final (chat: chat, workspaces: workspaces, presence: presence) =
          await widgetFixture(tester, api, unread: 5);
      final destinations = <DashboardCommunityTarget>[];
      String? openedChat;
      await tester.pumpWidget(
        localized(
          DashboardHighlights(
            workspaces: workspaces,
            presence: presence,
            openSpace: (_) {},
            openChannel: (_, id) => openedChat = id,
            openCommunity: destinations.add,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Требует внимания'), findsOneWidget);
      expect(find.text('Новое в сообществах'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('dashboard-reply-$origin-mine')),
      );
      expect(destinations.last.id, 'mine');
      expect(destinations.last.replySequence, 70);
      await tester.tap(
        find.byKey(const ValueKey('dashboard-reports-$origin-forum')),
      );
      expect(destinations.last.destination, DashboardDestination.forumReports);
      await tester.ensureVisible(
        find.byKey(const ValueKey('dashboard-community-$origin-post')),
      );
      await tester.tap(
        find.byKey(const ValueKey('dashboard-community-$origin-post')),
      );
      expect(destinations.last.destination, DashboardDestination.feed);
      await tester.ensureVisible(
        find.byKey(const ValueKey('dashboard-unread-$origin-chat')),
      );
      await tester.tap(
        find.byKey(const ValueKey('dashboard-unread-$origin-chat')),
      );
      expect(openedChat, 'chat');
      await tester.runAsync(() async {
        chat.connected = false;
        workspaces.publishState();
        await flush();
      });
      await tester.pumpAndSettle();
      expect(
        find.text('Данные недоступных пространств появятся после подключения.'),
        findsOneWidget,
      );
      expect(find.text('Пока нет доступных тем и публикаций.'), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      workspaces.dispose();
      presence.dispose();
      chat.dispose();
    });
  }

  testWidgets('карточка темы передаёт адрес в оболочку', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final (chat: chat, workspaces: workspaces, presence: presence) =
        await widgetFixture(tester, OverviewApi());
    final preferences = AppPreferences();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SpaceShell(
          preferences: preferences,
          workspaces: workspaces,
          presence: presence,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final previousRequests = chat.api.requests.length;
    await tester.tap(find.text('Обновить сводку'));
    await tester.runAsync(flush);
    await tester.pumpAndSettle();
    expect(chat.api.requests.length, greaterThan(previousRequests));
    final target = find.byKey(
      const ValueKey('dashboard-community-$origin-topic'),
    );
    await Scrollable.ensureVisible(tester.element(target), alignment: .5);
    await tester.pumpAndSettle();
    await tester.tap(target);
    for (
      var attempt = 0;
      attempt < 5 && find.byType(ForumView).evaluate().isEmpty;
      attempt++
    ) {
      await tester.runAsync(flush);
      await tester.pumpAndSettle();
    }
    final dynamic shell = tester.state(find.byType(SpaceShell));
    expect(shell.selected, Section.forum);
    final view = tester.widget<ForumView>(find.byType(ForumView));
    expect(view.sectionId, 'forum');
    expect(view.initialThread, 'topic');
    await tester.pumpWidget(const SizedBox());
    workspaces.dispose();
    presence.dispose();
    preferences.dispose();
    chat.dispose();
  });

  testWidgets('лента открывает переданную публикацию выбранного раздела', (
    tester,
  ) async {
    final api = FakeFeed();
    api.entries.add(
      FeedPost(
        id: 'target',
        channelId: 'second',
        text: 'Нужная публикация',
        sequence: Int64(2),
      ),
    );
    await tester.pumpWidget(
      localized(FeedArea(api: api, sectionId: 'second', initialPost: 'target')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Нужная публикация'), findsOneWidget);
    expect(find.text('Первая запись'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('форум открывает переданный ответ', (tester) async {
    final api = FakeForum();
    api.topics.add(
      ForumThread(id: 'topic', channelId: 'forum', title: 'Нужная тема'),
    );
    api.replies.addAll([
      ForumReply(
        id: 'old',
        threadId: 'topic',
        text: 'Старый',
        sequence: Int64.ONE,
      ),
      ForumReply(
        id: 'target',
        threadId: 'topic',
        text: 'Новый ответ',
        sequence: Int64(70),
      ),
    ]);
    await tester.pumpWidget(
      localized(
        ForumArea(
          api: api,
          sectionId: 'forum',
          initialThread: 'topic',
          initialReplySequence: 70,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Новый ответ'), findsOneWidget);
    expect(find.text('Старый'), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
