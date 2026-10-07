import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import 'core.dart';
import 'generated/space/v1/space.pb.dart';

class ChatController extends ChangeNotifier {
  ChatController(
    this.vault, {
    this.openSession = SpaceSession.connect,
    this.retryDelay = defaultRetryDelay,
  });
  final IdentityVault vault;
  Discovery? preview;
  LiveSession? _session;
  StreamIterator<SubscribeResponse>? _activeIterator;
  final Future<LiveSession> Function(Discovery, IdentityVault) openSession;
  final Duration Function(int) retryDelay;
  Timer? _retryTimer;
  Completer<void>? _retryDone;
  int _generation = 0;
  bool reconnecting = false;
  static Duration defaultRetryDelay(int attempt) =>
      Duration(seconds: 1 << (attempt > 5 ? 5 : attempt));
  bool busy = false, connected = false, _disposed = false;
  String error = '',
      fingerprint = '',
      cursor = '',
      _pendingText = '',
      _pendingKey = '';
  final Map<String, Content> _messages = {};
  List<Content> get messages => _messages.values.toList();
  String _invitationToken = '', invitationRole = '';
  bool get canWrite =>
      _session is SpaceAccess ? (_session as SpaceAccess).canWrite : connected;
  String get principalId => _session?.principalId ?? '';
  DeviceManagement? get deviceManagement =>
      _session is DeviceManagement ? _session as DeviceManagement : null;
  String get spaceTitle => _session is SpacePresentation
      ? (_session as SpacePresentation).spaceTitle
      : '';
  String get chatTitle => _session is SpacePresentation
      ? (_session as SpacePresentation).chatTitle
      : 'Общий чат';
  void _update() {
    if (!_disposed) notifyListeners();
  }

  String _explain(Object problem) {
    if (problem is GrpcError && problem.code == StatusCode.permissionDenied) {
      return 'Недостаточно прав: доступ заблокирован, приглашение недействительно или роль разрешает только чтение.';
    }
    if (problem is FormatException) return problem.message.toString();
    if (problem is GrpcError && problem.code == StatusCode.unauthenticated) {
      return 'Устройство отозвано или разрешение истекло. Автоматическая перерегистрация отключена.';
    }
    if (problem is GrpcError && problem.code == StatusCode.resourceExhausted) {
      return 'Достигнут лимит сервера.';
    }
    return 'Не удалось выполнить операцию. Проверьте сервер, соединение и доступ к хранилищу ключей.';
  }

