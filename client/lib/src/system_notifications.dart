import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:window_manager/window_manager.dart';

import 'notification_targets.dart';

class SystemNotifications {
  SystemNotifications({
    this.appName = 'Space',
    NotificationTargets? savedTargets,
  }) : savedTargets = savedTargets ?? NotificationTargets();
  final NotificationTargets savedTargets;
  static const activationChannel = MethodChannel(
    'space/notification-activation',
  );
  bool _activationListening = false;

  Future<void> listenForActivation({required bool enabled}) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) return;
    if (_activationListening) return;
    _activationListening = true;
    activationChannel.setMethodCallHandler((call) async {
      if (call.method == 'activate' && call.arguments is String) {
        await activate(call.arguments as String);
      }
    });
    if (!enabled) await savedTargets.clear();
    try {
      final token = await activationChannel.invokeMethod<String>('initial');
      if (token != null && token.isNotEmpty) await activate(token);
    } on MissingPluginException {
      // Старый или тестовый runner не поддерживает запуск из карточки.
    }
  }

  Future<void> activate(String token) async {
    try {
      final payload = await savedTargets.take(token);
      if (!_disposed && payload != null && !targets.isClosed) {
        targets.add(payload);
      }
    } catch (_) {
      // Повреждённая запись не открывает произвольный адрес.
    }
  }

  final String appName;
  static bool get supported =>
      !kIsWeb &&
      const [
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
      ].contains(defaultTargetPlatform);
  Future<void>? _initializing;
  final targets = StreamController<String>.broadcast();
  final _active = <int, LocalNotification>{};
  bool _disposed = false;

  Future<void> initialize() async {
    if (!supported) {
      throw UnsupportedError('Уведомления доступны на компьютере');
    }
    try {
      await (_initializing ??= localNotifier.setup(appName: appName));
    } catch (_) {
      _initializing = null;
      rethrow;
    }
  }

  Future<bool> requestPermission() async {
    if (!supported) return false;
    await initialize();
    return true;
  }

  Future<void> focus() async {
    if (!supported) return;
    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (_) {
      /* Навигация остаётся доступной без управления окном. */
    }
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    required List<Object> target,
    String actionLabel = 'Space',
  }) async {
    await initialize();
    if (_disposed) return;
    if (defaultTargetPlatform == TargetPlatform.windows) {
      final token = await savedTargets.save(id, jsonEncode(target));
      await activationChannel.invokeMethod<void>('show', {
        'token': token,
        'appId': appName,
        'title': title,
        'body': body,
        'tag': '$id',
      });
      return;
    }
    if (!_active.containsKey(id) && _active.length >= 64) return;
    if (_active.containsKey(id)) await _active[id]!.close();
    final notification = _active.putIfAbsent(
      id,
      () => LocalNotification(
        identifier: 'space-$id',
        title: title,
        silent: true,
      ),
    );
    notification.title = title;
    notification.body = body;
    notification.actions = defaultTargetPlatform == TargetPlatform.linux
        ? [LocalNotificationAction(text: actionLabel)]
        : [];
    final payload = jsonEncode(target);
    notification.onClick = () {
      if (!targets.isClosed) targets.add(payload);
    };
    notification.onClickAction = (index) {
      if (index == 0 && !targets.isClosed) targets.add(payload);
    };
    await notification.show();
  }

  Future<void> clear() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
      await savedTargets.clear();
      try {
        await activationChannel.invokeMethod<void>('clear', {'appId': appName});
      } on MissingPluginException {
        // Тестовый runner.
      }
    }
    for (final notification in _active.values) {
      notification.onClick = null;
      notification.onClickAction = null;
      await notification.close();
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    if (_activationListening) activationChannel.setMethodCallHandler(null);
    for (final notification in _active.values) {
      notification.onClick = null;
      notification.onClickAction = null;
      localNotifier.removeListener(notification);
    }
    await targets.close();
  }
}
