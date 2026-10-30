import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:space_client/src/extensions_p1/demo_session.dart';
import 'package:space_client/ui/extensions_p1_demo.dart';

void main() {
  enableFlutterDriverExtension();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error');
    return true;
  };
  final session = ExtensionDemoSession(
    ExtensionDemoConnection(
      Uri.parse(Platform.environment['P1_DEMO_URL']!),
      Platform.environment['P1_DEMO_EDITOR']!,
    ),
  );
  runApp(
    MaterialApp(
      home: Scaffold(body: ExtensionDemoView(session: session)),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => debugPrint('COMMUNITY_UI_READY'),
  );
}
