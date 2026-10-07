import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import 'core.dart';
import 'generated/space/v1/space.pb.dart';

class ChatController extends ChangeNotifier {
  ChatController(this.vault);
  final IdentityVault vault;
  Discovery? preview;
  SpaceSession? _session;
  Timer? _timer;
  bool busy = false, connected = false, _polling = false, _disposed = false;
  String error = '',
      fingerprint = '',
      cursor = '',
      _pendingText = '',
      _pendingKey = '';
  final Map<String, Content> _messages = {};
  List<Content> get messages => _messages.values.toList();
  String get principalId => _session?.principalId ?? '';
  void _update() {
    if (!_disposed) notifyListeners();
  }

  String _explain(Object problem) {
    if (problem is FormatException) return problem.message.toString();
    if (problem is GrpcError && problem.code == StatusCode.unauthenticated) {
      return 'Устройство отозвано или разрешение истекло. Автоматическая перерегистрация отключена.';
    }
    if (problem is GrpcError && problem.code == StatusCode.resourceExhausted) {
      return 'Достигнут лимит сервера.';
    }
    return 'Не удалось выполнить операцию. Проверьте сервер, соединение и доступ к хранилищу ключей.';
  }

  Future<void> inspect(String address) async {
    if (busy) return;
    busy = true;
    error = '';
    preview = null;
    _update();
    try {
      final server = await discover(address);
      final saved = await vault.load(server.origin.toString());
      if (saved != null) checkTrust(server, saved);
      fingerprint = await server.fingerprint();
      preview = server;
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> connect() async {
    final server = preview;
    if (busy || server == null) return;
    busy = true;
    error = '';
    _timer?.cancel();
    connected = false;
    _update();
    try {
      await _session?.close();
      _session = null;
      final session = await SpaceSession.connect(server, vault);
      if (_disposed) {
        await session.close();
        return;
      }
      _session = session;
      final initial = await session.messages();
      _messages.clear();
      for (final message in initial) {
        _messages[message.id] = message;
      }
      cursor = '';
      connected = true;
      _timer = Timer.periodic(const Duration(seconds: 2), (_) => poll());
      await poll();
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> poll() async {
    final session = _session;
    if (session == null || !connected || _polling || _disposed) return;
    _polling = true;
    try {
      final events = await session.events(cursor);
      if (_session != session || _disposed) return;
      for (final event in events.events) {
        if (event.type != 'content.created' || !event.hasContent()) {
          throw const FormatException('Неподдерживаемое событие');
        }
        _messages[event.content.id] = event.content;
      }
      cursor = events.nextCursor;
    } catch (e) {
      if (_session == session && !_disposed) {
        error = _explain(e);
        connected = false;
        _timer?.cancel();
      }
    } finally {
      _polling = false;
      _update();
    }
  }

  Future<bool> send(String text) async {
    final session = _session;
    if (busy || !connected || session == null || text.trim().isEmpty) {
      return false;
    }
    if (_pendingText != text || _pendingKey.isEmpty) {
      _pendingText = text;
      _pendingKey = newRequestKey();
    }
    busy = true;
    error = '';
    _update();
    try {
      final content = await session.send(text, _pendingKey);
      _messages[content.id] = content;
      _pendingKey = '';
      _pendingText = '';
      return true;
    } catch (e) {
      error =
          '${_explain(e)} Повтор с тем же текстом использует прежний ключ запроса.';
      return false;
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> revoke() async {
    if (busy || _session == null) return;
    busy = true;
    _timer?.cancel();
    _update();
    try {
      await _session!.revoke();
      connected = false;
      error = 'Доступ этого устройства отозван. Ключи сохранены; новый grant автоматически не создаётся.';
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    unawaited(_session?.close());
    super.dispose();
  }
}
