import 'dart:async';
import 'dart:io';

import 'package:connectrpc/connect.dart' as connect;
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/connect.dart' as protocol;
import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';

import 'rpc_http.dart';

class RpcConnection {
  RpcConnection.grpc(ClientChannel channel)
    : _grpc = channel,
      _http = null,
      _client = null;
  RpcConnection.connect(
    Uri origin,
    String fingerprint, {
    connect.Codec? codec,
    String? dialHost,
  }) : _grpc = null,
       _http = pinnedRpcClient(origin, fingerprint, dialHost: dialHost) {
    _client = connect.Client(
      protocol.Transport(
        baseUrl: origin.toString(),
        codec: codec ?? const ProtoCodec(),
        httpClient: rpcHttpClient(_http!),
      ),
    );
  }
  final ClientChannel? _grpc;
  final HttpClient? _http;
  connect.Client? _client;
  final _active = <RpcCall>{};
  bool _closed = false;
  bool get usesConnect => _client != null;

  ClientCall<I, O> _legacy<
    I extends GeneratedMessage,
    O extends GeneratedMessage
  >(connect.Spec<I, O> spec, I request, CallOptions? options) {
    final method = ClientMethod<I, O>(
      spec.procedure,
      (message) => message.writeToBuffer(),
      (bytes) => spec.outputFactory()..mergeFromBuffer(bytes),
    );
    return _grpc!.createCall(
      method,
      Stream.value(request),
      options ?? CallOptions(timeout: const Duration(seconds: 10)),
    );
  }

  Future<O> unary<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    CallOptions? options,
  }) async {
    if (_closed) throw const GrpcError.unavailable('RPC-соединение закрыто');
    if (_grpc != null) return ResponseFuture(_legacy(spec, request, options));
    final call = _begin(options, const Duration(seconds: 10));
    try {
      return await _client!.unary(
        spec,
        request,
        headers: call.headers,
        signal: call,
      );
    } on connect.ConnectException catch (error) {
      throw rpcError(error);
    } finally {
      _finish(call);
    }
  }

  RpcStream<O> server<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request, {
    CallOptions? options,
  }) {
    if (_closed) {
      return RpcStream(
        Stream.error(const GrpcError.unavailable('RPC-соединение закрыто')),
        () async {},
      );
    }
    if (_grpc != null) {
      final stream = ResponseStream(_legacy(spec, request, options));
      return RpcStream(stream, stream.cancel);
    }
    final call = _begin(options, const Duration(minutes: 11));
    return RpcStream(_messages(spec, request, call), () async => _finish(call));
  }

  Stream<O> _messages<I extends GeneratedMessage, O extends GeneratedMessage>(
    connect.Spec<I, O> spec,
    I request,
    RpcCall call,
  ) async* {
    try {
      await for (final message in _client!.server(
        spec,
        request,
        headers: call.headers,
        signal: call,
      )) {
        yield message;
      }
    } on connect.ConnectException catch (error) {
      throw rpcError(error);
    } finally {
      _finish(call);
    }
  }

  RpcCall _begin(CallOptions? options, Duration defaultTimeout) {
    final call = RpcCall(options, defaultTimeout);
    _active.add(call);
    return call;
  }

  void _finish(RpcCall call) {
    call.cancel();
    _active.remove(call);
  }

  Future<void> shutdown() => terminate();
  Future<void> terminate() async {
    _closed = true;
    for (final call in _active.toList()) {
      _finish(call);
    }
    _http?.close(force: true);
    await _grpc?.terminate();
  }
}

class RpcCall implements connect.AbortSignal {
  RpcCall(CallOptions? options, Duration defaultTimeout) {
    final timeout = options?.timeout ?? defaultTimeout;
    deadline = DateTime.now().add(timeout);
    timer = Timer(
      timeout,
      () => signal.cancel(
        connect.ConnectException(
          connect.Code.deadlineExceeded,
          'Истёк срок RPC',
        ),
      ),
    );
    for (final entry
        in (options?.metadata ?? const <String, String>{}).entries) {
      headers.add(entry.key, entry.value);
    }
  }
  @override
  late final DateTime deadline;
  @override
  Future<connect.ConnectException> get future => signal.future;
  late final Timer timer;
  final headers = connect.Headers();
  final signal = connect.CancelableSignal();
  void cancel() {
    timer.cancel();
    signal.cancel();
  }
}

class RpcStream<T> extends StreamView<T> {
  RpcStream(super.stream, this.cancel);
  final Future<void> Function() cancel;
}

Object rpcError(connect.ConnectException error) {
  final cause = error.cause;
  if (cause is HandshakeException || cause is SocketException) return cause!;
  return GrpcError.custom(error.code.value, error.message);
}
