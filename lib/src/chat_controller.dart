import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import 'core.dart';
import 'channel_positions.dart';
import 'generated/space/v1/space.pb.dart';

class ChatController extends ChangeNotifier {
  ChatController(
    this.vault, {
    this.openSession = SpaceSession.connect,
    this.retryDelay = defaultRetryDelay,
    ChannelPositionStore? positions,
  }) : positions = positions ?? LocalChannelPositions();
  final ChannelPositionStore positions;
  Timer? _positionTimer;
  void _queuePositions() {
    _positionTimer?.cancel();
    _positionTimer = Timer(
      const Duration(milliseconds: 250),
      () => unawaited(_savePositions()),
    );
  }

  final Map<String, String> _cursors = {}, _readThrough = {};
  ChannelNavigation? get navigation =>
      _session is ChannelNavigation ? _session as ChannelNavigation : null;
  List<Channel> get channels => navigation?.availableChannels ?? [];
  String get channelId => navigation?.selectedChannelId ?? 'general';
  bool get canRead => navigation?.canRead ?? connected;
  String get readThrough => _readThrough[channelId] ?? '';
  String get draftScope =>
      '${preview?.origin}|${preview?.serverId}|$principalId|$channelId';

  Future<void> _loadPositions() async {
    final nav = navigation;
    _cursors.clear();
    _readThrough.clear();
    if (nav == null) return;
    try {
      final data = await positions.load(nav.positionScope);
      final savedChannels = data['channels'];
      for (final entry in channels) {
        final item = savedChannels is Map ? savedChannels[entry.id] : null;
        if (item is Map) {
          if (item['cursor'] is String &&
              (item['cursor'] as String).length <= 128) {
            _cursors[entry.id] = item['cursor'];
          }
          if (item['readThrough'] is String &&
              (item['readThrough'] as String).length <= 128) {
            _readThrough[entry.id] = item['readThrough'];
          }
        }
      }
      final selected = data['selected'];
      if (selected is String && channels.any((c) => c.id == selected)) {
        nav.selectChannel(selected);
      }
    } catch (_) {
      error = 'Не удалось загрузить позиции чтения. История будет загружена заново.';
    }
  }

  Future<void> _savePositions() async {
    final nav = navigation;
    if (nav == null) return;
    final channelData = <String, dynamic>{};
    for (final c in channels) {
      channelData[c.id] = {
        'cursor': _cursors[c.id] ?? '',
        'readThrough': _readThrough[c.id] ?? '',
      };
    }
    try {
      await positions.save(nav.positionScope, {
        'selected': channelId,
        'channels': channelData,
      });
    } catch (_) {
      error =
          'Позиция чтения обновлена, но сохранить её на устройстве не удалось.';
      _update();
    }
  }

  void markRead(String id) {
    if (!canRead || id.isEmpty || _readThrough[channelId] == id) return;
    _readThrough[channelId] = id;
    _queuePositions();
  }

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

