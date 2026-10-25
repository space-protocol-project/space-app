import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../files.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../generated/space/v1/community_mentions.pb.dart';

import '../rpc_clients.dart';
import 'client.dart';
import 'files.dart';
import 'local_store.dart';
import 'mentions.dart';

part 'controller.freezed.dart';

sealed class MlsEvent {}

class MlsRefresh extends MlsEvent {}

class MlsCancelRetry extends MlsEvent {}

class MlsSend extends MlsEvent {
  MlsSend(
    this.text,
    this.files, {
    this.reply,
    List<CommunityMention> mentions = const [],
  }) : mentions = List.unmodifiable(
         mentions.map((m) => m.deepCopy()..freeze()),
       );
  final String text;
  final List<SpaceFile> files;
  final Map<String, dynamic>? reply;
  final List<CommunityMention> mentions;
  final done = Completer<bool>();
}

class MlsTrust extends MlsEvent {
  MlsTrust(this.device);
  final MlsDevice device;
}

class MlsInvite extends MlsEvent {
  MlsInvite(this.device);
  final MlsDevice device;
}

class MlsRemove extends MlsEvent {
  MlsRemove(this.device);
  final MlsDevice device;
}

class MlsTransfer extends MlsEvent {
  MlsTransfer(this.device);
  final MlsDevice device;
}

class MlsReact extends MlsEvent {
  MlsReact(this.target, this.emoji, this.active);
  final Map<String, dynamic> target;
  final String emoji;
  final bool active;
}

@freezed
abstract class MlsState with _$MlsState {
  const factory MlsState({
    @Default(false) bool busy,
    @Default('') String error,
    MlsChannelData? data,
    @Default(0) int sent,
    @Default(false) bool recoveryRequired,
  }) = _MlsState;
}

class MlsController extends Bloc<MlsEvent, MlsState> {
  MlsController(this.client, this.channelId, this.groupId)
    : super(const MlsState()) {
    on<MlsEvent>(_handle, transformer: sequential());
  }
  final MlsClient client;
  final String channelId;
  final List<int> groupId;
  bool working = false;

  Future<void> _handle(MlsEvent event, Emitter<MlsState> emit) async {
    working = true;
    if (event is! MlsRefresh || state.data == null) {
      emit(state.copyWith(busy: true));
    }
    var sent = state.sent;
    var accepted = false;
    try {
      await _act(event);
      accepted = true;
      final data = await client.refresh(channelId, groupId);
      sent = _ownMessageCount(data);
      if (emit.isDone) return;
      emit(MlsState(data: data, sent: sent));
    } catch (error) {
      final cached = await _cached();
      if (emit.isDone) return;
      emit(
        MlsState(
          data: cached ?? state.data,
          sent: sent,
          error: _explain(error),
          recoveryRequired: error is MlsRecoveryRequired,
        ),
      );
    } finally {
      working = false;
      if (event is MlsSend && !event.done.isCompleted) {
        event.done.complete(accepted);
      }
    }
  }

  int _ownMessageCount(MlsChannelData data) => data.messages
      .where((message) => message['grant_id'] == client.local.scope['grant_id'])
      .length;

  Future<MlsChannelData?> _cached() async {
    try {
      final document = await client.local.read();
      final channel =
          (document['channels'] as Map)[channelId] as Map<String, dynamic>?;
      if (channel == null) return null;
      final features = channel['joined'] == true
          ? await client.local.messageFeatures(groupId)
          : const MlsMessageFeatures.legacy();
      return MlsChannelData(channel, messageFeatures: features);
    } catch (_) {
      return null;
    }
  }

  String _explain(Object error) {
    if (error is StateError) {
      return error.message.toString().replaceFirst(RegExp(r'^[a-z_]+:\s*'), '');
    }
    if (error is GrpcError && error.code == StatusCode.permissionDenied) {
      return 'Устройство ещё не приглашено или доступ отозван';
    }
    if (error is GrpcError && error.code == StatusCode.aborted) {
      return 'Состав канала изменился. Получите обновления и повторите действие.';
    }
    return 'Не удалось обработать закрытый канал. Проверьте подключение и хранилище.';
  }

  Future<void> _act(MlsEvent event) async {
    switch (event) {
      case MlsRefresh():
        break;
      case MlsCancelRetry():
        await client.cancelRebasedMessages(channelId);
      case MlsTrust():
        await client.trust(event.device);
      case MlsInvite():
        await client.invite(channelId, event.device);
      case MlsRemove():
        await client.remove(channelId, event.device);
      case MlsTransfer():
        await client.transfer(channelId, event.device);
      case MlsReact():
        await client.setReaction(
          channelId,
          event.target,
          event.emoji,
          event.active,
        );
      case MlsSend():
        await MlsFiles(client).send(
          channelId,
          groupId,
          event.text,
          event.files,
          reply: event.reply,
          mentions: event.mentions,
        );
    }
  }
}
