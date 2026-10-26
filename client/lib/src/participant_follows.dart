import 'dart:convert';
import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'participant_follows_api.dart';
import 'generated/space/v1/feed.pb.dart';
export 'participant_follows_api.dart';
part 'participant_follows.freezed.dart';
part 'participant_follows_validation.dart';

@freezed
abstract class FollowAuthorsState with _$FollowAuthorsState {
  const factory FollowAuthorsState({
    @Default({}) Map<String,bool> entries,
    @Default(0) int revision,
    @Default(false) bool busy,
    Object? error,
  }) = _FollowAuthorsState;
}

class FollowAuthorsController extends Cubit<FollowAuthorsState> {
  FollowAuthorsController(this.api,this.channel,List<String> ids,{required this.available})
    : ids=List.unmodifiable(ids),scope=api.scopeId,super(const FollowAuthorsState());
  final ParticipantFollowApi api;
  final String channel,scope;
  final List<String> ids;
  final bool Function() available;
  int _generation=0;
  bool _matches(int generation) {
    if (isClosed || generation!=_generation) return false;
    if (api.scopeId==scope && available()) return true;
    ++_generation;emit(const FollowAuthorsState());return false;
  }
  Future<void> refresh() async {
    if (!_matches(_generation)||state.busy||ids.isEmpty) return;
    final generation=++_generation;
    emit(state.copyWith(busy:true,error:null));
    try {
      final page=await _states(generation);
      if (!_matches(generation)) return;
      if (page==null) return;
      final entries=_checkedAuthors(page,ids,api.principalId);
      emit(FollowAuthorsState(entries:entries,revision:page.revision.toInt()));
    } catch(error) {
      if (_matches(generation)) emit(FollowAuthorsState(error:error));
    }
  }
  Future<GetParticipantFollowStatesResponse?> _states(int generation) async {
    final result=GetParticipantFollowStatesResponse();
    for (var start=0;start<ids.length;start+=50) {
      final end=start+50<ids.length?start+50:ids.length;
      final page=await api.states(channel,ids.sublist(start,end));
      if (!_matches(generation)) return null;
      if (start>0&&page.revision!=result.revision) throw const FormatException('Подписки изменились во время чтения');
      _checkedAuthors(page,ids.sublist(start,end),api.principalId);
      result..revision=page.revision..states.addAll(page.states);
    }
    return result;
  }
  Future<void> toggle(String id) async {
    if (!_matches(_generation)||state.busy||!state.entries.containsKey(id)) return;
    final generation=++_generation;
    final before=state;
    emit(state.copyWith(busy:true,error:null));
    try {
      final response=await api.set(SetParticipantFollowRequest(channelId:channel,principalId:id,
        following:!before.entries[id]!,expectedRevision:Int64(before.revision)));
      if (!_matches(generation)) return;
      _checkedSet(response,id,before.revision,!before.entries[id]!);
      emit(FollowAuthorsState(entries:{...before.entries,id:response.state.following},revision:response.revision.toInt()));
    } catch(error) {
      if (_matches(generation)) emit(FollowAuthorsState(error:error));
    }
  }
  @override
  Future<void> close() {++_generation;return super.close();}
}

enum FollowPageKind { authors, posts }

@freezed
abstract class FollowTimelineState with _$FollowTimelineState {
  const factory FollowTimelineState({
    @Default([]) List<PersonalFeedEntry> entries,
    @Default([]) List<FollowingParticipant> participants,
    @Default('') String next,
    @Default(0) int revision,
    @Default(false) bool loading,
    @Default(false) bool revoked,
    @Default(false) bool capped,
    Object? error,
  }) = _FollowTimelineState;
}

typedef _FollowPage=({List<PersonalFeedEntry> posts,List<FollowingParticipant> authors,String next,int revision});

class FollowTimelineController extends Cubit<FollowTimelineState> {
  FollowTimelineController(this.api,this.kind,{required Set<String> channels,required this.available})
    : channels=Set.unmodifiable(channels),scope=api.scopeId,super(const FollowTimelineState());
  final ParticipantFollowApi api;
  final FollowPageKind kind;
  final Set<String> channels;
  final bool Function() available;
  final String scope;
  int _generation=0;
  final _tokens=<String>{};
  void invalidate() {
    if (isClosed||state.revoked) return;
    ++_generation;_tokens.clear();emit(const FollowTimelineState(revoked:true));
  }
  bool _current(int generation) {
    if (isClosed||generation!=_generation) return false;
    if (api.scopeId!=scope||!available()) invalidate();
    return !state.revoked;
  }
  Future<void> refresh() => _load(false);
  Future<void> more() => _load(true);
  Future<_FollowPage> _page(String token) async {
    if (kind==FollowPageKind.posts) {
      final page=await api.feed(token);
      return (posts:page.entries,authors:[],next:page.nextPageToken,revision:page.revision.toInt());
    }
    final page=await api.following(token);
    return (posts:[],authors:page.participants,next:page.nextPageToken,revision:page.revision.toInt());
  }
  Future<void> _load(bool more) async {
    if (!_current(_generation)||state.loading) return;
    if (more && (state.next.isEmpty||state.capped)) return;
    final before=state;
    final generation=++_generation;
    if (!more) _tokens.clear();
    emit((more?before:const FollowTimelineState()).copyWith(loading:true));
    try {
      final next=await _range(more,before,generation);
      if (next!=null&&_current(generation)) emit(next);
    } catch(error) {
      if (_current(generation)) emit(FollowTimelineState(error:error));
    }
  }
  Future<FollowTimelineState?> _range(bool more,FollowTimelineState before,int generation) async {
    var result=more?before:const FollowTimelineState();
    final keep=before.entries.length+before.participants.length;
    do {
      final page=await _page(result.next);
      if (!_current(generation)) return null;
      final previous=result.next;
      result=_checkedFollowPage(page,result,channels,kind,api.principalId);
      _checkCursor(page.next,previous,page.posts.isEmpty&&page.authors.isEmpty);
    } while (!more&&result.next.isNotEmpty&&result.entries.length+result.participants.length<keep);
    return result;
  }
  void _checkCursor(String next,String previous,bool empty) {
    if (next.isEmpty) return;
    if (utf8.encode(next).length>1024||next.contains('\u0000')||empty||next==previous||!_tokens.add(next)) {
      throw const FormatException('Некорректная страница подписок');
    }
  }
  Future<void> unfollow(String id) async {
    if (!_current(_generation)||state.loading) return;
    final before=state;
    final generation=++_generation;
    emit(const FollowTimelineState(loading:true));
    try {
      final response=await api.set(SetParticipantFollowRequest(principalId:id,following:false,expectedRevision:Int64(before.revision)));
      if (!_current(generation)) return;
      _checkedSet(response,id,before.revision,false);
      emit(const FollowTimelineState());
      await refresh();
    } catch(error) {
      if (_current(generation)) emit(FollowTimelineState(error:error));
    }
  }
  @override
  Future<void> close() {++_generation;return super.close();}
}
