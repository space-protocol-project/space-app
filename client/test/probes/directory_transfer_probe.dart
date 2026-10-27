import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:protobuf/protobuf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_backup.dart';
import 'package:space_client/src/directory_repository.dart';
import 'package:space_client/src/directory_transfer_rpc.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/ui/directory_transfer.dart';

import '../fixtures/directory.dart';

class DirectoryProbeRelay {
  DirectoryProbeRelay(this.http) {
    http.listen((request) => unawaited(handle(request)));
  }
  final HttpServer http;
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int cancellations = 0;
  bool wrote = false;
  Discovery get discovery => Discovery(Uri.parse('http://127.0.0.1:${http.port}'), 'srv_probe', List.filled(32, 1));
  GeneratedMessage response(String path, List<int> data) => switch (path.split('/').last) {
    'CreateDirectoryTransfer' => CreateDirectoryTransferResponse(id: 'dt_${'a' * 43}', ownerToken: 'dr_${'b' * 43}', code: 'dc_${'c' * 43}', createdAt: Int64(now), expiresAt: Int64(now + 300)),
    'ReadDirectoryFrame' => ReadDirectoryFrameResponse(expiresAt: Int64(now + 300)),
    'WriteDirectoryFrame' => write(data),
    'CloseDirectoryTransfer' => closeLease(),
    _ => throw StateError('Unexpected RPC'),
  };
  GeneratedMessage write(List<int> data) {
    final input = WriteDirectoryFrameRequest.fromBuffer(data);
    if (input.sequence != 0 || input.data.length != 32) throw StateError('Noise first message');
    wrote = true;
    return WriteDirectoryFrameResponse();
  }
  GeneratedMessage closeLease() {
    cancellations++;
    return CloseDirectoryTransferResponse();
  }
  Future<void> handle(HttpRequest request) async {
    try {
      final data = await request.fold<List<int>>([], (all, part) => all..addAll(part));
      request.response.headers.contentType = ContentType('application', 'proto');
      request.response.add(response(request.uri.path, data).writeToBuffer());
      await request.response.close();
    } on HttpException {
      // Закрытие RPC при отмене ожидаемо.
    } on SocketException {
      // Оборванный poll не возвращает попытку на экран.
    }
  }
}

Future<void> main() async {
  late DirectoryProbeRelay relay;
  enableFlutterDriverExtension(handler: (_) async => '${relay.cancellations}:${relay.wrote}');
  SharedPreferences.setMockInitialValues({});
  FlutterError.onError = (details) {
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error');
    return true;
  };
  relay = DirectoryProbeRelay(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));
  final preferences = AppPreferences();
  final vault = DirectoryVault();
  final controller = ChatController(vault)..preview = relay.discovery;
  final service = DirectoryBackupService(DirectoryRepository(DirectoryStorage()), vault, preferences, () => {});
  runApp(MaterialApp(
    locale: const Locale('ru'), theme: preferences.theme,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: [...AppLocalizations.localizationsDelegates, AdminLocalizations.delegate],
    home: Scaffold(body: SingleChildScrollView(child: DirectoryTransferPanel(service: service, controller: controller))),
  ));
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 1), () => debugPrint('COMMUNITY_UI_READY'));
  });
}
