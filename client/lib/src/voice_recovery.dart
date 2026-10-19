import 'dart:async';
import 'dart:io';

import 'package:grpc/grpc.dart';

import 'local_failure.dart';

bool canRecoverVoice(Object error, {bool missingSession = false}) {
  if (error is LocalFailure) {
    return error.code == LocalFailureCode.connectionFailed;
  }
  if (error is SocketException ||
      error is HttpException ||
      error is TimeoutException) {
    return true;
  }
  if (error is! GrpcError) return false;
  return switch (error.code) {
    StatusCode.unavailable ||
    StatusCode.deadlineExceeded ||
    StatusCode.alreadyExists ||
    StatusCode.resourceExhausted => true,
    StatusCode.notFound => missingSession,
    _ => false,
  };
}

class VoiceRecovery {
  VoiceRecovery(List<Duration> delays) : delays = List.unmodifiable(delays) {
    if (delays.isEmpty || delays.any((delay) => delay.isNegative)) {
      throw ArgumentError('Нужны неотрицательные задержки повторного входа');
    }
  }
  static const defaults = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 15),
  ];
  final List<Duration> delays;
  Timer? _timer;
  int _attempt = 0;

  void schedule(void Function() retry) {
    _timer?.cancel();
    final index = _attempt.clamp(0, delays.length - 1);
    if (_attempt < delays.length) _attempt++;
    _timer = Timer(delays[index], () {
      _timer = null;
      retry();
    });
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    _attempt = 0;
  }
}
