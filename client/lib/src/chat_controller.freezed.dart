// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {

 bool get historyLoading; bool get hasOlderHistory; String get historyError; bool get busy; bool get connected; bool get reconnecting; bool get accessRemoved; bool get canRead; bool get canWrite; String get error; String get cacheError; String get fingerprint; String get cursor; String get origin; String get principalId; String get channelId; String get spaceTitle; String get chatTitle; String get readThrough; LocalFailureCode? get failureCode; bool get failureRetry; String get invitationRole; bool get initialSetup; Discovery? get preview; ServerIcon? get serverIcon; List<Content> get messages; List<Channel> get channels; Set<String> get favorites; Map<String, int> get unreadCounts; MessageSendStatus get sendStatus; bool get canQueue; List<PendingMessage> get pendingMessages; String get outboxError; List<OutboxScope> get outboxSources; String get outboxRecoveryTarget;
/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatStateCopyWith<ChatState> get copyWith => _$ChatStateCopyWithImpl<ChatState>(this as ChatState, _$identity);





@override
String toString() {
  final _this = this as ChatState;
  return 'ChatState(historyLoading: ${_this.historyLoading}, hasOlderHistory: ${_this.hasOlderHistory}, historyError: ${_this.historyError}, busy: ${_this.busy}, connected: ${_this.connected}, reconnecting: ${_this.reconnecting}, accessRemoved: ${_this.accessRemoved}, canRead: ${_this.canRead}, canWrite: ${_this.canWrite}, error: ${_this.error}, cacheError: ${_this.cacheError}, fingerprint: ${_this.fingerprint}, cursor: ${_this.cursor}, origin: ${_this.origin}, principalId: ${_this.principalId}, channelId: ${_this.channelId}, spaceTitle: ${_this.spaceTitle}, chatTitle: ${_this.chatTitle}, readThrough: ${_this.readThrough}, failureCode: ${_this.failureCode}, failureRetry: ${_this.failureRetry}, invitationRole: ${_this.invitationRole}, initialSetup: ${_this.initialSetup}, preview: ${_this.preview}, serverIcon: ${_this.serverIcon}, messages: ${_this.messages}, channels: ${_this.channels}, favorites: ${_this.favorites}, unreadCounts: ${_this.unreadCounts}, sendStatus: ${_this.sendStatus}, canQueue: ${_this.canQueue}, pendingMessages: ${_this.pendingMessages}, outboxError: ${_this.outboxError}, outboxSources: ${_this.outboxSources}, outboxRecoveryTarget: ${_this.outboxRecoveryTarget})';
}


}

