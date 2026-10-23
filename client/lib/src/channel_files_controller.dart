import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'core.dart';
import 'rpc_clients.dart';

part 'channel_files_controller.freezed.dart';

@Freezed(equal: false)
abstract class ChannelFilesState with _$ChannelFilesState {
  const ChannelFilesState._();
  const factory ChannelFilesState({
    @Default([]) List<Asset> files,
    @Default({}) Map<String, String> authors,
    @Default('') String author,
    @Default('') String cursor,
    @Default(false) bool busy,
    @Default('') String error,
    @Default(true) bool more,
  }) = _ChannelFilesState;
}

class ChannelFilesController extends Cubit<ChannelFilesState> {
  ChannelFilesController(this.session, this.channel)
    : super(const ChannelFilesState());
  final AttachmentSession session;
  final String channel;
  int generation = 0;

  Future<void> selectAuthor(String author) async {
    if (isClosed) return;
    generation++;
    emit(ChannelFilesState(author: author, authors: state.authors));
    await load();
  }

  Future<void> load() async {
    if (isClosed || state.busy || !state.more) return;
    final before = state;
    final requestGeneration = generation;
    emit(before.copyWith(busy: true, error: ''));
    try {
      final reply = await session.listChannelAssets(
        ListChannelAssetsRequest(
          channelId: channel,
          authorId: before.author,
          after: before.cursor,
        ),
      );
      if (isClosed || requestGeneration != generation) return;
      emit(
        before.copyWith(
          files: [...before.files, ...reply.assets],
          authors: reply.authors,
          cursor: reply.nextCursor,
          more: reply.nextCursor.isNotEmpty,
          error: '',
        ),
      );
    } catch (error) {
      if (isClosed || requestGeneration != generation) return;
      emit(before.copyWith(error: error.toString()));
    }
  }
}
