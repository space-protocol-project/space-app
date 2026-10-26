import 'dart:async';
import 'dart:ui';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/community_favorite_list.dart';
import 'package:space_client/ui/community_favorites.dart';

import '../test/support/community_favorites.dart';

void main() {
  enableFlutterDriverExtension();
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = (details) {
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error');
    return true;
  };
  runApp(const FavoriteProbe());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}

class FavoriteProbe extends StatefulWidget {
  const FavoriteProbe({super.key});
  @override
  State<FavoriteProbe> createState() => _FavoriteProbeState();
}

class _FavoriteProbeState extends State<FavoriteProbe> {
  final api = FakeCommunityFavorites();
  final content = favoriteRef('topic');
  @override
  void initState() {
    super.initState();
    api.value(content)
      ..saved = true
      ..revision = Int64.ONE;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppPreferences().theme,
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(builder: _screen),
  );

  Widget _screen(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Избранное — тестовые данные'),
      actions: [
        IconButton(
          key: const ValueKey('open-favorites'),
          tooltip: 'Избранное',
          icon: const Icon(Icons.bookmarks_outlined),
          onPressed: () => showCommunityFavorites(
            context,
            api: api,
            channel: 'forum',
            changes: const Stream<Object?>.empty(),
            available: () => context.mounted,
          ),
        ),
      ],
    ),
    body: CommunityFavoriteScope(
      api: api,
      channel: 'forum',
      contents: [content],
      active: true,
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Проверка личной закладки'),
                const SizedBox(height: 12),
                CommunityFavoriteButton(content: content),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