/// @nodoc
abstract mixin class $ChatStateCopyWith<$Res>  {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) _then) = _$ChatStateCopyWithImpl;
@useResult
$Res call({
 bool historyLoading, bool hasOlderHistory, String historyError, bool busy, bool connected, bool reconnecting, bool accessRemoved, bool canRead, bool canWrite, String error, String cacheError, String fingerprint, String cursor, String origin, String principalId, String channelId, String spaceTitle, String chatTitle, String readThrough, LocalFailureCode? failureCode, bool failureRetry, String invitationRole, bool initialSetup, Discovery? preview, ServerIcon? serverIcon, List<Content> messages, List<Channel> channels, Set<String> favorites, Map<String, int> unreadCounts, MessageSendStatus sendStatus, bool canQueue, List<PendingMessage> pendingMessages, String outboxError, List<OutboxScope> outboxSources, String outboxRecoveryTarget
});




}
/// @nodoc
class _$ChatStateCopyWithImpl<$Res>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._self, this._then);

  final ChatState _self;
  final $Res Function(ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? historyLoading = null,Object? hasOlderHistory = null,Object? historyError = null,Object? busy = null,Object? connected = null,Object? reconnecting = null,Object? accessRemoved = null,Object? canRead = null,Object? canWrite = null,Object? error = null,Object? cacheError = null,Object? fingerprint = null,Object? cursor = null,Object? origin = null,Object? principalId = null,Object? channelId = null,Object? spaceTitle = null,Object? chatTitle = null,Object? readThrough = null,Object? failureCode = freezed,Object? failureRetry = null,Object? invitationRole = null,Object? initialSetup = null,Object? preview = freezed,Object? serverIcon = freezed,Object? messages = null,Object? channels = null,Object? favorites = null,Object? unreadCounts = null,Object? sendStatus = null,Object? canQueue = null,Object? pendingMessages = null,Object? outboxError = null,Object? outboxSources = null,Object? outboxRecoveryTarget = null,}) {
  return _then(ChatState(
historyLoading: null == historyLoading ? _self.historyLoading : historyLoading // ignore: cast_nullable_to_non_nullable
as bool,hasOlderHistory: null == hasOlderHistory ? _self.hasOlderHistory : hasOlderHistory // ignore: cast_nullable_to_non_nullable
as bool,historyError: null == historyError ? _self.historyError : historyError // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,reconnecting: null == reconnecting ? _self.reconnecting : reconnecting // ignore: cast_nullable_to_non_nullable
as bool,accessRemoved: null == accessRemoved ? _self.accessRemoved : accessRemoved // ignore: cast_nullable_to_non_nullable
as bool,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canWrite: null == canWrite ? _self.canWrite : canWrite // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,cacheError: null == cacheError ? _self.cacheError : cacheError // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,principalId: null == principalId ? _self.principalId : principalId // ignore: cast_nullable_to_non_nullable
as String,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,spaceTitle: null == spaceTitle ? _self.spaceTitle : spaceTitle // ignore: cast_nullable_to_non_nullable
as String,chatTitle: null == chatTitle ? _self.chatTitle : chatTitle // ignore: cast_nullable_to_non_nullable
as String,readThrough: null == readThrough ? _self.readThrough : readThrough // ignore: cast_nullable_to_non_nullable
as String,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as LocalFailureCode?,failureRetry: null == failureRetry ? _self.failureRetry : failureRetry // ignore: cast_nullable_to_non_nullable
as bool,invitationRole: null == invitationRole ? _self.invitationRole : invitationRole // ignore: cast_nullable_to_non_nullable
as String,initialSetup: null == initialSetup ? _self.initialSetup : initialSetup // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Discovery?,serverIcon: freezed == serverIcon ? _self.serverIcon : serverIcon // ignore: cast_nullable_to_non_nullable
as ServerIcon?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Content>,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<Channel>,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<String>,unreadCounts: null == unreadCounts ? _self.unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as MessageSendStatus,canQueue: null == canQueue ? _self.canQueue : canQueue // ignore: cast_nullable_to_non_nullable
as bool,pendingMessages: null == pendingMessages ? _self.pendingMessages : pendingMessages // ignore: cast_nullable_to_non_nullable
as List<PendingMessage>,outboxError: null == outboxError ? _self.outboxError : outboxError // ignore: cast_nullable_to_non_nullable
as String,outboxSources: null == outboxSources ? _self.outboxSources : outboxSources // ignore: cast_nullable_to_non_nullable
as List<OutboxScope>,outboxRecoveryTarget: null == outboxRecoveryTarget ? _self.outboxRecoveryTarget : outboxRecoveryTarget // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatState value)  $default,){
final _that = this;
switch (_that) {
case _ChatState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatState value)?  $default,){
final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool historyLoading,  bool hasOlderHistory,  String historyError,  bool busy,  bool connected,  bool reconnecting,  bool accessRemoved,  bool canRead,  bool canWrite,  String error,  String cacheError,  String fingerprint,  String cursor,  String origin,  String principalId,  String channelId,  String spaceTitle,  String chatTitle,  String readThrough,  LocalFailureCode? failureCode,  bool failureRetry,  String invitationRole,  bool initialSetup,  Discovery? preview,  ServerIcon? serverIcon,  List<Content> messages,  List<Channel> channels,  Set<String> favorites,  Map<String, int> unreadCounts,  MessageSendStatus sendStatus,  bool canQueue,  List<PendingMessage> pendingMessages,  String outboxError,  List<OutboxScope> outboxSources,  String outboxRecoveryTarget)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.historyLoading,_that.hasOlderHistory,_that.historyError,_that.busy,_that.connected,_that.reconnecting,_that.accessRemoved,_that.canRead,_that.canWrite,_that.error,_that.cacheError,_that.fingerprint,_that.cursor,_that.origin,_that.principalId,_that.channelId,_that.spaceTitle,_that.chatTitle,_that.readThrough,_that.failureCode,_that.failureRetry,_that.invitationRole,_that.initialSetup,_that.preview,_that.serverIcon,_that.messages,_that.channels,_that.favorites,_that.unreadCounts,_that.sendStatus,_that.canQueue,_that.pendingMessages,_that.outboxError,_that.outboxSources,_that.outboxRecoveryTarget);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool historyLoading,  bool hasOlderHistory,  String historyError,  bool busy,  bool connected,  bool reconnecting,  bool accessRemoved,  bool canRead,  bool canWrite,  String error,  String cacheError,  String fingerprint,  String cursor,  String origin,  String principalId,  String channelId,  String spaceTitle,  String chatTitle,  String readThrough,  LocalFailureCode? failureCode,  bool failureRetry,  String invitationRole,  bool initialSetup,  Discovery? preview,  ServerIcon? serverIcon,  List<Content> messages,  List<Channel> channels,  Set<String> favorites,  Map<String, int> unreadCounts,  MessageSendStatus sendStatus,  bool canQueue,  List<PendingMessage> pendingMessages,  String outboxError,  List<OutboxScope> outboxSources,  String outboxRecoveryTarget)  $default,) {final _that = this;
switch (_that) {
case _ChatState():
return $default(_that.historyLoading,_that.hasOlderHistory,_that.historyError,_that.busy,_that.connected,_that.reconnecting,_that.accessRemoved,_that.canRead,_that.canWrite,_that.error,_that.cacheError,_that.fingerprint,_that.cursor,_that.origin,_that.principalId,_that.channelId,_that.spaceTitle,_that.chatTitle,_that.readThrough,_that.failureCode,_that.failureRetry,_that.invitationRole,_that.initialSetup,_that.preview,_that.serverIcon,_that.messages,_that.channels,_that.favorites,_that.unreadCounts,_that.sendStatus,_that.canQueue,_that.pendingMessages,_that.outboxError,_that.outboxSources,_that.outboxRecoveryTarget);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool historyLoading,  bool hasOlderHistory,  String historyError,  bool busy,  bool connected,  bool reconnecting,  bool accessRemoved,  bool canRead,  bool canWrite,  String error,  String cacheError,  String fingerprint,  String cursor,  String origin,  String principalId,  String channelId,  String spaceTitle,  String chatTitle,  String readThrough,  LocalFailureCode? failureCode,  bool failureRetry,  String invitationRole,  bool initialSetup,  Discovery? preview,  ServerIcon? serverIcon,  List<Content> messages,  List<Channel> channels,  Set<String> favorites,  Map<String, int> unreadCounts,  MessageSendStatus sendStatus,  bool canQueue,  List<PendingMessage> pendingMessages,  String outboxError,  List<OutboxScope> outboxSources,  String outboxRecoveryTarget)?  $default,) {final _that = this;
switch (_that) {
case _ChatState() when $default != null:
return $default(_that.historyLoading,_that.hasOlderHistory,_that.historyError,_that.busy,_that.connected,_that.reconnecting,_that.accessRemoved,_that.canRead,_that.canWrite,_that.error,_that.cacheError,_that.fingerprint,_that.cursor,_that.origin,_that.principalId,_that.channelId,_that.spaceTitle,_that.chatTitle,_that.readThrough,_that.failureCode,_that.failureRetry,_that.invitationRole,_that.initialSetup,_that.preview,_that.serverIcon,_that.messages,_that.channels,_that.favorites,_that.unreadCounts,_that.sendStatus,_that.canQueue,_that.pendingMessages,_that.outboxError,_that.outboxSources,_that.outboxRecoveryTarget);case _:
  return null;

}
}

}

