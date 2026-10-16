import 'support/chat_outbox.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_admin_ui/src/admin_operations.dart';
import 'package:space_client/src/chat_controller.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/preferences.dart';
import 'package:space_client/src/server_presence.dart';

import 'channels_test.dart'
    show ChannelSession, ChannelVault, MemoryHistory, MemoryPositions;

class EventRecorder extends BlocObserver {
  final events = <Object>[];
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    if (event != null) events.add(event);
    super.onEvent(bloc, event);
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'События настроек сохраняются по порядку; прежние состояния неизменяемы',
    () async {
      final prefs = AppPreferences();
      addTearDown(prefs.close);
      final old = prefs.state;
      final first = prefs.change(language: 'en', dark: false);
      final second = prefs.change(language: 'zh-Hans', palette: 'iris');
      final third = prefs.remember('https://server.example');
      await Future.wait([first, second, third]);
      expect(prefs.state.language, 'zh-Hans');
      expect(prefs.state.dark, false);
      expect(prefs.state.palette, 'iris');
      expect(old.language, 'ru');
      expect(old.origins, isEmpty);
      expect(() => prefs.state.origins.clear(), throwsUnsupportedError);
      final saved = await SharedPreferences.getInstance();
      expect(saved.getString('space.ui.language'), 'zh-Hans');
      expect(saved.getStringList('space.ui.origins'), [
        'https://server.example',
      ]);
    },
  );

  test(
    'Публичное событие Bloc работает без вызова метода контроллера',
    () async {
      final prefs = AppPreferences();
      addTearDown(prefs.close);
      final event = PreferencesChanged(language: 'en');
      final done = event.result;
      prefs.add(event);
      await done;
      expect(prefs.state.language, 'en');
      expect(prefs.state.locale.languageCode, 'en');
    },
  );

  test('Команды чата наблюдаются как события; protobuf состояния защищён от изменений', () async {
    final recorder = EventRecorder();
    final previous = Bloc.observer;
    Bloc.observer = recorder;
    addTearDown(() => Bloc.observer = previous);
    final controller = ChatController(
      ChannelVault(),
      openSession: (_, _) async => ChannelSession(),
      historyStore: MemoryHistory(),
      outboxStore: MemoryChatOutbox(),
      positions: MemoryPositions(),
    );
    addTearDown(controller.close);
    controller.preview = Discovery(
      Uri.parse('http://127.0.0.1:8080'),
      'srv_test',
      List.filled(32, 1),
    );
    await controller.connect();
    final before = controller.state;
    final message = before.messages.single;
    expect(() => message.text = 'changed', throwsUnsupportedError);
    expect(() => before.messages.clear(), throwsUnsupportedError);
    await controller.toggleFavorite(message);
    expect(controller.state.isFavorite(message), true);
    expect(identical(controller.state.messages, before.messages), true);
    expect(identical(controller.state.channels, before.channels), true);
    expect(before.isFavorite(message), false);
    expect(recorder.events.whereType<ChatConnected>(), hasLength(1));
    expect(recorder.events.whereType<ChatFavoriteToggled>(), hasLength(1));
    await controller.disconnect();
    expect(controller.state.connected, false);
    expect(before.connected, true);
  });

  test(
    'Результат доступен и после обработки события без первоначального ожидания',
    () async {
      final prefs = AppPreferences();
      addTearDown(prefs.close);
      final changed = prefs.stream.firstWhere(
        (state) => state.language == 'en',
      );
      final event = PreferencesChanged(language: 'en');
      prefs.add(event);
      await changed;
      await Future<void>.delayed(Duration.zero);
      await event.result.timeout(const Duration(seconds: 1));
      expect(prefs.state.language, 'en');
    },
  );

  test(
    'Закрытие завершает ожидающие события и отклоняет новые команды',
    () async {
      final prefs = AppPreferences();
      final request = prefs.change(language: 'en');
      await prefs.close().timeout(const Duration(seconds: 2));
      await request.timeout(const Duration(seconds: 2));
      await expectLater(prefs.change(language: 'ru'), throwsStateError);
    },
  );

  test(
    'Поздний ответ доступности не возвращает удалённый сервер в состояние Bloc',
    () async {
      final response = Completer<bool?>();
      final presence = ServerPresence(probe: (_) => response.future);
      addTearDown(presence.close);
      await presence.watch(['https://server.example']);
      final old = presence.state;
      await presence.watch([]);
      response.complete(true);
      await Future<void>.delayed(Duration.zero);
      expect(presence.state.online, isEmpty);
      expect(old.online, isEmpty);
      expect(() => presence.state.online['new'] = true, throwsUnsupportedError);
    },
  );

  test('Административная операция отвергает двойной запуск и допускает повтор после ошибки', () async {
    final operations = AdminOperations();
    addTearDown(operations.close);
    expect(await Future.wait([operations.begin(), operations.begin()]), [
      true,
      false,
    ]);
    expect(operations.state.busy, true);
    final failed = operations.stream.firstWhere((state) => !state.busy);
    operations.finish(error: StateError('Отказ сервера'));
    expect((await failed).error, isA<StateError>());
    expect(await operations.begin(), true);
    expect(operations.state.error, isNull);
    final completed = operations.stream.firstWhere((state) => !state.busy);
    operations.finish();
    await completed;
    expect(operations.state.busy, false);
  });
}
