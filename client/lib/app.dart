import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:space_admin_ui/space_admin_ui.dart';

import 'src/chat_controller.dart';
import 'src/app_shutdown.dart';
import 'src/preferences.dart';
import 'l10n/app_localizations.dart';
import 'ui/shell.dart';
import 'ui/interface_scale.dart';
import 'ui/app_shutdown_gate.dart';

class SpaceApp extends StatefulWidget {
  const SpaceApp({super.key, this.controller, this.shutdown});
  final ChatController? controller;
  final AppShutdown? shutdown;
  @override
  State<SpaceApp> createState() => _SpaceAppState();
}

class _SpaceAppState extends State<SpaceApp> {
  final preferences = AppPreferences();
  late final Future<void> startupReady;
  @override
  void initState() {
    super.initState();
    startupReady = preferences.load();
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
            child: AppShutdownGate(
              shutdown: widget.shutdown,
              child: child ?? const SizedBox.shrink(),
            ),
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
            startupReady: startupReady,
            controller: widget.controller,
            shutdown: widget.shutdown,
          ),
        ),
      );
}
