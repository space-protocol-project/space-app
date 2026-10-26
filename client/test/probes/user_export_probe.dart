import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide View;
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart'
    show Channel, ChannelPermissions, View;
import 'package:space_client/ui/user_export.dart';
import 'package:space_client/ui/message_markdown.dart';

import '../support/user_export.dart';

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
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppPreferences().theme,
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: Column(
          children: [
            const MessageMarkdown(
              text: '**Безопасный Markdown**\n\n![Без загрузки](https://example.org/pixel.png)',
            ),
            Expanded(
              child: UserExportDialog(
                api: ProbeExportApi(),
                channels: [
                  Channel(
                    id: 'general',
                    title: 'Клуб Space',
                    views: [View(type: 'chat')],
                    permissions: ChannelPermissions(read: true, visible: true),
                  ),
                ],
                available: () => true,
                chooseDestination: () async =>
                    Platform.environment['SPACE_EXPORT_PROBE_PATH'],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}