  Future<void> inspect(String address, {String invitationToken = ''}) async {
    if (busy) return;
    busy = true;
    error = '';
    preview = null;
    _invitationToken = '';
    invitationRole = '';
    _update();
    try {
      final server = await discover(address);
      final saved = await vault.load(server.origin.toString());
      if (saved != null) checkTrust(server, saved);
      fingerprint = await server.fingerprint();
      final invite = invitationToken.trim();
      if (invite.isNotEmpty) {
        final result = await SpaceSession.previewInvitation(server, invite);
        _invitationToken = invite;
        invitationRole = result.role;
      }
      preview = server;
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> connect({DeviceRecord? restoredRecord}) async {
    final server = preview;
    if (busy || server == null) return;
    busy = true;
    error = '';
    _stopSubscription();
    connected = false;
    _update();
    try {
      await _session?.close();
      _session = null;
      final session = _invitationToken.isEmpty && restoredRecord == null
          ? await openSession(server, vault)
          : await SpaceSession.connect(
              server,
              vault,
              invitationToken: _invitationToken,
              restoredRecord: restoredRecord,
            );
      if (_disposed) {
        await session.close();
        return;
      }
      _session = session;
      _invitationToken = '';
      final initial = await session.messages();
      _messages.clear();
      for (final message in initial) {
        _messages[message.id] = message;
      }
      cursor = '';
      connected = true;
      unawaited(_watch(session, ++_generation));
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  bool _current(LiveSession session, int generation) =>
      !_disposed && _session == session && _generation == generation;
  void _stopSubscription() {
    _generation++;
    _retryTimer?.cancel();
    if (_retryDone != null && !_retryDone!.isCompleted) _retryDone!.complete();
    reconnecting = false;
    final iterator = _activeIterator;
    _activeIterator = null;
    if (iterator != null) unawaited(_cancelIterator(iterator));
  }

  Future<void> _cancelIterator(
    StreamIterator<SubscribeResponse> iterator,
  ) async {
    try {
      await iterator.cancel();
    } catch (_) {}
  }

  Future<void> _pause(int attempt) async {
    final done = Completer<void>();
    _retryDone = done;
    _retryTimer = Timer(retryDelay(attempt), () => done.complete());
    await done.future;
  }

  Future<void> _watch(LiveSession session, int generation) async {
    var attempt = 0;
    while (_current(session, generation)) {
      final started = DateTime.now();
      final iterator = StreamIterator(session.subscribe(cursor));
      _activeIterator = iterator;
      try {
        while (await iterator.moveNext()) {
          final frame = iterator.current;
          if (!_current(session, generation)) return;
          if (frame.heartbeat) {
            if (frame.hasEvent() || frame.cursor != cursor) {
              throw const FormatException('Heartbeat содержит неверный курсор');
            }
          } else {
            if (!frame.hasEvent() ||
                frame.event.type != 'content.created' ||
                !frame.event.hasContent() ||
                frame.event.content.channelId != 'general' ||
                frame.event.content.id.isEmpty ||
                frame.cursor.isEmpty ||
                frame.event.cursor != frame.cursor) {
              throw const FormatException('Неподдерживаемое событие потока');
            }
            _messages[frame.event.content.id] = frame.event.content;
            cursor = frame.cursor;
          }
          reconnecting = false;
          if (DateTime.now().difference(started) >
              const Duration(seconds: 20)) {
            attempt = 0;
          }
          _update();
        }
      } catch (problem) {
        if (!_current(session, generation)) return;
        if (problem is GrpcError &&
            problem.code == StatusCode.unauthenticated) {
          try {
            await session.login();
          } catch (loginError) {
            if (!_current(session, generation)) return;
            if (_terminal(loginError)) {
              connected = false;
              error = _explain(loginError);
              _update();
              return;
            }
          }
        } else if (_terminal(problem)) {
          connected = false;
          error =
              problem is GrpcError && problem.code == StatusCode.unimplemented
              ? 'Сервер пока не поддерживает подписку событий. Обновите сервер.'
              : problem is GrpcError &&
                    problem.code == StatusCode.invalidArgument
              ? 'Сервер не принял курсор истории. Подключитесь заново для загрузки сообщений.'
              : _explain(problem);
          _update();
          return;
        }
      } finally {
        if (identical(_activeIterator, iterator)) _activeIterator = null;
        await _cancelIterator(iterator);
      }
      if (!_current(session, generation)) return;
      reconnecting = true;
      _update();
      await _pause(attempt);
      if (attempt < 5) attempt++;
    }
  }

  bool _terminal(Object problem) =>
      problem is FormatException ||
      problem is GrpcError &&
          [
            StatusCode.unauthenticated,
            StatusCode.permissionDenied,
            StatusCode.invalidArgument,
            StatusCode.unimplemented,
            StatusCode.notFound,
          ].contains(problem.code);
  Future<bool> send(String text) async {
    final session = _session;
    if (busy ||
        !connected ||
        !canWrite ||
        session == null ||
        text.trim().isEmpty) {
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
    _stopSubscription();
    _update();
    try {
      await _session!.revoke();
      connected = false;
      error = 'Доступ этого устройства отозван. Ключи сохранены; новый grant автоматически не создаётся.';
    } catch (e) {
      error = _explain(e);
      if (_session != null && connected) {
        unawaited(_watch(_session!, ++_generation));
      }
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> disconnect() async {
    if (busy) return;
    busy = true;
    connected = false;
    _stopSubscription();
    _update();
    try {
      await _session?.close();
      _session = null;
      preview = null;
      fingerprint = '';
      cursor = '';
      _messages.clear();
      _pendingKey = '';
      _pendingText = '';
      error = '';
    } finally {
      busy = false;
      _update();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _stopSubscription();
    unawaited(_session?.close());
    super.dispose();
  }
}
