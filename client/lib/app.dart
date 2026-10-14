import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'src/chat_controller.dart';
import 'src/preferences.dart';
import 'l10n/app_localizations.dart';
import 'ui/shell.dart';
import 'ui/interface_scale.dart';

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
  Widget build(BuildContext context) =>
      BlocBuilder<AppPreferences, PreferencesState>(
        bloc: preferences,
        builder: (context, state) => MaterialApp(
          title: 'Space',
          builder: (context, child) => InterfaceScale(
            scale: state.uiScale,
            child: child ?? const SizedBox.shrink(),
          ),
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior(),
          theme: state.theme ?? preferences.theme,
          locale: state.locale,
          localizationsDelegates: [
            AdminLocalizations.delegate,
            ...AppLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: SpaceShell(
            preferences: preferences,
            controller: widget.controller,
          ),
        ),
      );
}
