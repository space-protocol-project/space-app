import 'dart:io';

import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/command_cubit.dart';
import 'package:space_client/src/extensions_p1/command_snapshot.dart';
import 'package:space_client/src/extensions_p1/command_transport.dart';
import 'package:space_client/src/generated/space/v1/extensions_p1.connect.client.dart';
import 'package:space_client/src/rpc_http.dart';

import 'extensions_p1_command_test.dart' show MemoryJournalStorage, command;

void main() {
  final endpoint = Platform.environment['SPACE_P1_COMMAND_URL'];
  test(
    'Connect → настоящий gRPC/ACL/PostgreSQL: потеря ответа и сверка',
    () async {
      final address = endpoint!;
      final http = HttpClient();
      final transport = ExtensionConnectCommandTransport(
        ExtensionP1ServiceClient(
          protocol.Transport(
            baseUrl: address,
            codec: const ProtoCodec(),
            httpClient: rpcHttpClient(http, budget: RpcSubscriptionBudget()),
          ),
        ),
        () => {'authorization': Platform.environment['SPACE_P1_COMMAND_AUTH']!},
      );
      final binding = (
        server: address,
        space: 'fixture',
        installation: 'install',
        principal: Platform.environment['SPACE_P1_COMMAND_PRINCIPAL']!,
      );
      final storage = MemoryJournalStorage();
      final journal = ExtensionCommandJournal(storage, binding);
      final cubit = ExtensionCommandCubit(transport, journal, () => binding);
      try {
        await cubit.start(command());
        expect(cubit.state.phase, 'confirmed');
        expect(cubit.state.attempts, 2);
        final reopened = ExtensionCommandCubit(
          transport,
          ExtensionCommandJournal(storage, binding),
          () => binding,
        );
        try {
          await reopened.reconcile();
          expect(reopened.state.phase, 'confirmed');
        } finally {
          await reopened.close();
        }
      } finally {
        await cubit.close();
        http.close(force: true);
      }
    },
    skip: endpoint == null ? 'Требуется серверный стенд P1' : false,
  );
}
