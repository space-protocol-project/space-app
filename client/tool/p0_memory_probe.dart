// Только отдельный стенд CI с настоящими экранами и локальным runtime.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/chat_view.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/forum.dart';

import 'home_vault.dart';

final screen = ValueNotifier<Widget>(const SizedBox());
final failures = <String>[];

bool containsText(Element element, String text) {
  final widget = element.widget;
  if (widget is Text && (widget.data ?? '').contains(text)) return true;
  if (widget is RichText && widget.text.toPlainText().contains(text)) return true;
  var found = false;
  element.visitChildren((child) {
    if (!found) found = containsText(child, text);
  });
  return found;
}

Future<void> waitFor(bool Function() ready) async {
  final clock = Stopwatch()..start();
  while (!ready()) {
    if (failures.isNotEmpty) throw StateError(failures.first);
    if (clock.elapsed > const Duration(seconds: 60)) {
      throw StateError('Экран или управляющий сигнал не готов');
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

Future<void> phase(Directory work, String value) async {
  final temporary = File('${work.path}/phase.tmp');
  await temporary.writeAsString(value, flush: true);
  await temporary.rename('${work.path}/phase');
}

Future<void> show(Widget child, String text) async {
  screen.value = KeyedSubtree(key: UniqueKey(), child: child);
  await waitFor(() => containsText(WidgetsBinding.instance.rootElement!, text));
  await Future<void>.delayed(const Duration(seconds: 2));
}

Future<void> screens(ChatController chat, SpaceSession session) async {
  await show(ChatView(controller: chat, openConnection: () {}), 'baseline message');
  await show(ForumView(session: session, sectionId: 'baseline_forum',
      initialThread: 'topic-1'), 'baseline topic');
  await show(FeedView(session: session, active: true, sectionId: 'baseline_feed',
      initialPost: 'post-1'), 'baseline post');
}

Future<void> measure(Directory work, String origin) async {
  final vault = HomeVault();
  final discovery = await discover(origin);
  final session = await SpaceSession.connect(discovery, vault);
  ChatController? chat;
  try {
    for (final (id, view) in [('baseline_forum', 'forum'), ('baseline_feed', 'feed')]) {
      await session.adminRequest('/api/v1/channels', method: 'POST',
          body: {'channelId': id, 'title': id, 'viewType': view});
    }
    await File('${work.path}/ready.json').writeAsString(
        jsonEncode({'principal': session.principalId}), flush: true);
    await waitFor(() => File('${work.path}/seeded').existsSync());
    await session.refreshChannels();
    chat = ChatController(vault, openSession: (_, _) async => session)
      ..preview = discovery;
    await chat.connect();
    await phase(work, 'warmup');
    await screens(chat, session);
    await phase(work, 'sampling');
    for (var cycle = 0; cycle < 5; cycle++) {
      await screens(chat, session);
    }
    if (failures.isNotEmpty) throw StateError(failures.join('\n'));
    await phase(work, 'complete');
    await File('${work.path}/result.json').writeAsString(jsonEncode({
      'success': true, 'pid': pid, 'cycles': 5,
      'screens': ['ChatView', 'ForumView', 'FeedView'],
    }), flush: true);
  } finally {
    screen.value = const SizedBox();
    chat?.dispose();
    await session.close();
  }
}

Future<void> main() async {
  if (Platform.environment['SPACE_P0_MEMORY_CHECK'] != '1') exit(2);
  final origin = Platform.environment['SPACE_P0_ORIGIN'] ?? '';
  final uri = Uri.tryParse(origin);
  if (uri == null || uri.scheme != 'http' || !InternetAddress(uri.host).isLoopback) exit(2);
  final work = Directory(Platform.environment['SPACE_P0_WORK']!);
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    failures.add(details.exceptionAsString());
    FlutterError.presentError(details);
  };
  runApp(MaterialApp(
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(body: ValueListenableBuilder<Widget>(
      valueListenable: screen, builder: (_, child, _) => child)),
  ));
  await WidgetsBinding.instance.endOfFrame;
  try {
    await measure(work, origin);
    exit(0);
  } catch (error, stack) {
    await File('${work.path}/failure.txt').writeAsString('$error\n$stack');
    exit(1);
  }
}
