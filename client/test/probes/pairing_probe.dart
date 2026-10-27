import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/pairing_panel.dart';

import '../pairing_transport_test.dart' show PairingServer;

class ProbeVault implements IdentityVault {
  @override
  Future<DeviceRecord?> load(String origin) async => null;
  @override
  Future<void> save(DeviceRecord record) async {}
}

Future<void> main() async {
  late PairingServer server;
  enableFlutterDriverExtension(handler: (_) async => '${server.cancellations}');
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = (details) {
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error');
    return true;
  };
  server = PairingServer(
    await HttpServer.bind(InternetAddress.loopbackIPv4, 0),
  );
  final controller = ChatController(ProbeVault())..preview = server.discovery;
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppPreferences().theme,
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: PairingStartPanel(
            controller: controller,
            onConnected: (_) async {},
          ),
        ),
      ),
    ),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}
