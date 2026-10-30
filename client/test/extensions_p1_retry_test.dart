import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/retry.dart';

ExtensionRetryObservation observation(Map<String, dynamic> value) => (
  code: value['code'] as String,
  attempt: value['attempt'] as int,
  elapsedMs: value['elapsed_ms'] as int,
  remainingMs: value['remaining_ms'] as int,
  windowKnown: value['window_known'] as bool,
  sameRequest: value['same_request'] as bool,
  cancelled: value['cancelled'] as bool,
  previousUnknown: value['previous_unknown'] as bool,
);

void main() {
  final fixture = jsonDecode(
    File('test/fixtures/extensions_p1/retry.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  test('Версия и полнота общего набора', () {
    expect(fixture['version'], 'space.retry.p1');
    expect(fixture['cases'], hasLength(40));
  });
  for (final raw in fixture['cases'] as List<dynamic>) {
    final item = raw as Map<String, dynamic>;
    test(item['name'] as String, () {
      final result = decideExtensionRetry(
        observation(item['input'] as Map<String, dynamic>),
      );
      expect({
        'action': result.action,
        'unknown': result.unknown,
        'delay_ms': result.delayMs,
      }, item['expected']);
    });
  }
  test('Отказ доступа после потери ответа не доказывает откат', () {
    final first = decideExtensionRetry((
      code: 'TransportLost', attempt: 1, elapsedMs: 0, remainingMs: 30000,
      windowKnown: true, sameRequest: true, cancelled: false,
      previousUnknown: false,
    ));
    final denied = decideExtensionRetry((
      code: 'PermissionDenied', attempt: 2, elapsedMs: 250, remainingMs: 29750,
      windowKnown: true, sameRequest: true, cancelled: false,
      previousUnknown: first.unknown,
    ));
    expect(first.action, 'retry_same_request');
    expect(denied, (action: 'stop', unknown: true, delayMs: 0));
  });
}
