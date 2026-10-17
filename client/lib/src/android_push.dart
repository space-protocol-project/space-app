import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'core.dart';
import 'system_notifications.dart';

class AndroidPush {
  final _registered = <String, DateTime>{};
  final _routes = <String, String>{};
  final _running = <String>{};
  int _generation = 0;
  static bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> sync({
    required bool enabled,
    required List<String> origins,
  }) async {
    if (!supported) return;
    _generation++;
    _registered.removeWhere(
      (scope, _) => !origins.contains((jsonDecode(scope) as List).first),
    );
    await SystemNotifications.activationChannel.invokeMethod<void>('pushSync', {
      'enabled': enabled,
      'origins': origins,
    });
  }

  Future<void> register(SpaceSession session) async {
    if (!supported) return;
    final scope = jsonEncode([
      session.server.origin.toString(),
      session.record.grantId,
    ]);
    final now = DateTime.now();
    final route =
        '${session.server.connectOrigin}|${session.server.tlsFingerprint}';
    if (_running.contains(scope) ||
        (_routes[scope] == route &&
            now.difference(_registered[scope] ?? DateTime(2000)).inHours < 12)) {
      return;
    }
    _running.add(scope);
    final generation = _generation;
    try {
      final identity = await SystemNotifications.activationChannel
          .invokeMapMethod<String, String>('pushIdentity', scope);
      if (identity == null || generation != _generation) return;
      final config = await session.registerAndroidPush(identity);
      if (generation != _generation) return;
      await SystemNotifications.activationChannel.invokeMethod<void>(
        'pushConfigure',
        {...config, 'scope': scope},
      );
      _registered[scope] = now;
      _routes[scope] = route;
    } finally {
      _running.remove(scope);
    }
  }
}