/// @nodoc


class _ChatState extends ChatState {
  const _ChatState({this.historyLoading = false, this.hasOlderHistory = false, this.historyError = '', this.busy = false, this.connected = false, this.reconnecting = false, this.accessRemoved = false, this.canRead = false, this.canWrite = false, this.error = '', this.cacheError = '', this.fingerprint = '', this.cursor = '', this.origin = '', this.principalId = '', this.channelId = 'general', this.spaceTitle = '', this.chatTitle = '', this.readThrough = '', this.failureCode, this.failureRetry = false, this.invitationRole = '', this.initialSetup = false, this.preview, this.serverIcon, this.messages = const [], this.channels = const [], this.favorites = const {}, this.unreadCounts = const {}, this.sendStatus = MessageSendStatus.idle, this.canQueue = false, this.pendingMessages = const [], this.outboxError = '', this.outboxSources = const [], this.outboxRecoveryTarget = ''}): super._();
  

@override@JsonKey() final  bool historyLoading;
@override@JsonKey() final  bool hasOlderHistory;
@override@JsonKey() final  String historyError;
@override@JsonKey() final  bool busy;
@override@JsonKey() final  bool connected;
@override@JsonKey() final  bool reconnecting;
@override@JsonKey() final  bool accessRemoved;
@override@JsonKey() final  bool canRead;
@override@JsonKey() final  bool canWrite;
@override@JsonKey() final  String error;
@override@JsonKey() final  String cacheError;
@override@JsonKey() final  String fingerprint;
@override@JsonKey() final  String cursor;
@override@JsonKey() final  String origin;
@override@JsonKey() final  String principalId;
@override@JsonKey() final  String channelId;
@override@JsonKey() final  String spaceTitle;
@override@JsonKey() final  String chatTitle;
@override@JsonKey() final  String readThrough;
@override final  LocalFailureCode? failureCode;
@override@JsonKey() final  bool failureRetry;
@override@JsonKey() final  String invitationRole;
@override@JsonKey() final  bool initialSetup;
@override final  Discovery? preview;
@override final  ServerIcon? serverIcon;
@override@JsonKey() final  List<Content> messages;
@override@JsonKey() final  List<Channel> channels;
@override@JsonKey() final  Set<String> favorites;
@override@JsonKey() final  Map<String, int> unreadCounts;
@override@JsonKey() final  MessageSendStatus sendStatus;
@override@JsonKey() final  bool canQueue;
@override@JsonKey() final  List<PendingMessage> pendingMessages;
@override@JsonKey() final  String outboxError;
@override@JsonKey() final  List<OutboxScope> outboxSources;
@override@JsonKey() final  String outboxRecoveryTarget;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatStateCopyWith<_ChatState> get copyWith => __$ChatStateCopyWithImpl<_ChatState>(this, _$identity);





@override
String toString() {
    return 'ChatState(historyLoading: $historyLoading, hasOlderHistory: $hasOlderHistory, historyError: $historyError, busy: $busy, connected: $connected, reconnecting: $reconnecting, accessRemoved: $accessRemoved, canRead: $canRead, canWrite: $canWrite, error: $error, cacheError: $cacheError, fingerprint: $fingerprint, cursor: $cursor, origin: $origin, principalId: $principalId, channelId: $channelId, spaceTitle: $spaceTitle, chatTitle: $chatTitle, readThrough: $readThrough, failureCode: $failureCode, failureRetry: $failureRetry, invitationRole: $invitationRole, initialSetup: $initialSetup, preview: $preview, serverIcon: $serverIcon, messages: $messages, channels: $channels, favorites: $favorites, unreadCounts: $unreadCounts, sendStatus: $sendStatus, canQueue: $canQueue, pendingMessages: $pendingMessages, outboxError: $outboxError, outboxSources: $outboxSources, outboxRecoveryTarget: $outboxRecoveryTarget)';
}


}

