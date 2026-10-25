import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

import 'files.dart';
import 'generated/space/v1/space.pb.dart';
import 'participant_profiles.dart';
import 'profile_avatar.dart';

part 'member_profile_controller.freezed.dart';

enum ProfileProblem { none, taken, invalid, avatar, conflict, unavailable }

enum AvatarEdit { keep, replace, remove }

@freezed
abstract class MemberProfileState with _$MemberProfileState {
  const MemberProfileState._();
  const factory MemberProfileState({
    @Default('') String nickname,
    @Default('') String draftName,
    ParticipantProfile? profile,
    @Default([]) List<int> avatar,
    @Default(AvatarEdit.keep) AvatarEdit avatarEdit,
    @Default(false) bool loading,
    @Default(false) bool preparing,
    @Default(false) bool saving,
    @Default(false) bool loaded,
    @Default(false) bool saved,
    @Default(ProfileProblem.none) ProfileProblem problem,
  }) = _MemberProfileState;

  bool get dirty => draftName != nickname || avatarEdit != AvatarEdit.keep;
  bool get busy => loading || saving || preparing;
  List<int> get previewAvatar => switch (avatarEdit) {
    AvatarEdit.keep => profile?.avatarPng ?? const [],
    AvatarEdit.replace => avatar,
    AvatarEdit.remove => const [],
  };
}

class MemberProfileController extends Cubit<MemberProfileState> {
  MemberProfileController(this.session) : super(const MemberProfileState()) {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (state.loaded && !state.dirty && !state.busy) unawaited(load());
    });
  }
  final ParticipantProfiles session;
  Timer? _timer;
  int _generation = 0, _image = 0, _edits = 0;
  ParticipantProfiles get api => session;

  Future<void> load({bool keepDraft = true}) async {
    if (state.busy) return;
    final generation = ++_generation;
    emit(
      state.copyWith(loading: true, saved: false, problem: ProfileProblem.none),
    );
    try {
      final source = api;
      final value = checkedParticipantProfile(
        await source.getParticipantProfile(),
        principal: source.profilePrincipalId,
      );
      final name = value.displayName;
      if (isClosed || generation != _generation) return;
      _loaded(value, name, keepDraft);
    } catch (error) {
      if (!isClosed && generation == _generation) {
        emit(state.copyWith(loading: false, problem: _problem(error)));
      }
    }
  }

  void _loaded(ParticipantProfile value, String name, bool keepDraft) {
    final preserve = keepDraft && state.draftName != state.nickname;
    emit(
      state.copyWith(
        profile: value,
        nickname: name,
        draftName: preserve ? state.draftName : name,
        loading: false,
        loaded: true,
        avatarEdit: keepDraft ? state.avatarEdit : AvatarEdit.keep,
      ),
    );
  }

  void editName(String name) {
    if (isClosed || name == state.draftName) return;
    _edits++;
    emit(
      state.copyWith(
        draftName: name,
        saved: false,
        problem: ProfileProblem.none,
      ),
    );
  }

  Future<void> selectAvatar(SpaceFile file) async {
    if (state.saving || isClosed) return;
    final generation = ++_image;
    emit(
      state.copyWith(
        preparing: true,
        saved: false,
        problem: ProfileProblem.none,
      ),
    );
    try {
      final bytes = await prepareProfileAvatar(file);
      if (isClosed || generation != _image) return;
      _edits++;
      emit(
        state.copyWith(
          avatar: bytes,
          avatarEdit: AvatarEdit.replace,
          preparing: false,
        ),
      );
    } catch (_) {
      if (!isClosed && generation == _image) {
        emit(state.copyWith(preparing: false, problem: ProfileProblem.avatar));
      }
    }
  }

  void avatarFailed() {
    if (!isClosed) emit(state.copyWith(problem: ProfileProblem.avatar));
  }

  void removeAvatar() {
    if (state.saving || isClosed) return;
    _image++;
    _edits++;
    emit(
      state.copyWith(
        avatarEdit: AvatarEdit.remove,
        avatar: const [],
        preparing: false,
        saved: false,
        problem: ProfileProblem.none,
      ),
    );
  }

  Future<ParticipantProfile> _save(String name) async {
    final source = api;
    final request = UpdateParticipantProfileRequest(
      displayName: name,
      expectedRevision: state.profile?.revision ?? Int64.ZERO,
      removeAvatar: state.avatarEdit == AvatarEdit.remove,
    );
    if (state.avatarEdit == AvatarEdit.replace) {
      request.avatarPng = state.avatar;
    }
    return checkedParticipantProfile(
      await source.updateParticipantProfile(request),
      principal: source.profilePrincipalId,
    );
  }

  Future<void> save(String nickname) async {
    if (!state.loaded || state.busy || isClosed) return;
    final name = nickname.trim();
    if (!validProfileName(name)) {
      emit(state.copyWith(problem: ProfileProblem.invalid));
      return;
    }
    editName(name);
    final generation = ++_generation, edits = _edits;
    emit(
      state.copyWith(saving: true, saved: false, problem: ProfileProblem.none),
    );
    try {
      final value = await _save(name);
      if (isClosed || generation != _generation) return;
      _saved(value, name, edits);
    } catch (error) {
      if (!isClosed && generation == _generation) {
        emit(state.copyWith(saving: false, problem: _problem(error)));
      }
    }
  }

  void _saved(ParticipantProfile value, String name, int edits) {
    final unchanged = edits == _edits;
    final stored = value.displayName;
    emit(
      state.copyWith(
        profile: value,
        nickname: stored,
        saving: false,
        saved: unchanged,
        draftName: unchanged ? stored : state.draftName,
        avatarEdit: unchanged ? AvatarEdit.keep : state.avatarEdit,
        avatar: unchanged ? const [] : state.avatar,
      ),
    );
  }

  ProfileProblem _problem(Object error) {
    if (error is FormatException) return ProfileProblem.invalid;
    if (error is! GrpcError) return ProfileProblem.unavailable;
    return switch (error.code) {
      StatusCode.alreadyExists => ProfileProblem.taken,
      StatusCode.invalidArgument => ProfileProblem.invalid,
      StatusCode.aborted => ProfileProblem.conflict,
      _ => ProfileProblem.unavailable,
    };
  }

  @override
  Future<void> close() {
    _generation++;
    _image++;
    _timer?.cancel();
    return super.close();
  }
}
