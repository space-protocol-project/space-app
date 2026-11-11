import 'dart:io';
import 'dart:ui';

import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:space_client/src/extensions_p1/actions.dart';
import 'package:space_client/src/extensions_p1/contributions_cubit.dart';
import 'package:space_client/src/extensions_p1/contributions_transport.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.connect.client.dart';
import 'package:space_client/src/rpc_http.dart';
import 'package:space_client/ui/extension_contributions.dart';

void main() {
  final http = HttpClient();
  final transport = ConnectContributionsTransport(
    ExtensionP1ServiceClient(
      protocol.Transport(
        baseUrl: Platform.environment['P1_CONTRIBUTIONS_URL']!,
        codec: const ProtoCodec(),
        httpClient: rpcHttpClient(http, budget: RpcSubscriptionBudget()),
      ),
    ),
    'demo',
    () => {'authorization': Platform.environment['P1_CONTRIBUTIONS_AUTH']!},
    {'refresh'},
  );
  final cubit = ContributionsCubit(transport);
  final actions = ExtensionActions({'refresh': () => cubit.command('refresh')});
  enableFlutterDriverExtension(
    handler: (message) async {
      if (message != 'invalidate') throw StateError('Неизвестное действие');
      cubit.invalidate();
      return 'invalidated';
    },
  );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('COMMUNITY_UI_ERROR: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('COMMUNITY_UI_ERROR: $error');
    return true;
  };
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ExtensionContributionsView(cubit: cubit, actions: actions),
      ),
    ),
  );
  cubit.load();
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => debugPrint('COMMUNITY_UI_READY'),
  );
}
