import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show VoidCallback, listEquals;
import 'package:grpc/grpc.dart';

import 'channel_positions.dart';
import 'chat_history.dart';
import 'chat_outbox.dart';
import 'attachments.dart';
import 'queued_file_store.dart';
import 'queued_file.dart';
import 'queued_mutation.dart';
import 'queued_mutation_projection.dart';

import 'package:file_selector/file_selector.dart';

import 'core.dart';
import 'message_search.dart';
import 'history_pages.dart';
import 'event_controller.dart';
import 'generated/space/v1/space.pb.dart';
import 'local_failure.dart';

part 'chat_events.dart';
part 'chat_state.dart';
part 'chat_outbox_controller.dart';
part 'chat_outbox_files.dart';
part 'chat_outbox_recovery.dart';
part 'chat_outbox_mutations.dart';
part 'chat_replies.dart';
part 'chat_history_pages.dart';

enum MessageSendStatus { idle, sending, unconfirmed, accepted, queued }

class ChatController extends EventController<ChatEvent<dynamic>, ChatState> {
  ChatController(
    this.vault, {
    this.openSession = SpaceSession.connect,
    this.retryDelay = defaultRetryDelay,
    ChannelPositionStore? positions,
    ChatHistoryStore? historyStore,
    ChatOutboxStore? outboxStore,
    QueuedFileStore? fileStore,
    DateTime Function()? now,
  }) : positions = positions ?? LocalChannelPositions(),
       historyStore = historyStore ?? LocalChatHistory(),
       outboxStore = outboxStore ?? LocalChatOutbox(),
       fileStore = fileStore ?? QueuedFileStore(),
       now = now ?? DateTime.now,
       super(const ChatState()) {
    on<ChatFrameReceived>(
      (event, _) => handleRequest(event, () => _receiveFrame(event)),
    );
    on<ChatCatalogFailed>(
      (event, _) => handleRequest(
        event,
        () => _recoverCatalog(event.session, event.generation, event.error),
      ),
    );
    on<ChatCatalogChanged>(
      (event, _) => handleRequest(
        event,
        () => _catalogChanged(event.session, event.generation),
      ),
    );
    on<ChatStatePublished>(
      (event, emit) => event.runAndComplete(() => emit(event.state)),
    );
    on<ChatHistoryRestored>(
      (event, _) => handleRequest(event, () => _restoreHistory(event.origin)),
    );
    on<ChatHistoryFlushed>((event, _) => handleRequest(event, _flushHistory));
    on<ChatOfflineDataCleared>(
      (event, _) =>
          handleRequest(event, () => _clearOfflineData(eraseOutbox: true)),
    );
    on<ChatFavoriteToggled>(
      (event, _) => handleRequest(event, () => _toggleFavorite(event.message)),
    );
    on<ChatSearchMessageRevealed>(
      (event, _) => handleRequest(event, () async {
        if (!identical(_session, event.session) ||
            !connected ||
            !canRead ||
            encryptedChannel ||
            event.message.channelId != channelId) {
          return;
        }
        _mergeMessage(event.message);
        publishState();
      }),
    );
    on<ChatOlderHistoryRequested>(
      (event, _) => handleRequest(event, _loadOlderHistory),
    );
    on<ChatReadMarked>(
      (event, _) => handleRequest(event, () => _markRead(event.id)),
    );
    on<ChatInspected>(
      (event, _) => handleRequest(
        event,
        () => _inspect(
          event.address,
          invitationToken: event.invitationToken,
          homeOrigin: event.homeOrigin,
          tlsFingerprint: event.tlsFingerprint,
          savedRecord: event.savedRecord,
        ),
      ),
    );
    on<ChatConnected>(
      (event, _) => handleRequest(
        event,
        () => _connect(
          restoredRecord: event.restoredRecord,
          pairingId: event.pairingId,
          setupCode: event.setupCode,
          nickname: event.nickname,
        ),
      ),
    );
    on<ChatChannelSelected>(
      (event, _) => handleRequest(event, () => _selectChannel(event.id)),
    );
    on<ChatChannelsRefreshed>(
      (event, _) => handleRequest(event, _refreshChannels),
    );
    on<ChatMessageSent>(
      (event, _) => handleRequest(
        event,
        () => _send(event.text, event.attachments, event.files, event.replyTo),
      ),
    );
    on<ChatReactionSet>(
      (event, _) => handleRequest(event, () => _setReaction(event)),
    );
    on<ChatMessageChanged>(
      (event, _) =>
          handleRequest(event, () => _changeMessage(event.message, event.text)),
    );
    on<ChatDeviceRevoked>((event, _) => handleRequest(event, _revoke));
    on<ChatDisconnected>((event, _) => handleRequest(event, _disconnect));
    on<ChatOutboxChanged>(
      (event, _) => handleRequest(event, () => _changePending(event)),
    );
    on<ChatOutboxRecovered>(
      (event, _) => handleRequest(event, () => _recoverOutbox(event)),
    );
  }

