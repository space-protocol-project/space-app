import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/space_search.dart';
import '../support/space_search.dart';

void main() {
  enableFlutterDriverExtension();
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = (details) {
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error,stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error'); return true;
  };
  runApp(const SearchProbe());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1),() => debugPrint('COMMUNITY_UI_READY'));
  });
}

class SearchProbe extends StatefulWidget {
  const SearchProbe({super.key});
  @override State<SearchProbe> createState() => _SearchProbeState();
}
class _SearchProbeState extends State<SearchProbe> {
  final api = FakeSpaceSearch();
  String selected = '';
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, theme: AppPreferences().theme,
    locale: const Locale('ru'), supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(builder:(context) => Scaffold(body: Column(children:[
      TextButton(key: const ValueKey('open-space-search'), child: const Text('Поиск'),
        onPressed: () async {
          final hit = await showSpaceSearch(context,api:api,channels:searchChannels,
            changes:const Stream<Object?>.empty(),available:() => mounted);
          if (!mounted || hit == null) return;
          setState(() => selected='${hit.channelId}:${hit.parentId}:${hit.sequence}');
        }),
      Text(selected),
    ]))));
}
