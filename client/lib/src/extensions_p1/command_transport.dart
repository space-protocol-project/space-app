import 'package:connectrpc/connect.dart' as connect;

import '../generated/space/v1/extensions_p1.pb.dart';
import '../generated/space/v1/extensions_p1.connect.client.dart';
import '../rpc_connection.dart';

abstract interface class ExtensionCommandTransport {
  Future<GetExtensionMutationContextResponse> context(String instance);
  Future<ExecuteExtensionCommandResponse> execute(ExecuteExtensionCommandRequest request);
  Future<ReconcileExtensionCommandResponse> reconcile(ExecuteExtensionCommandRequest request);
  void cancel();
}

// Отдельно создаваемый адаптер. Рабочая навигация пока его не регистрирует.
class ExtensionConnectCommandTransport implements ExtensionCommandTransport {
  ExtensionConnectCommandTransport(this.client, this.metadata);
  final ExtensionP1ServiceClient client;
  final Map<String, String> Function() metadata;
  RpcCall? _active;

  Future<T> _call<T>(Future<T> Function(RpcCall) invoke, int seconds) async {
    if (_active != null) { throw StateError('RPC уже выполняется'); }
    final call = RpcCall(RpcOptions(metadata: metadata()), Duration(seconds: seconds));
    _active = call;
    try {
      return await invoke(call);
    } finally {
      call.cancel();
      _active = null;
    }
  }

  @override
  Future<GetExtensionMutationContextResponse> context(String instance) => _call(
    (call) => client.getExtensionMutationContext(
      GetExtensionMutationContextRequest(instanceId: instance, requestRetryWindow: true),
      headers: call.headers, signal: call,
    ), 2,
  );

  @override
  Future<ExecuteExtensionCommandResponse> execute(ExecuteExtensionCommandRequest request) => _call(
    (call) => client.executeExtensionCommand(request, headers: call.headers, signal: call), 5,
  );

  @override
  Future<ReconcileExtensionCommandResponse> reconcile(ExecuteExtensionCommandRequest request) => _call(
    (call) => client.reconcileExtensionCommand(
      ReconcileExtensionCommandRequest(command: request), headers: call.headers, signal: call,
    ), 5,
  );

  @override
  void cancel() => _active?.cancel();
}

String extensionCommandErrorCode(Object error) {
  if (error is! connect.ConnectException) { return 'TransportLost'; }
  return switch (error.code.value) {
    1 => 'Canceled', 2 => 'Unknown', 3 => 'InvalidArgument',
    4 => 'DeadlineExceeded', 5 => 'NotFound', 6 => 'AlreadyExists',
    7 => 'PermissionDenied', 8 => 'ResourceExhausted',
    9 => 'FailedPrecondition', 10 => 'Aborted', 11 => 'OutOfRange',
    12 => 'Unimplemented', 13 => 'Internal', 14 => 'Unavailable',
    15 => 'DataLoss', 16 => 'Unauthenticated', _ => 'Unknown',
  };
}
