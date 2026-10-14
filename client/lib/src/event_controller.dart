import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Событие с необязательным ожиданием результата для составных операций.
abstract class RequestEvent<T> {
  RequestEvent() {
    // Событие можно отправить без ожидания; результат остаётся доступен позднее.
    _completion.future.ignore();
  }
  final _completion = Completer<T>();
  bool _resultRequested = false;
  Future<T> get result {
    _resultRequested = true;
    return _completion.future;
  }

  Future<void> runAndComplete(FutureOr<T> Function() operation) async {
    try {
      final value = await operation();
      _completion.complete(value);
    } catch (error, stack) {
      _completion.completeError(error, stack);
      if (!_resultRequested) rethrow;
    }
  }
}

abstract class EventController<Event extends RequestEvent<dynamic>, StateType>
    extends Bloc<Event, StateType> {
  EventController(super.initialState);

  Future<T> sendRequest<T>(Event event) {
    if (isClosed) return Future.error(StateError('Контроллер закрыт'));
    final result = event.result as Future<T>;
    add(event);
    return result;
  }

  // Команда завершается после публикации состояния, чтобы вызывающий код видел результат.
  Future<void> _lastStatePublished = Future.value();

  void publishStateEvent(Event event) {
    if (!isClosed) _lastStatePublished = sendRequest<void>(event);
  }

  Future<void> handleRequest<T>(
    RequestEvent<T> event,
    FutureOr<T> Function() operation,
  ) => event.runAndComplete(() async {
    final value = await operation();
    await _lastStatePublished;
    return value;
  });

  /// Освобождение из синхронного State.dispose; владельцы могут ожидать close.
  void dispose() => unawaited(close());
}
