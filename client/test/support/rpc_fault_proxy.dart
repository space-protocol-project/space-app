import 'package:connectrpc/connect.dart' as connect;
import 'package:protobuf/protobuf.dart';
import 'package:space_client/src/rpc_connection.dart';

// Общая точка мутации между настоящим/тестовым RPC и клиентом.
class RpcFaultProxy implements RpcConnection {
  RpcFaultProxy(this.target);
  final RpcConnection target;
  GeneratedMessage Function(String method, GeneratedMessage response)? mutate;
  void Function(GeneratedMessage request)? beforeRequest;
  @override
  Future<O> unary<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    RpcOptions? options,
  }) async {
    beforeRequest?.call(request);
    final response = await target.unary(spec, request, options: options);
    return (mutate?.call(request.info_.messageName, response) ?? response) as O;
  }

  @override
  RpcStream<O> server<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    RpcOptions? options,
  }) {
    final stream = target.server(spec, request, options: options);
    return RpcStream(
      stream.map(
        (response) =>
            (mutate?.call(request.info_.messageName, response) ?? response)
                as O,
      ),
      stream.cancel,
    );
  }

  @override
  Future<void> shutdown() => target.shutdown();
  @override
  Future<void> terminate() => target.terminate();
}
