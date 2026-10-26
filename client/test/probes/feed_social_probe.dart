import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/feed.dart';

import '../support/feed_social.dart';

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
  runApp(const SocialProbe());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}

class SocialProbe extends StatefulWidget {
  const SocialProbe({super.key});
  @override
  State<SocialProbe> createState() => _SocialProbeState();
}

class _SocialProbeState extends State<SocialProbe> {
  final api = SocialFeed();
  @override
  void dispose() {
    api.submitted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppPreferences().theme,
    locale: const Locale('ru'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: api.submitted,
            builder: (_, value, _) => Text(value),
          ),
          Expanded(
            child: FeedArea(api: api, initialPost: 'post'),
          ),
        ],
      ),
    ),
  );
}
