import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:space_client/src/builtin/navigation_cubit.dart';
import 'package:space_client/src/builtin/transport.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/generated/space/v1/space.connect.spec.dart';
import 'package:space_client/src/rpc_connection.dart';

Future<void> control(Directory dir, String command) async {
  await File('${dir.path}/control').writeAsString(command, flush: true);
  final done = File('${dir.path}/completed');
  final until = DateTime.now().add(const Duration(seconds: 15));
  while (DateTime.now().isBefore(until)) {
    if (await done.exists() && await done.readAsString() == command) return;
    await Future<void>.delayed(const Duration(milliseconds: 30));
  }
  throw StateError('Стенд не завершил $command');
}

void main() {
  final path = Platform.environment['SPACE_P2_CLIENT'];
  test(
    'P2 настоящий Connect: навигация, ACL, отзыв сессии и потерянная квитанция',
    () async {
      final dir = Directory(path!);
      final config = jsonDecode(
        await File('$path/connection.json').readAsString(),
      ) as Map<String, dynamic>;
      final connection = RpcConnection.connect(
        Uri.parse(config['url'] as String),
        '',
      );
      final options = RpcOptions(
        metadata: {'authorization': config['authorization'] as String},
      );
      final transport = ConnectBuiltinTransport(
        connection,
        () => options,
        () async {},
        () => 'fixture-member',
      );
      final cubit = BuiltinNavigationCubit(transport);
      addTearDown(cubit.close);
      addTearDown(connection.terminate);
      await cubit.load();
      expect(cubit.state.failed, false);
      expect(
        cubit.state.sections.map((s) => s.pluginId).toSet(),
        containsAll([
          'space.chat',
          'space.rooms',
          'space.discussions',
          'space.feed',
        ]),
      );
      const instance = 'builtin:client_chat:chat';
      await cubit.open(instance);
      expect(cubit.state.opened?.instanceId, instance);
      await control(dir, 'drop');
      final command = CreateContentRequest(
        channelId: 'client_chat',
        text: 'Одна запись',
        idempotencyKey: 'p2-client-key',
      );
      final first = await connection.unary(
        ContentService.createContent,
        command,
        options: options,
      );
      final second = await connection.unary(
        ContentService.createContent,
        command,
        options: options,
      );
      expect(second.content.id, first.content.id);
      await control(dir, 'readonly');
      await expectLater(
        connection.unary(
          ContentService.createContent,
          command,
          options: options,
        ),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            StatusCode.permissionDenied,
          ),
        ),
      );
      await control(dir, 'verify');
      await control(dir, 'hide');
      await cubit.load();
      expect(cubit.state.sections.any((s) => s.instanceId == instance), false);
      await expectLater(
        transport.open(instance),
        throwsA(
          isA<GrpcError>().having((e) => e.code, 'code', StatusCode.notFound),
        ),
      );
      await control(dir, 'restore');
      await cubit.load();
      await cubit.open(instance);
      expect(cubit.state.opened?.instanceId, instance);
      await control(dir, 'logout');
      await cubit.load();
      expect(cubit.state.failed, true);
      expect(cubit.state.sections, isEmpty);
      await expectLater(
        connection.unary(
          ContentService.createContent,
          command,
          options: options,
        ),
        throwsA(
          isA<GrpcError>().having(
            (e) => e.code,
            'code',
            StatusCode.unauthenticated,
          ),
        ),
      );
      await File('$path/control').writeAsString('stop', flush: true);
    },
    skip: path == null,
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
