import '../generated/space/v1/extensions_p1.pb.dart';
import '../generated/space/v1/extensions_p1.connect.client.dart';
import '../rpc_connection.dart';
import 'contributions.dart';
import 'document.dart';

abstract interface class ContributionsTransport {
  Future<ContributionRegistry> list();
  Future<ExtensionDocument> query(String name);
  Future<void> command(String name);
  void cancel();
}

// Экземпляр и разрешённые имена команд задаёт доверенная оболочка.
// Список contributions сам по себе не даёт права исполнения команды.
class ConnectContributionsTransport implements ContributionsTransport {
  ConnectContributionsTransport(
    this.client,
    this.instance,
    this.metadata,
    Set<String> commands,
  ) : commands = Set.unmodifiable(commands);
  final ExtensionP1ServiceClient client;
  final String instance;
  final Map<String, String> Function() metadata;
  final Set<String> commands;
  final _calls = <RpcCall>{};

  Future<T> _call<T>(Future<T> Function(RpcCall) invoke) async {
    final call = RpcCall(
      RpcOptions(metadata: metadata()),
      const Duration(seconds: 5),
    );
    _calls.add(call);
    try {
      return await invoke(call);
    } finally {
      _calls.remove(call);
      call.cancel();
    }
  }

  @override
  Future<ContributionRegistry> list() => _call((call) async {
    final result = await client.listExtensionContributions(
      ListExtensionContributionsRequest(instanceId: instance),
      headers: call.headers,
      signal: call,
    );
    return ContributionRegistry.parse(result);
  });

  @override
  Future<ExtensionDocument> query(String name) => _call((call) async {
    final result = await client.queryExtension(
      QueryExtensionRequest(
        instanceId: instance,
        query: name,
        payloadJson: const [123, 125],
      ),
      headers: call.headers,
      signal: call,
    );
    if (result.uiApi != 'space.ui.p1') {
      throw const FormatException('Неподдерживаемая версия интерфейса');
    }
    return ExtensionDocument.parse(result.documentJson, commands);
  });

  @override
  Future<void> command(String name) async {
    if (!commands.contains(name)) throw StateError('Неизвестная команда');
    await _call(
      (call) => client.executeExtensionCommand(
        ExecuteExtensionCommandRequest(
          instanceId: instance,
          command: name,
          payloadJson: const [123, 125],
          effect: ExtensionCommandEffect.EXTENSION_COMMAND_EFFECT_NONE,
        ),
        headers: call.headers,
        signal: call,
      ),
    );
  }

  @override
  void cancel() {
    for (final call in _calls.toList()) {
      call.cancel();
    }
  }
}