  Future<void> restoreHistory(String origin) =>
      sendRequest(ChatHistoryRestored(origin));
  Future<void> flushHistory() => sendRequest(ChatHistoryFlushed());
  Future<void> clearOfflineData() => sendRequest(ChatOfflineDataCleared());
  Future<void> toggleFavorite(Content message) =>
      sendRequest(ChatFavoriteToggled(message));
  Future<void> markRead(String id) => sendRequest(ChatReadMarked(id));
  Future<void> inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
    DeviceRecord? savedRecord,
  }) => sendRequest(
    ChatInspected(
      address,
      invitationToken: invitationToken,
      homeOrigin: homeOrigin,
      tlsFingerprint: tlsFingerprint,
      savedRecord: savedRecord,
    ),
  );
  Future<void> connect({
    DeviceRecord? restoredRecord,
    String pairingId = '',
    String setupCode = '',
    String? nickname,
  }) => sendRequest(
    ChatConnected(
      restoredRecord: restoredRecord,
      pairingId: pairingId,
      setupCode: setupCode,
      nickname: nickname,
    ),
  );
  Future<void> selectChannel(String id) => sendRequest(ChatChannelSelected(id));
  Future<void> refreshChannels() => sendRequest(ChatChannelsRefreshed());
  Future<bool> send(
    String text, {
    List<String> attachments = const [],
    List<XFile> files = const [],
    String replyTo = '',
  }) => sendRequest(
    ChatMessageSent(
      text,
      List.unmodifiable(attachments),
      List.unmodifiable(files),
      replyTo,
    ),
  );
  MessageSearchSession? get messageSearch =>
      connected && _session is MessageSearchSession
      ? _session as MessageSearchSession
      : null;
  Future<void> revealSearchMessage(Content message) =>
      sendRequest(ChatSearchMessageRevealed(message, _session));
  SpaceSession? get mlsSession =>
      _session is SpaceSession ? _session as SpaceSession : null;
  bool get encryptedChannel =>
      channels.any((c) => c.id == channelId && c.mlsGroupId.isNotEmpty);
  MemberProfile? get memberProfile =>
      connected && _session is MemberProfile ? _session as MemberProfile : null;
  AttachmentSession? get attachmentSession =>
      !encryptedChannel && attachmentsEnabled && _session is AttachmentSession
      ? _session as AttachmentSession
      : null;
  bool get attachmentsEnabled => _session == null
      ? _history?.attachmentsEnabled ?? true
      : _session is! AttachmentPolicy ||
            (_session as AttachmentPolicy).attachmentsEnabled;
  bool get canAttachFiles =>
      attachmentSession != null ||
      _session == null &&
          !accessRemoved &&
          !encryptedChannel &&
          attachmentsEnabled &&
          _outboxScope != null &&
          _outboxScope!.origin == knownOrigin;
  bool get repliesSupported => _session == null
      ? _history?.repliesSupported ?? false
      : _session is ReplyMessageSession &&
            (_session as ReplyMessageSession).repliesSupported;
  bool canReplyTo(Content message) =>
      canQueue &&
      canRead &&
      repliesSupported &&
      !encryptedChannel &&
      !message.deleted &&
      message.channelId == channelId &&
      message.id.isNotEmpty &&
      message.sequence > 0;
  bool get canQueueFiles => canQueue && canAttachFiles;
  bool get canReact =>
      _canQueueMutation ||
      connected && canWrite && !busy && _session is MessageReactions;
  Future<bool> setReaction(Content message, String emoji, bool active) =>
      sendRequest(ChatReactionSet(message, emoji, active));
  Future<bool> _setReaction(ChatReactionSet event) async {
    if (_canQueueMutation) {
      return _enqueueMutation(
        event.message,
        MutationKind.reaction,
        emoji: event.emoji,
        active: event.active,
      );
    }
    final session = _session;
    if (!canReact ||
        session is! MessageReactions ||
        event.message.deleted ||
        event.message.channelId != channelId) {
      return false;
    }
    final generation = _generation;
    busy = true;
    error = '';
    _update();
    try {
      final result = await (session as MessageReactions).setReaction(
        event.message,
        event.emoji,
        event.active,
      );
      if (!_current(session!, generation)) return false;
      if (result.id != event.message.id ||
          result.channelId != channelId ||
          result.revision < event.message.revision) {
        throw const FormatException('Неверный ответ реакции');
      }
      _mergeMessage(result);
      _captureHistory();
      await _flushHistory();
      return true;
    } catch (problem) {
      if (identical(session, _session)) error = _explain(problem);
      return false;
    } finally {
      busy = false;
      _update();
    }
  }

  Future<bool> updateMessage(Content message, String text) =>
      sendRequest(ChatMessageChanged(message, text));
  Future<bool> deleteMessage(Content message) =>
      sendRequest(ChatMessageChanged(message, null));
  bool canChangeMessage(Content message) =>
      (_canQueueMutation || canWrite && _session is MessageChanges) &&
      !busy &&
      !message.deleted &&
      message.revision > 0 &&
      message.authorId == principalId &&
      message.channelId == channelId;

  Future<void> revoke() => sendRequest(ChatDeviceRevoked());
  Future<void> disconnect() => sendRequest(ChatDisconnected());

  final ChatHistoryStore historyStore;
  final DateTime Function() now;
  ChatHistory? _history;
  String? _historyOrigin;
  String? _sessionOrigin;
  String _sessionServerId = '';
  Timer? _historyTimer;
  bool accessRemoved = false;
  String cacheError = '';
  String get knownOrigin => preview?.origin.toString() ?? _historyOrigin ?? '';
  bool get hasOfflineHistory {
    _history?.prune(now());
    return !accessRemoved && _history?.entries.isNotEmpty == true;
  }

  Content? get latestKnownMessage {
    _history?.prune(now());
    return _history?.latest;
  }

  Future<void> _restoreHistory(String origin) async {
    if (accessRemoved || _historyOrigin == origin && _history != null) return;
    try {
      final saved = await historyStore.read(origin);
      if (saved == null || _disposed) return;
      final record = await vault.load(origin);
      await _rememberPreviousQueue(origin, saved, record);
      if (record == null ||
          record.serverId != saved.serverId ||
          record.grantId != saved.grantId ||
          (await record.identity()).principalId != saved.principalId) {
        await historyStore.delete(origin);
        return;
      }
      if (_disposed) return;
      _history = saved;
      _historyOrigin = origin;
      await _loadOutbox(
        OutboxScope(origin, saved.serverId, saved.principalId, saved.grantId),
      );
      _readSequences.addAll(saved.readSequences);
      await historyStore.write(origin, saved);
      _update();
    } catch (_) {
      cacheError = 'История недоступна';
    }
  }

  void _captureHistory() {
    final session = _session;
    final origin = _sessionOrigin;
    final nav = navigation;
    if (_history != null &&
        nav != null &&
        origin == _historyOrigin &&
        !accessRemoved) {
      _history!.channels = nav.availableChannels
          .map((c) => Channel()..mergeFromProto3Json(c.toProto3Json()))
          .toList();
      _history!.merge(const [], now());
      if (!connected) {
        _queueHistoryFlush();
      }
    }
    if (!connected || session == null || origin == null || accessRemoved) {
      return;
    }
    final grant = deviceManagement?.currentGrantId ?? '';
    if (_history?.serverId != _sessionServerId ||
        _history?.principalId != session.principalId ||
        _history?.grantId != grant) {
      _history = ChatHistory(
        serverId: _sessionServerId,
        principalId: session.principalId,
        grantId: grant,
      );
    }
    _historyOrigin = origin;
    final saved = _history!;
    saved.title = spaceTitle;
    saved.attachmentsEnabled =
        session is AttachmentSession && attachmentsEnabled;
    saved.repliesSupported = repliesSupported;
    saved.channels = channels
        .map((c) => Channel()..mergeFromProto3Json(c.toProto3Json()))
        .toList();
    if (nav == null && saved.channels.isEmpty && _messages.isNotEmpty) {
      saved.channels = [
        Channel(
          id: channelId,
          title: chatTitle,
          permissions: ChannelPermissions(read: true, write: canWrite),
        ),
      ];
    }
    saved.selected = channelId;
    saved.readSequences = Map.of(_readSequences);
    saved.merge(_messages.values, now());
    if (_pagedHistory) saved.eventCursors[channelId] = cursor;
    _queueHistoryFlush();
  }

  void _queueHistoryFlush() {
    _historyTimer?.cancel();
    _historyTimer = Timer(
      const Duration(milliseconds: 500),
      () => unawaited(_flushHistory()),
    );
  }

  Future<void> _flushHistory() async {
    _historyTimer?.cancel();
    final saved = _history;
    final origin = _historyOrigin;
    if (accessRemoved || saved == null || origin == null) return;
    try {
      await historyStore.write(origin, saved);
      cacheError = '';
    } catch (_) {
      cacheError = 'История не сохранена';
    }
  }

  Future<void> _clearOfflineData({bool eraseOutbox = false}) async {
    final origin = knownOrigin;
    final oldScope = _outboxScope;
    _stopOutbox();
    _pendingMessages = const [];
    accessRemoved = true;
    _historyTimer?.cancel();
    _history = null;
    _messages.clear();
    _cursors.clear();
    _readThrough.clear();
    _readSequences.clear();
    _pendingText = '';
    _pendingKey = '';
    _stopCatalog();
    _stopSubscription();
    connected = false;
    _update();
    if (origin.isNotEmpty) await historyStore.delete(origin);
    if (eraseOutbox && oldScope != null) {
      await outboxStore.change(oldScope, (_) => []);
      await fileStore.clear(oldScope);
    }
  }

  bool _accessDenied(Object problem) =>
      problem is GrpcError &&
      [
        StatusCode.unauthenticated,
        StatusCode.permissionDenied,
      ].contains(problem.code);
  Future<void> _rejectAccess(Object problem) async {
    if (!_accessDenied(problem)) return;
    try {
      await _clearOfflineData();
    } catch (_) {
      cacheError = 'История не удалена';
    }
  }

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
  final Map<String, int> _readSequences = {};
  ChannelNavigation? get navigation =>
      _session is ChannelNavigation ? _session as ChannelNavigation : null;
  List<Channel> get channels => accessRemoved
      ? []
      : navigation?.availableChannels ?? _history?.channels ?? [];
  String get channelId =>
      navigation?.selectedChannelId ?? _history?.selected ?? 'general';
  bool get canRead =>
      !accessRemoved &&
      (navigation?.canRead ??
          (_history?.channels.any(
                    (c) => c.id == channelId && c.permissions.read,
                  ) ==
                  true ||
              connected));
  int readSequence(String id) {
    final saved = _readSequences[id] ?? _history?.readSequences[id] ?? 0;
    if (saved > 0 || id != channelId) return saved;
    return messages
            .where((m) => m.id == (_readThrough[id] ?? ''))
            .firstOrNull
            ?.sequence
            .toInt() ??
        0;
  }

  int unreadCount(String id) {
    final entry = channels.where((c) => c.id == id).firstOrNull;
    if (entry?.permissions.read != true) return 0;
    if (!connected) {
      return _history
              ?.messages(id, now())
              .where((m) => m.sequence.toInt() > readSequence(id))
              .length ??
          0;
    }
    final latest = _latestSequence(id, entry!.latestMessageSequence.toInt());
    if (id != channelId &&
        (_readThrough[id] ?? '').isNotEmpty &&
        readSequence(id) == 0) {
      return 0;
    }
    if (latest > 0) return (latest - readSequence(id)).clamp(0, latest);
    // Старые серверы: только известные загруженные сообщения, без счётчика других каналов.
    if (id != channelId) return 0;
    final index = messages.indexWhere((m) => m.id == (_readThrough[id] ?? ''));
    return messages.length - index - 1;
  }

  int _latestSequence(String id, int latest) {
    if (id == channelId) {
      for (final message in messages) {
        if (message.sequence.toInt() > latest) {
          latest = message.sequence.toInt();
        }
      }
    }
    return latest;
  }

  String get readThrough => _readThrough[channelId] ?? '';
  String get draftScope =>
      '$knownOrigin|${preview?.serverId ?? _history?.serverId}|$principalId|$channelId';

  bool isFavorite(Content message) =>
      _historyOrigin == knownOrigin &&
      _history?.favorites.contains('${message.channelId}/${message.id}') ==
          true;

  Future<void> _toggleFavorite(Content message) async {
    if (accessRemoved ||
        !canRead ||
        message.deleted ||
        message.channelId != channelId ||
        !messages.any((value) => value.id == message.id)) {
      return;
    }
    _captureHistory();
    final saved = _history;
    if (saved == null || _historyOrigin != knownOrigin) return;
    final key = '${message.channelId}/${message.id}';
    saved.entries.putIfAbsent(
      key,
      () => CachedMessage(
        Content()..mergeFromProto3Json(message.toProto3Json()),
        now().millisecondsSinceEpoch,
      ),
    );
    if (!saved.favorites.remove(key)) saved.favorites.add(key);
    publishState();
    await _flushHistory();
    if (!_disposed) publishState();
  }

  Future<void> _loadPositions() async {
    final nav = navigation;
    _cursors.clear();
    _readThrough.clear();
    _readSequences.clear();
    if (nav == null) return;
    try {
      final data = await positions.load(nav.positionScope);
      final savedChannels = data['channels'];
      for (final entry in channels) {
        final item = savedChannels is Map ? savedChannels[entry.id] : null;
        _restoreChannelPosition(entry.id, item);
      }
      final selected = data['selected'];
      if (selected is String && channels.any((c) => c.id == selected)) {
        nav.selectChannel(selected);
      }
    } catch (_) {
      error = _explain(
        const LocalFailure(
          LocalFailureCode.positionsLoad,
          'Не удалось загрузить позиции чтения. История будет загружена заново.',
        ),
      );
    }
  }

  void _restoreChannelPosition(String id, dynamic item) {
    if (item is Map) {
      if (item['cursor'] is String &&
          (item['cursor'] as String).length <= 128) {
        _cursors[id] = item['cursor'];
      }
      if (item['readSequence'] is int && item['readSequence'] >= 0) {
        _readSequences[id] = item['readSequence'];
      }
      if (item['readThrough'] is String &&
          (item['readThrough'] as String).length <= 128) {
        _readThrough[id] = item['readThrough'];
      }
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
        'readSequence': readSequence(c.id),
      };
    }
    try {
      await positions.save(nav.positionScope, {
        'selected': channelId,
        'channels': channelData,
      });
    } catch (_) {
      error = _explain(
        const LocalFailure(
          LocalFailureCode.positionsSave,
          'Позиция чтения обновлена, но сохранить её на устройстве не удалось.',
        ),
      );
      _update();
    }
  }

  void _markRead(String id) {
    if (!canRead || id.isEmpty || _readThrough[channelId] == id) return;
    final list = messages;
    final index = list.indexWhere((m) => m.id == id);
    if (index < 0) return;
    final previousIndex = list.indexWhere((m) => m.id == readThrough);
    final sequence = list[index].sequence.toInt();
    if (sequence > 0 && sequence < readSequence(channelId)) return;
    if (sequence == 0 && previousIndex > index) return;
    _readThrough[channelId] = id;
    if (sequence > 0) _readSequences[channelId] = sequence;
    if (_history != null) {
      _history!.readSequences = {..._history!.readSequences, ..._readSequences};
      _queueHistoryFlush();
    }
    _queuePositions();
    publishState();
  }

  final ChatOutboxStore outboxStore;
  final QueuedFileStore fileStore;
  final _activeFileUploads = <String, AttachmentQueue>{};
  OutboxScope? _outboxScope;
  List<PendingMessage> _pendingMessages = const [];
  List<OutboxScope> _outboxSources = const [];
  bool _outboxRecovering = false;
  List<OutboxScope> get outboxSources => connected && !accessRemoved
      ? List.unmodifiable(_outboxSources)
      : const [];
  String get outboxRecoveryTarget => _outboxScope?.id ?? '';
  Future<bool> recoverOutbox(
    OutboxScope source,
    String target, {
    required String snapshot,
  }) => sendRequest(ChatOutboxRecovered(source, target, snapshot));
  String outboxError = '';
  int _outboxEpoch = 0, _outboxAttempt = 0;
  Future<void>? _outboxDrain;
  bool _outboxWakeRequested = false;
  Timer? _outboxTimer;
  List<PendingMessage> get pendingMessages =>
      accessRemoved ? const [] : List.unmodifiable(_pendingMessages);
  bool get canQueue => _canQueueMessage;
  Future<void> retryPending(String key) => sendRequest(ChatOutboxChanged(key));
  Future<void> discardPending(String key) =>
      sendRequest(ChatOutboxChanged(key, discard: true));

  final IdentityVault vault;
  Discovery? preview;
  LiveSession? _session;
  StreamIterator<SubscribeResponse>? _activeIterator;
  StreamIterator<void>? _catalogIterator;
  int _catalogGeneration = 0;
  Timer? _catalogRetryTimer;
  Completer<void>? _catalogRetryDone;
  final Future<LiveSession> Function(Discovery, IdentityVault) openSession;
  final Duration Function(int) retryDelay;
  Timer? _retryTimer;
  Completer<void>? _retryDone;
  int _generation = 0;
  bool reconnecting = false;
  static Duration defaultRetryDelay(int attempt) =>
      Duration(seconds: 1 << (attempt > 5 ? 5 : attempt));
  final _historyChanges = <String, Content>{};
  bool _historyChangesOverflow = false;
  int _historyEpoch = 0, _historyFloor = 0, _historyNextBefore = 0;
  bool _pagedHistory = false, historyLoading = false;
  String historyError = '';
  bool get hasOlderHistory =>
      connected && canRead && !encryptedChannel && _historyNextBefore > 0;
  int get historyGeneration => _historyEpoch;
  Future<void> loadOlderHistory() => sendRequest(ChatOlderHistoryRequested());
  bool busy = false, connected = false, _disposed = false;
  String error = '',
      fingerprint = '',
      cursor = '',
      _pendingText = '',
      _pendingKey = '';
  final Map<String, Content> _messages = {};
  List<Content> get messages {
    if (accessRemoved || !canRead) return [];
    if (_sessionOrigin != null && _sessionOrigin != knownOrigin) return [];
    final saved = _historyOrigin == knownOrigin
        ? _history?.messages(channelId, now()) ?? []
        : <Content>[];
    final live = connected && !reconnecting
        ? _messages
        : const <String, Content>{};
    final result = {
      ...{for (final m in saved) m.id: m},
      ...live,
    }.values.toList()..sort((a, b) => a.sequence.compareTo(b.sequence));
    final projected = projectQueuedMutations(
      result,
      _pendingMessages,
      principalId,
    );
    if (attachmentsEnabled) return projected;
    return projected.map((message) {
      if (message.attachments.isEmpty) return message;
      return Content()
        ..mergeFromMessage(message)
        ..attachments.clear();
    }).toList();
  }

  String _invitationToken = '', invitationRole = '';
  String _setupCode = '';
  bool get canWrite =>
      connected &&
      !reconnecting &&
      !accessRemoved &&
      (_session is SpaceAccess ? (_session as SpaceAccess).canWrite : true);
  String get principalId =>
      _session?.principalId ?? _history?.principalId ?? '';
  SpaceAdministration? get administration =>
      !accessRemoved &&
          _session is SpaceAdministration &&
          ((_session as SpaceAdministration).canManageSpace ||
              (_session as SpaceAdministration).needsOwnerSetup)
      ? _session as SpaceAdministration
      : null;
  DeviceManagement? get deviceManagement =>
      !accessRemoved && _session is DeviceManagement
      ? _session as DeviceManagement
      : null;
  String get spaceTitle => _session is SpacePresentation
      ? (_session as SpacePresentation).spaceTitle
      : _history?.title ?? '';
  String get chatTitle => _session is SpacePresentation
      ? (_session as SpacePresentation).chatTitle
      : channels.where((c) => c.id == channelId).firstOrNull?.title ??
            'Общий чат';
  ServerIcon? _lastServerIcon;
  ServerIcon? get serverIcon => _lastServerIcon;
  void _update() {
    _captureHistory();
    if (_session is ServerIconPresentation) {
      _lastServerIcon =
          (_session as ServerIconPresentation).serverIcon ?? _lastServerIcon;
    }
    if (!_disposed) publishState();
  }

  void publishState() {
    if (!_disposed && !isClosed) {
      publishStateEvent(ChatStatePublished(ChatState.fromController(this)));
    }
  }

  bool _failureRetry = false;
  bool get failureRetry => failureCode != null && _failureRetry;
  String _failureMessage = '';
  LocalFailureCode? _failureCode;
  LocalFailureCode? get failureCode =>
      error.isNotEmpty && error.startsWith(_failureMessage)
      ? _failureCode
      : null;

  String _explain(Object problem, {bool retry = false}) {
    _failureRetry = retry;
    _failureCode = classifyFailure(problem);
    return _failureMessage = _diagnostic(problem);
  }

  String _diagnostic(Object problem) {
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

  Future<void> _inspect(
    String address, {
    String invitationToken = '',
    String? homeOrigin,
    String tlsFingerprint = '',
    DeviceRecord? savedRecord,
  }) async {
    if (busy) return;
    busy = true;
    error = '';
    preview = null;
    _invitationToken = '';
    _setupCode = '';
    invitationRole = '';
    _update();
    try {
      final input = parseConnectionInput(
        address,
        invitationToken: invitationToken,
      );
      final known = savedRecord ?? await vault.load(input.origin.toString());
      final server = await discoverConnection(
        input,
        record: known,
        homeOrigin: homeOrigin,
        tlsFingerprint: tlsFingerprint,
      );
      final saved = await vault.load(server.origin.toString());
      if (saved != null) checkTrust(server, saved);
      fingerprint = await server.fingerprint();
      final invite = input.invitationToken;
      if (invite.isNotEmpty) {
        final result = await SpaceSession.previewInvitation(server, invite);
        _invitationToken = invite;
        invitationRole = result.role;
      }
      preview = server;
      _setupCode = input.setupCode;
    } catch (e) {
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> _connect({
    DeviceRecord? restoredRecord,
    String pairingId = '',
    String setupCode = '',
    String? nickname,
  }) async {
    final server = preview;
    if (busy || server == null) return;
    accessRemoved = false;
    busy = true;
    error = '';
    _stopSubscription();
    connected = false;
    _messages.clear();
    _pendingKey = '';
    _pendingText = '';
    sendStatus = MessageSendStatus.idle;
    _update();
    try {
      _positionTimer?.cancel();
      await _savePositions();
      _stopCatalog();
      await _session?.close();
      _session = null;
      await _restoreHistory(server.origin.toString());
      final session = await _openChatSession(
        server,
        restoredRecord,
        pairingId,
        _connectionSetupCode(setupCode),
      );
      if (_disposed || accessRemoved) {
        await session.close();
        return;
      }
      _session = session;
      await _applyNickname(session, nickname);
      _sessionOrigin = server.origin.toString();
      _sessionServerId = server.serverId;
      await _loadSessionOutbox(server, session);
      _invitationToken = '';
      _setupCode = '';
      await _loadPositions();
      final initial = await _initialHistory(session);
      if (_disposed || accessRemoved) {
        await session.close();
        return;
      }
      _messages.clear();
      for (final message in initial) {
        if (navigation != null && message.channelId != channelId) {
          throw const LocalFailure(
            LocalFailureCode.protocolInvalid,
            'История другого канала',
          );
        }
        _mergeMessage(message);
      }
      _restoreReadSequence();
      connected = true;
      if (session is ChannelUpdates) {
        unawaited(_watchCatalog(session, ++_catalogGeneration));
      }
      if (canRead && !encryptedChannel) {
        unawaited(_watch(session, ++_generation));
      }
    } catch (e) {
      await _rejectAccess(e);
      error = _explain(e);
      _retryOutboxConnection(server, e);
    } finally {
      busy = false;
      _update();
      _wakeOutbox();
    }
  }

  Future<void> _applyNickname(LiveSession session, String? nickname) async {
    if (nickname == null || nickname.trim().isEmpty) return;
    if (session is MemberProfile) {
      try {
        await (session as MemberProfile).setNickname(nickname.trim());
      } on GrpcError catch (error) {
        if (error.code == StatusCode.alreadyExists) {
          throw const LocalFailure(
            LocalFailureCode.nicknameTaken,
            'Это имя уже занято',
          );
        }
        if (error.code == StatusCode.invalidArgument) {
          throw const LocalFailure(
            LocalFailureCode.nicknameInvalid,
            'Недопустимое имя',
          );
        }
        rethrow;
      }
    }
  }

  void _restoreReadSequence() {
    if (readSequence(channelId) == 0 && readThrough.isNotEmpty) {
      final marked = messages.where((m) => m.id == readThrough).firstOrNull;
      if (marked != null && marked.sequence.toInt() > 0) {
        _readSequences[channelId] = marked.sequence.toInt();
        _queuePositions();
      }
    }
  }

  Future<LiveSession> _openChatSession(
    Discovery server,
    DeviceRecord? restoredRecord,
    String pairingId,
    String setupCode,
  ) async {
    return _invitationToken.isEmpty &&
            restoredRecord == null &&
            setupCode.isEmpty
        ? await openSession(server, vault)
        : await SpaceSession.connect(
            server,
            vault,
            invitationToken: pairingId.isEmpty ? _invitationToken : '',
            restoredRecord: restoredRecord,
            pairingId: pairingId,
            setupCode: setupCode,
          );
  }

  String _connectionSetupCode(String explicit) =>
      explicit.isEmpty ? _setupCode : explicit;

  Future<void> _selectCachedChannel(String id) async {
    if (!_history!.channels.any((c) => c.id == id && c.permissions.read)) {
      return;
    }
    _stopSubscription();
    navigation?.selectChannel(id);
    _history!.selected = id;
    _messages.clear();
    connected = false;
    await _flushHistory();
    _update();
    return;
  }

  Future<void> _selectChannel(String id) async {
    if ((!connected || reconnecting) && _history != null && !accessRemoved) {
      await _selectCachedChannel(id);
      return;
    }
    final nav = navigation;
    final session = _session;
    if (busy || nav == null || session == null) return;
    busy = true;
    error = '';
    _stopSubscription();
    _messages.clear();
    cursor = '';
    _pendingText = '';
    sendStatus = MessageSendStatus.idle;
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
      final initial = await _initialHistory(session);
      if (_disposed) return;
      for (final m in initial) {
        if (m.channelId != nextId) {
          throw const LocalFailure(
            LocalFailureCode.protocolInvalid,
            'История другого канала',
          );
        }
        _mergeMessage(m);
      }
      connected = true;
      await _savePositions();
      if (canRead && !encryptedChannel) {
        unawaited(_watch(session, ++_generation));
      }
    } catch (e) {
      _messages.clear();
      error = _explain(e);
    } finally {
      busy = false;
      _update();
    }
  }

  Future<void> _refreshChannels() async {
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
        sendStatus = MessageSendStatus.idle;
        _pendingKey = '';
        cursor = '';
      }
      error = canRead
          ? _explain(
              const LocalFailure(
                LocalFailureCode.channelChanged,
                'Права канала изменились. Обновите чат перед повтором.',
              ),
            )
          : _explain(
              const LocalFailure(
                LocalFailureCode.channelUnavailable,
                'Доступ к этому каналу изменён. Выберите доступный чат.',
              ),
            );
    } catch (e) {
      if (_disposed || generation != _generation) return true;
      await _rejectAccess(e);
      _messages.clear();
      connected = false;
      error = _explain(e);
    }
    _update();
    return true;
  }

  void _stopCatalog() {
    _catalogGeneration++;
    _catalogRetryTimer?.cancel();
    if (_catalogRetryDone != null && !_catalogRetryDone!.isCompleted) {
      _catalogRetryDone!.complete();
    }
    final iterator = _catalogIterator;
    _catalogIterator = null;
    if (iterator != null) unawaited(_cancelIterator(iterator));
  }

  bool _catalogCurrent(LiveSession session, int generation) =>
      !_disposed &&
      connected &&
      identical(session, _session) &&
      generation == _catalogGeneration;

  Future<bool> _catalogChanged(LiveSession session, int generation) async {
    if (!_catalogCurrent(session, generation)) return false;
    if (!canRead) {
      _stopSubscription();
      _messages.clear();
      cursor = '';
      _pendingKey = '';
      _pendingText = '';
      sendStatus = MessageSendStatus.idle;
      error = _explain(
        const LocalFailure(
          LocalFailureCode.channelUnavailable,
          'Доступ к этому каналу изменён. Выберите доступный чат.',
        ),
      );
    } else if (_activeIterator == null && !busy && channelId.isNotEmpty) {
      await _selectChannel(channelId);
    }
    _update();
    return true;
  }

  Future<void> _rejectCatalogAccess(Object problem) async {
    await _rejectAccess(problem);
    connected = false;
    error = _explain(problem);
    _stopSubscription();
    _messages.clear();
    _update();
  }

  Future<bool> _renewCatalogLogin(LiveSession session, int generation) async {
    try {
      await session.login();
      return true;
    } catch (problem) {
      if (!_catalogCurrent(session, generation)) return false;
      if (!_terminal(problem)) return true;
      await _rejectCatalogAccess(problem);
      return false;
    }
  }

  Future<bool> _recoverCatalog(
    LiveSession session,
    int generation,
    Object problem,
  ) async {
    if (!_catalogCurrent(session, generation)) return false;
    if (problem is GrpcError && problem.code == StatusCode.unimplemented) {
      return false;
    }
    if (problem is GrpcError && problem.code == StatusCode.unauthenticated) {
      return _renewCatalogLogin(session, generation);
    }
    if (!_terminal(problem)) return true;
    await _rejectCatalogAccess(problem);
    return false;
  }

  Future<void> _watchCatalog(LiveSession session, int generation) async {
    bool active() => _catalogCurrent(session, generation);
    var attempt = 0;
    while (active()) {
      final iterator = StreamIterator(
        (session as ChannelUpdates).watchChannelChanges(),
      );
      _catalogIterator = iterator;
      try {
        while (await iterator.moveNext()) {
          if (!await sendRequest(ChatCatalogChanged(session, generation))) {
            return;
          }
          attempt = 0;
        }
      } catch (problem) {
        if (!await sendRequest(
          ChatCatalogFailed(session, generation, problem),
        )) {
          return;
        }
      } finally {
        await _releaseCatalogIterator(iterator);
      }
      if (!active()) return;
      final done = Completer<void>();
      _catalogRetryDone = done;
      _catalogRetryTimer = Timer(retryDelay(attempt), () => done.complete());
      await done.future;
      if (attempt < 5) attempt++;
    }
  }

  Future<void> _releaseCatalogIterator(StreamIterator<dynamic> iterator) async {
    if (identical(_catalogIterator, iterator)) _catalogIterator = null;
    await _cancelIterator(iterator);
  }

  bool _current(LiveSession session, int generation) =>
      !_disposed && _session == session && _generation == generation;
  void _stopSubscription() {
    _resetHistoryPaging();
    _generation++;
    _retryTimer?.cancel();
    if (_retryDone != null && !_retryDone!.isCompleted) _retryDone!.complete();
    reconnecting = false;
    final iterator = _activeIterator;
    _activeIterator = null;
    if (iterator != null) unawaited(_cancelIterator(iterator));
  }

  Future<void> _cancelIterator<T>(StreamIterator<T> iterator) async {
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

  bool _streamChannelAvailable(String watchedChannel) {
    if (canRead && channelId == watchedChannel) return true;
    _messages.clear();
    error = _explain(
      const LocalFailure(
        LocalFailureCode.channelUnavailable,
        'Канал больше не доступен для чтения.',
      ),
    );
    _update();
    return false;
  }

  void _validateContentFrame(SubscribeResponse frame, String watchedChannel) {
    if (!frame.hasEvent() ||
        ![
          'content.created',
          'content.updated',
          'content.deleted',
        ].contains(frame.event.type) ||
        !frame.event.hasContent() ||
        frame.event.content.channelId != watchedChannel ||
        frame.event.content.id.isEmpty ||
        frame.event.content.sequence.isNegative ||
        frame.cursor.isEmpty ||
        frame.event.cursor != frame.cursor) {
      throw const LocalFailure(
        LocalFailureCode.protocolInvalid,
        'Неподдерживаемое событие потока',
      );
    }
  }

  bool _acceptFrame(SubscribeResponse frame, String watchedChannel) {
    if (navigation != null && !_streamChannelAvailable(watchedChannel)) {
      return false;
    }
    if (frame.heartbeat) {
      if (frame.hasEvent() || frame.cursor != cursor) {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'Heartbeat содержит неверный курсор',
        );
      }
      return _streamChannelAvailable(watchedChannel);
    }
    _validateContentFrame(frame, watchedChannel);
    _mergeHistoryFrame(frame.event.content);
    cursor = frame.cursor;
    _cursors[watchedChannel] = cursor;
    _queuePositions();
    return true;
  }

  Future<void> _watch(LiveSession session, int generation) async {
    final watchedChannel = channelId;
    var attempt = 0;
    while (_current(session, generation)) {
      final started = DateTime.now();
      final iterator = StreamIterator(session.subscribe(cursor));
      _activeIterator = iterator;
      try {
        final keepWatching = await _readSubscription(
          iterator,
          session,
          generation,
          watchedChannel,
          started,
          () => attempt = 0,
        );
        if (!keepWatching) return;
      } catch (problem) {
        if (!await _recoverSubscription(
          session,
          generation,
          watchedChannel,
          problem,
        )) {
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

  bool _receiveFrame(ChatFrameReceived event) {
    if (!_current(event.session, event.generation)) return false;
    if (!_acceptFrame(event.frame, event.channelId)) return false;
    reconnecting = false;
    _update();
    _wakeOutbox();
    return true;
  }

  Future<bool> _readSubscription(
    StreamIterator<SubscribeResponse> iterator,
    LiveSession session,
    int generation,
    String watchedChannel,
    DateTime started,
    VoidCallback onStable,
  ) async {
    while (await iterator.moveNext()) {
      final accepted = await sendRequest(
        ChatFrameReceived(
          iterator.current,
          session,
          generation,
          watchedChannel,
        ),
      );
      if (!accepted) return false;
      if (DateTime.now().difference(started) > const Duration(seconds: 20)) {
        onStable();
      }
    }
    return true;
  }

  Future<bool> _recoverSubscription(
    LiveSession session,
    int generation,
    String watchedChannel,
    Object problem,
  ) async {
    if (!_current(session, generation)) return false;
    if (await _channelDenied(problem)) return false;
    if (problem is GrpcError && problem.code == StatusCode.unauthenticated) {
      try {
        await session.login();
      } catch (loginError) {
        if (!_current(session, generation)) return false;
        if (_terminal(loginError)) {
          await _rejectAccess(loginError);
          connected = false;
          error = _explain(loginError);
          _update();
          return false;
        }
      }
    } else if (_terminal(problem)) {
      if (problem is GrpcError && problem.code == StatusCode.invalidArgument) {
        _cursors.remove(watchedChannel);
        cursor = '';
        await _savePositions();
      }
      connected = false;
      error = _subscriptionError(problem);
      _update();
      return false;
    }
    return true;
  }

  String _subscriptionError(Object problem) {
    if (problem is! GrpcError) return _explain(problem);
    final failure = switch (problem.code) {
      StatusCode.unimplemented => const LocalFailure(
        LocalFailureCode.eventsUnsupported,
        'Сервер пока не поддерживает подписку событий. Обновите сервер.',
      ),
      StatusCode.invalidArgument => const LocalFailure(
        LocalFailureCode.cursorRejected,
        'Сервер не принял курсор истории. Подключитесь заново для загрузки сообщений.',
      ),
      _ => problem,
    };
    return _explain(failure);
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
  MessageSendStatus sendStatus = MessageSendStatus.idle;

  void _mergeMessage(Content message) {
    final previous =
        _messages[message.id] ??
        _history?.entries['${message.channelId}/${message.id}']?.content;
    if (previous != null && previous.revision > message.revision) return;
    _messages[message.id] = message;
    if (message.deleted) {
      _history?.favorites.remove('${message.channelId}/${message.id}');
    }
  }

  Future<bool> _changeMessage(Content message, String? text) async {
    if (_canQueueMutation && canChangeMessage(message)) {
      return _enqueueMutation(
        message,
        text == null ? MutationKind.delete : MutationKind.edit,
        text: text ?? '',
      );
    }
    return _changeMessageOnline(message, text);
  }

  Future<bool> _changeMessageOnline(Content message, String? text) async {
    final session = _session;
    if (!canChangeMessage(message) ||
        session == null ||
        session is! MessageChanges) {
      return false;
    }
    final changes = session as MessageChanges;
    final startingChannel = channelId;
    busy = true;
    error = '';
    _update();
    try {
      final result = text == null
          ? await changes.deleteMessage(message)
          : await changes.updateMessage(message, text);
      if (!identical(session, _session) || channelId != startingChannel) {
        return false;
      }
      if (result.id != message.id || result.channelId != startingChannel) {
        throw const LocalFailure(
          LocalFailureCode.protocolInvalid,
          'Неверное сообщение в ответе',
        );
      }
      _mergeMessage(result);
      return true;
    } catch (problem) {
      if (!identical(session, _session) || channelId != startingChannel) {
        return false;
      }
      if (await _channelDenied(problem)) return false;
      error = _explain(problem);
      return false;
    } finally {
      busy = false;
      _update();
    }
  }

  Future<bool> _send(
    String text,
    List<String> attachments,
    List<XFile> files,
    String replyTo,
  ) => _enqueueMessage(text, attachments, files, replyTo);

  Future<void> _revoke() async {
    if (busy || _session == null) return;
    busy = true;
    _stopSubscription();
    _update();
    try {
      await _session!.revoke();
      await _clearOfflineData();
      _stopCatalog();
      connected = false;
      error = _explain(
        const LocalFailure(
          LocalFailureCode.deviceRevoked,
          'Доступ этого устройства отозван. Ключи сохранены; новый grant автоматически не создаётся.',
        ),
      );
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

  Future<void> _disconnect() async {
    if (busy) return;
    _stopOutbox();
    try {
      await _flushHistory().timeout(const Duration(seconds: 3));
    } catch (_) {}
    busy = true;
    connected = false;
    _stopCatalog();
    _stopSubscription();
    _update();
    final session = _session;
    final save = _savePositions();
    _session = null;
    try {
      _positionTimer?.cancel();
      try {
        await save.timeout(const Duration(seconds: 3));
      } catch (_) {}
      try {
        await session?.close().timeout(const Duration(seconds: 5));
      } catch (_) {}
    } finally {
      preview = null;
      fingerprint = '';
      cursor = '';
      _messages.clear();
      _pendingKey = '';
      _pendingText = '';
      sendStatus = MessageSendStatus.idle;
      _cursors.clear();
      _readThrough.clear();
      _readSequences.clear();
      error = '';
      busy = false;
      _update();
    }
  }

  @override
  Future<void> close() async {
    _historyTimer?.cancel();
    _disposed = true;
    _stopOutbox();
    _stopCatalog();
    _positionTimer?.cancel();
    unawaited(_savePositions());
    _stopSubscription();
    unawaited(_session?.close());
    await _finishOutbox();
    try {
      await _flushHistory().timeout(const Duration(seconds: 3));
    } on TimeoutException {
      cacheError = 'История не сохранена';
    }
    await super.close();
  }
}