/// @nodoc
abstract mixin class _$ChatStateCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$ChatStateCopyWith(_ChatState value, $Res Function(_ChatState) _then) = __$ChatStateCopyWithImpl;
@override @useResult
$Res call({
 bool historyLoading, bool hasOlderHistory, String historyError, bool busy, bool connected, bool reconnecting, bool accessRemoved, bool canRead, bool canWrite, String error, String cacheError, String fingerprint, String cursor, String origin, String principalId, String channelId, String spaceTitle, String chatTitle, String readThrough, LocalFailureCode? failureCode, bool failureRetry, String invitationRole, bool initialSetup, Discovery? preview, ServerIcon? serverIcon, List<Content> messages, List<Channel> channels, Set<String> favorites, Map<String, int> unreadCounts, MessageSendStatus sendStatus, bool canQueue, List<PendingMessage> pendingMessages, String outboxError, List<OutboxScope> outboxSources, String outboxRecoveryTarget
});




}
/// @nodoc
class __$ChatStateCopyWithImpl<$Res>
    implements _$ChatStateCopyWith<$Res> {
  __$ChatStateCopyWithImpl(this._self, this._then);

  final _ChatState _self;
  final $Res Function(_ChatState) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? historyLoading = null,Object? hasOlderHistory = null,Object? historyError = null,Object? busy = null,Object? connected = null,Object? reconnecting = null,Object? accessRemoved = null,Object? canRead = null,Object? canWrite = null,Object? error = null,Object? cacheError = null,Object? fingerprint = null,Object? cursor = null,Object? origin = null,Object? principalId = null,Object? channelId = null,Object? spaceTitle = null,Object? chatTitle = null,Object? readThrough = null,Object? failureCode = freezed,Object? failureRetry = null,Object? invitationRole = null,Object? initialSetup = null,Object? preview = freezed,Object? serverIcon = freezed,Object? messages = null,Object? channels = null,Object? favorites = null,Object? unreadCounts = null,Object? sendStatus = null,Object? canQueue = null,Object? pendingMessages = null,Object? outboxError = null,Object? outboxSources = null,Object? outboxRecoveryTarget = null,}) {
  return _then(_ChatState(
historyLoading: null == historyLoading ? _self.historyLoading : historyLoading // ignore: cast_nullable_to_non_nullable
as bool,hasOlderHistory: null == hasOlderHistory ? _self.hasOlderHistory : hasOlderHistory // ignore: cast_nullable_to_non_nullable
as bool,historyError: null == historyError ? _self.historyError : historyError // ignore: cast_nullable_to_non_nullable
as String,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as bool,connected: null == connected ? _self.connected : connected // ignore: cast_nullable_to_non_nullable
as bool,reconnecting: null == reconnecting ? _self.reconnecting : reconnecting // ignore: cast_nullable_to_non_nullable
as bool,accessRemoved: null == accessRemoved ? _self.accessRemoved : accessRemoved // ignore: cast_nullable_to_non_nullable
as bool,canRead: null == canRead ? _self.canRead : canRead // ignore: cast_nullable_to_non_nullable
as bool,canWrite: null == canWrite ? _self.canWrite : canWrite // ignore: cast_nullable_to_non_nullable
as bool,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,cacheError: null == cacheError ? _self.cacheError : cacheError // ignore: cast_nullable_to_non_nullable
as String,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,cursor: null == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,principalId: null == principalId ? _self.principalId : principalId // ignore: cast_nullable_to_non_nullable
as String,channelId: null == channelId ? _self.channelId : channelId // ignore: cast_nullable_to_non_nullable
as String,spaceTitle: null == spaceTitle ? _self.spaceTitle : spaceTitle // ignore: cast_nullable_to_non_nullable
as String,chatTitle: null == chatTitle ? _self.chatTitle : chatTitle // ignore: cast_nullable_to_non_nullable
as String,readThrough: null == readThrough ? _self.readThrough : readThrough // ignore: cast_nullable_to_non_nullable
as String,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as LocalFailureCode?,failureRetry: null == failureRetry ? _self.failureRetry : failureRetry // ignore: cast_nullable_to_non_nullable
as bool,invitationRole: null == invitationRole ? _self.invitationRole : invitationRole // ignore: cast_nullable_to_non_nullable
as String,initialSetup: null == initialSetup ? _self.initialSetup : initialSetup // ignore: cast_nullable_to_non_nullable
as bool,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Discovery?,serverIcon: freezed == serverIcon ? _self.serverIcon : serverIcon // ignore: cast_nullable_to_non_nullable
as ServerIcon?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<Content>,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<Channel>,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<String>,unreadCounts: null == unreadCounts ? _self.unreadCounts : unreadCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,sendStatus: null == sendStatus ? _self.sendStatus : sendStatus // ignore: cast_nullable_to_non_nullable
as MessageSendStatus,canQueue: null == canQueue ? _self.canQueue : canQueue // ignore: cast_nullable_to_non_nullable
as bool,pendingMessages: null == pendingMessages ? _self.pendingMessages : pendingMessages // ignore: cast_nullable_to_non_nullable
as List<PendingMessage>,outboxError: null == outboxError ? _self.outboxError : outboxError // ignore: cast_nullable_to_non_nullable
as String,outboxSources: null == outboxSources ? _self.outboxSources : outboxSources // ignore: cast_nullable_to_non_nullable
as List<OutboxScope>,outboxRecoveryTarget: null == outboxRecoveryTarget ? _self.outboxRecoveryTarget : outboxRecoveryTarget // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
