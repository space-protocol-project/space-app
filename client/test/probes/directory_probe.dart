import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/directory_archive.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_backup_cubit.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/directory_backup.dart';

import '../fixtures/directory.dart';

Future<void> main() async {
  late DirectoryBackupCubit cubit;
  enableFlutterDriverExtension(handler: (message) async {
    if (message == 'preview') {
      final file = await DirectoryArchive.seal(directoryDocument(), 'A secure backup password');
      await cubit.preview(file, 'A secure backup password');
      return cubit.state.message;
    }
    return cubit.state.message;
  });
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = (details) {
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error'); return true;
  };
  final preferences = AppPreferences();
  final service = DirectoryBackupService(DirectoryRepository(DirectoryStorage()), DirectoryVault(), preferences, () => {});
  cubit = DirectoryBackupCubit(service);
  runApp(MaterialApp(locale: const Locale('ru'),
    localizationsDelegates: [...AppLocalizations.localizationsDelegates, AdminLocalizations.delegate],
    supportedLocales: AppLocalizations.supportedLocales, theme: preferences.theme,
    home: Scaffold(body: SingleChildScrollView(child: DirectoryBackupPanel(service: service, controller: cubit)))));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}
