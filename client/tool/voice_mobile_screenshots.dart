// Съёмка настоящих Flutter-виджетов на Android с демонстрационными участниками.
// Использовать только отдельный applicationId SPACE_TEST_APP, не основной профиль.
import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/shell.dart';

import '../test/voice_room_screenshots_test.dart'
    show ScreenshotController, ScreenshotVoice;

final _boundary = GlobalKey();

Future<void> _save(String name) async {
  await Future<void>.delayed(const Duration(milliseconds: 800));
  await WidgetsBinding.instance.endOfFrame;
  final context = _boundary.currentContext;
  if (context == null || !context.mounted) return;
  final render = context.findRenderObject()! as RenderRepaintBoundary;
  final image = await render.toImage(
    pixelRatio: View.of(context).devicePixelRatio,
  );
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File('${Directory.systemTemp.path}/$name.png');
  await file.writeAsBytes(bytes!.buffer.asUint8List(), flush: true);
  debugPrint(
    'MOBILE_VOICE_CAPTURE ${file.path} ${image.width}x${image.height}',
  );
  image.dispose();
}

Future<void> _capture() async {
  await Future<void>.delayed(const Duration(milliseconds: 800));
  State? shell;
  void find(Element node) {
    if (node.widget is SpaceShell && node is StatefulElement) {
      shell = node.state;
    }
    node.visitChildren(find);
  }

  (_boundary.currentContext! as Element).visitChildren(find);
  final dynamic target = shell;
  target.openVoiceRoom('room');
  await _save('voice-room-android');
  target.openNavigation();
  await _save('voice-room-android-navigation');
  target.closeNavigation();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isAndroid) throw UnsupportedError('Нужен Android-телефон');
  final saved = await SharedPreferences.getInstance();
  await saved.setBool('space.ui.dark', true);
  final preferences = AppPreferences();
  final chat = ScreenshotController()..connected = true;
  chat.server(chat.session.server);
  final voice = ScreenshotVoice()..show();
  runApp(
    RepaintBoundary(
      key: _boundary,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: preferences.theme,
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AdminLocalizations.delegate,
          ...AppLocalizations.localizationsDelegates,
        ],
        home: SpaceShell(
          preferences: preferences,
          controller: chat,
          voiceController: voice,
        ),
      ),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_capture()));
}
