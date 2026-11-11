import 'dart:async';

import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart';
import 'package:space_client/src/builtin/commands.dart';
import 'package:space_client/src/builtin/navigation_cubit.dart';
import 'package:space_client/src/builtin/transport.dart';
import 'package:space_client/src/generated/space/v1/builtin.pb.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart';
import 'package:space_client/src/generated/space/v1/voice.pb.dart';
import 'package:space_client/src/rpc_connection.dart';
import 'package:space_client/ui/builtin_navigation.dart';

BuiltinSection section() => BuiltinSection(
  instanceId: 'builtin:chat:chat',
  installationId: 'builtin:chat',
  pluginId: 'space.chat',
  version: 'legacy.p2',
  viewId: 'chat',
  channel: Channel(
    id: 'chat',
    title: 'Чат',
    permissions: ChannelPermissions(read: true, visible: true),
  ),
);

class NavigationFixture implements BuiltinTransport {
  Completer<BuiltinSection>? pending;
  bool fail = false;
  @override
  Future<List<BuiltinSection>> list() async => [section()];
  @override
  Future<BuiltinSection> open(String id) async {
    if (fail) throw const GrpcError.permissionDenied();
    return pending?.future ?? section();
  }
}

class ConnectionFixture extends RpcConnection {
  ConnectionFixture() : super.connect(Uri.parse('http://127.0.0.1:1'), '');
  final attempts = <List<int>>[];
  GrpcError? failure;
  bool alwaysFail = false;
  @override
  Future<O> unary<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    RpcOptions? options,
  }) async {
    if (request is ListBuiltinSectionsRequest) {
      return ListBuiltinSectionsResponse(sections: [section()]) as O;
    }
    final command = request as ExecuteBuiltinCommandRequest;
    attempts.add(command.writeToBuffer());
    if (failure != null && (alwaysFail || attempts.length == 1)) throw failure!;
    return ExecuteBuiltinCommandResponse(
      result: Any(
        typeUrl: 'type.googleapis.com/space.v1.CreateContentResponse',
      ),
    ) as O;
  }
}

void main() {
  test('Позднее открытие после выхода не возвращает данные', () async {
    final source = NavigationFixture()..pending = Completer<BuiltinSection>();
    final cubit = BuiltinNavigationCubit(source);
    await cubit.load();
    final opening = cubit.open('builtin:chat:chat');
    cubit.invalidate();
    source.pending!.complete(section());
    await opening;
    expect(cubit.state.sections, isEmpty);
    expect(cubit.state.opened, isNull);
    await cubit.close();
  });
  test('Ошибка ACL очищает список и выбранный раздел', () async {
    final source = NavigationFixture()..fail = true;
    final cubit = BuiltinNavigationCubit(source);
    await cubit.load();
    await cubit.open('builtin:chat:chat');
    expect(cubit.state.failed, true);
    expect(cubit.state.sections, isEmpty);
    await cubit.close();
  });
  test('Повтор ограничен двумя одинаковыми запросами', () async {
    final rpc = ConnectionFixture()
      ..failure = const GrpcError.unavailable()
      ..alwaysFail = true;
    addTearDown(rpc.terminate);
    final api = ConnectBuiltinTransport(
      rpc,
      () => const RpcOptions(),
      () async {},
      () => 'one',
    );
    await api.list();
    final command = CreateContentRequest(
      channelId: 'chat',
      text: 'Текст',
      idempotencyKey: 'same',
    );
    await expectLater(api.route(command, null), throwsA(isA<GrpcError>()));
    expect(rpc.attempts.length, 2);
    expect(rpc.attempts[0], rpc.attempts[1]);
  });
  test('Ключ не меняется при успешном повторе', () async {
    final rpc = ConnectionFixture()
      ..failure = const GrpcError.deadlineExceeded();
    addTearDown(rpc.terminate);
    final api = ConnectBuiltinTransport(
      rpc,
      () => const RpcOptions(),
      () async {},
      () => 'one',
    );
    await api.list();
    await api.route(
      CreateContentRequest(
        channelId: 'chat',
        text: 'Текст',
        idempotencyKey: 'same',
      ),
      null,
    );
    expect(rpc.attempts.length, 2);
    expect(rpc.attempts[0], rpc.attempts[1]);
  });
  test('Отказ ACL и команда без ключа не повторяются', () async {
    for (final error in [
      const GrpcError.permissionDenied(),
      const GrpcError.unavailable(),
    ]) {
      final rpc = ConnectionFixture()..failure = error;
      addTearDown(rpc.terminate);
      final api = ConnectBuiltinTransport(
        rpc,
        () => const RpcOptions(),
        () async {},
        () => 'one',
      );
      await api.list();
      await expectLater(
        api.route(CreateContentRequest(channelId: 'chat'), null),
        throwsA(isA<GrpcError>()),
      );
      expect(rpc.attempts.length, 1);
    }
  });
  test('Смена допуска запрещает команду старого экземпляра', () async {
    final rpc = ConnectionFixture();
    addTearDown(rpc.terminate);
    var scope = 'one';
    final api = ConnectBuiltinTransport(
      rpc,
      () => const RpcOptions(),
      () async {},
      () => scope,
    );
    await api.list();
    scope = 'two';
    await expectLater(
      api.route(CreateContentRequest(channelId: 'chat'), null),
      throwsA(isA<GrpcError>()),
    );
    expect(rpc.attempts, isEmpty);
  });
  test('Фиксированный список и вложенная мутация', () {
    expect(commandPlugins.length, 26);
    final request = ApplyContentMutationRequest(
      update: UpdateContentRequest(channelId: 'chat', idempotencyKey: 'key'),
    );
    expect(commandChannel(request), 'chat');
    expect(retryableCommand(request), true);
    expect(retryableCommand(JoinVoiceRoomRequest(channelId: 'chat')), false);
    expect(
      () => validateSection(section()..pluginId = 'space.feed'),
      throwsFormatException,
    );
  });
  testWidgets('Выбор в диалоге проверяет открытие и возвращает экземпляр', (
    tester,
  ) async {
    BuiltinSection? result;
    final source = NavigationFixture();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showDialog<BuiltinSection>(
                context: context,
                builder: (_) => BuiltinNavigation(
                  transport: source,
                  closing: const Stream.empty(),
                ),
              );
            },
            child: const Text('Открыть'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Открыть'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Чат'));
    await tester.pumpAndSettle();
    expect(result?.instanceId, 'builtin:chat:chat');
  });
}
