// Проверяет, что сетевое ядро доступно проверочным программам без Flutter engine.
import 'package:space_client/src/core.dart';

void main() {
  final input = parseConnectionInput('http://127.0.0.1:18080');
  if (input.origin.host != '127.0.0.1' || input.origin.port != 18080) {
    throw StateError('Не удалось открыть общее ядро в Dart CLI');
  }
}
