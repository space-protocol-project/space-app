import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'src/desktop_window.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Space MLS — Rust',
    ], await rootBundle.loadString('assets/legal/mls-NOTICES.txt'));
    yield LicenseEntryWithLineBreaks([
      'Unicode Emoji / CLDR',
    ], await rootBundle.loadString('assets/emoji/UNICODE-LICENSE.txt'));
    for (final entry in {
      'Nunito': 'Nunito',
      'Nunito Sans': 'NunitoSans',
      'JetBrains Mono': 'JetBrainsMono',
    }.entries) {
      yield LicenseEntryWithLineBreaks([
        entry.key,
      ], await rootBundle.loadString('assets/fonts/${entry.value}-OFL.txt'));
    }
  });
  DesktopWindowState? desktopWindow;
  try {
    desktopWindow = await DesktopWindowState.initialize();
  } catch (_) {
    // Недоступные настройки окна не мешают запуску приложения.
  }
  runApp(const SpaceApp());
  if (desktopWindow != null) {
    unawaited(desktopWindow.restore().catchError((Object _) {}));
  }
}