  Future<void> connect({
    DeviceRecord? restoredRecord,
    String pairingId = '',
  }) async {
    final server = preview;
    if (busy || server == null) return;
    busy = true;
    error = '';
    _stopSubscription();
    connected = false;
    _messages.clear();
    _pendingKey = '';
    _pendingText = '';
    _update();
    try {
      _positionTimer?.cancel();
      await _savePositions();
      await _session?.close();
      _session = null;
      final session = _invitationToken.isEmpty && restoredRecord == null
          ? await openSession(server, vault)
          : await SpaceSession.connect(
              server,
              vault,
              invitationToken: pairingId.isEmpty ? _invitationToken : '',
              restoredRecord: restoredRecord,
              pairingId: pairingId,
            );
      if (_disposed) {
        await session.close();
        return;
      }
      _session = session;
      _invitationToken = '';
      await _loadPositions();
      final initial = await session.messages();
      _messages.clear();
      for (final message in initial) {
        if (navigation != null && message.channelId != channelId) {
          throw const FormatException('История другого канала');
        }
        _messages[message.id] = message;
      }
      cursor = _cursors[channelId] ?? '';
      connected = true;
      if (canRead) unawaited(_watch(session, ++_generation));
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> selectChannel(String id) async {
    final nav = navigation;
    final session = _session;
    if (busy || nav == null || session == null) return;
    busy = true;
    error = '';
    _stopSubscription();
    _messages.clear();
    cursor = '';
    _pendingText = '';
    _pendingKey = '';
    _update();
    try {
      await nav.refreshChannels();
      final nextId = id.isEmpty ? nav.selectedChannelId : id;
      if (nextId.isEmpty) {
        connected = true;
        return;
      }
      nav.selectChannel(nextId);
      cursor = _cursors[nextId] ?? '';
      final initial = await session.messages();
      if (_disposed) return;
      for (final m in initial) {
        if (m.channelId != nextId) {
          throw const FormatException('История другого канала');
        }
        _messages[m.id] = m;
      }
      connected = true;
      await _savePositions();
      if (canRead) unawaited(_watch(session, ++_generation));
    } catch (e) {
      _messages.clear();
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> refreshChannels() async {
    final nav = navigation;
    if (busy || nav == null) return;
    busy = true;
    error = '';
    _update();
    try {
      await nav.refreshChannels();
      if (!canRead) {
        _stopSubscription();
        _messages.clear();
      }
    } catch (e) {
      _stopSubscription();
      _messages.clear();
      connected = false;
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<bool> _channelDenied(Object problem) async {
    final nav = navigation;
    if (nav == null ||
        problem is! GrpcError ||
        ![
          StatusCode.permissionDenied,
          StatusCode.notFound,
        ].contains(problem.code)) {
      return false;
    }
    final generation = _generation;
    try {
      await nav.refreshChannels();
      if (_disposed || generation != _generation) return true;
      if (!canRead) {
        _messages.clear();
        _pendingText = '';
        _pendingKey = '';
        cursor = '';
      }
      error = canRead
          ? 'Права канала изменились. Обновите чат перед повтором.'
          : 'Доступ к этому каналу изменён. Выберите доступный чат.';
    } catch (e) {
      if (_disposed || generation != _generation) return true;
      _messages.clear();
      connected = false;
      error = _explain(e);
    }
    _update();
    return true;
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
    final watchedChannel = channelId;
    var attempt = 0;
    while (_current(session, generation)) {
      final started = DateTime.now();
      final iterator = StreamIterator(session.subscribe(cursor));
      _activeIterator = iterator;
      try {
        while (await iterator.moveNext()) {
          final frame = iterator.current;
          if (!_current(session, generation)) return;
          if (navigation != null && (!canRead || channelId != watchedChannel)) {
            _messages.clear();
            error = 'Канал больше не доступен для чтения.';
            _update();
            return;
          }
          if (frame.heartbeat) {
            if (frame.hasEvent() || frame.cursor != cursor) {
              throw const FormatException('Heartbeat содержит неверный курсор');
            }
            if (!canRead || channelId != watchedChannel) {
              _messages.clear();
              error = 'Канал больше не доступен для чтения.';
              _update();
              return;
            }
          } else {
            if (!frame.hasEvent() ||
                frame.event.type != 'content.created' ||
                !frame.event.hasContent() ||
                frame.event.content.channelId != watchedChannel ||
                frame.event.content.id.isEmpty ||
                frame.cursor.isEmpty ||
                frame.event.cursor != frame.cursor) {
              throw const FormatException('Неподдерживаемое событие потока');
            }
            _messages[frame.event.content.id] = frame.event.content;
            cursor = frame.cursor;
            _cursors[watchedChannel] = cursor;
            _queuePositions();
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
        if (await _channelDenied(problem)) return;
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
          if (problem is GrpcError &&
              problem.code == StatusCode.invalidArgument) {
            _cursors.remove(watchedChannel);
            cursor = '';
            await _savePositions();
          }
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
      if (navigation != null && content.channelId != channelId) {
        throw const FormatException('Ответ другого канала');
      }
      _messages[content.id] = content;
      _pendingKey = '';
      _pendingText = '';
      return true;
    } catch (e) {
      if (await _channelDenied(e)) return false;
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
      _positionTimer?.cancel();
      await _savePositions();
      await _session?.close();
      _session = null;
      preview = null;
      fingerprint = '';
      cursor = '';
      _messages.clear();
      _pendingKey = '';
      _pendingText = '';
      _cursors.clear();
      _readThrough.clear();
      error = '';
    } finally {
      busy = false;
      _update();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _positionTimer?.cancel();
    unawaited(_savePositions());
    _stopSubscription();
    unawaited(_session?.close());
    super.dispose();
  }
}
