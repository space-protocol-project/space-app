import 'package:connectrpc/connect.dart' as connect;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/rpc_http.dart';

void main() {
  test('Бюджет кадров ограничивает даже пустые валидные кадры', () {
    final limit = RpcBodyLimit(framed: true, streamFrames: 2);
    limit.add([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    expect(
      () => limit.add([0, 0, 0, 0, 0]),
      throwsA(isA<connect.ConnectException>()),
    );
  });
  test('Бюджет байтов охватывает весь поток, включая заголовки', () {
    final limit = RpcBodyLimit(framed: true, streamBytes: 9);
    limit.add([0, 0, 0, 0, 0]);
    expect(
      () => limit.add([0, 0, 0, 0, 0]),
      throwsA(isA<connect.ConnectException>()),
    );
  });
  test('Переподключение не обнуляет бюджет, окно восстанавливает доступ', () {
    var now = DateTime(2026);
    final budget = RpcSubscriptionBudget(
      maxBytes: 10,
      maxStarts: 2,
      now: () => now,
    );
    budget.start();
    budget.add(6);
    budget.start();
    expect(() => budget.add(5), throwsA(isA<connect.ConnectException>()));
    expect(budget.start, throwsA(isA<connect.ConnectException>()));
    now = now.add(const Duration(minutes: 15));
    budget.start();
    budget.add(10);
  });
}
