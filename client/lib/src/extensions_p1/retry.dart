// Экспериментальная политика space.retry.p1. Она не отправляет RPC.
// Наблюдение формирует доверенный транспорт, не WASM и не JSON ответа.
typedef ExtensionRetryObservation = ({
  String code,
  int attempt,
  int elapsedMs,
  int remainingMs,
  bool windowKnown,
  bool sameRequest,
  bool cancelled,
  bool previousUnknown,
});

typedef ExtensionRetryDecision = ({String action, bool unknown, int delayMs});

ExtensionRetryDecision decideExtensionRetry(ExtensionRetryObservation o) {
  if (_invalidObservation(o)) {
    return (action: 'stop', unknown: true, delayMs: 0);
  }
  if (o.code == 'OK') {
    return (action: 'confirmed', unknown: false, delayMs: 0);
  }
  final (ambiguous, known) = _retryCode(o.code);
  final unknown = o.previousUnknown || ambiguous || !known;
  final stop = (action: 'stop', unknown: unknown, delayMs: 0);
  if (o.cancelled || !known || o.code == 'Canceled' || o.code == 'DataLoss') return stop;
  if (o.code == 'Unauthenticated') {
    return (action: 'reauthenticate', unknown: unknown, delayMs: 0);
  }
  final delay = _retryDelay(o, ambiguous);
  if (delay == 0) return stop;
  return (action: 'retry_same_request', unknown: unknown, delayMs: delay);
}

bool _invalidObservation(ExtensionRetryObservation o) =>
    o.attempt < 1 || o.attempt > 4 || o.elapsedMs < 0 ||
    o.remainingMs < 0 || !o.sameRequest;

int _retryDelay(ExtensionRetryObservation o, bool ambiguous) {
  if (!ambiguous || o.attempt == 4 || !o.windowKnown) return 0;
  final delay = 250 << (o.attempt - 1);
  if (o.elapsedMs > 30000 - delay - 5000 ||
      o.remainingMs < delay + 5000) return 0;
  return delay;
}

(bool, bool) _retryCode(String code) {
  return switch (code) {
    'Unknown' || 'Internal' || 'Unavailable' || 'DeadlineExceeded' ||
    'TransportLost' || 'Canceled' || 'DataLoss' => (true, true),
    'InvalidArgument' || 'NotFound' || 'AlreadyExists' || 'PermissionDenied' ||
    'ResourceExhausted' || 'FailedPrecondition' || 'Aborted' || 'OutOfRange' ||
    'Unimplemented' || 'Unauthenticated' => (false, true),
    _ => (false, false),
  };
}
