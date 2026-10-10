import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'src/chat_controller.dart';
import 'src/preferences.dart';
import 'l10n/app_localizations.dart';
import 'ui/shell.dart';

class SpaceApp extends StatefulWidget {
  const SpaceApp({super.key, this.controller});
  final ChatController? controller;
  @override
  State<SpaceApp> createState() => _SpaceAppState();
}

class _SpaceAppState extends State<SpaceApp> {
  final preferences = AppPreferences();
  @override
  void initState() {
    super.initState();
    unawaited(preferences.load());
  }

  @override
  void dispose() {
    preferences.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: preferences,
    builder: (context, _) => MaterialApp(
      title: 'Space',
      debugShowCheckedModeBanner: false,
      theme: preferences.theme,
      locale: preferences.locale,
      localizationsDelegates: [
        AdminLocalizations.delegate,
        ...AppLocalizations.localizationsDelegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: SpaceShell(preferences: preferences, controller: widget.controller),
    ),
  );
}
