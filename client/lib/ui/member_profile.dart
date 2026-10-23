import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/core.dart';
import 'components.dart';

enum ProfileProblem { none, taken, invalid, unavailable }

class MemberProfileState {
  const MemberProfileState({
    this.nickname = '',
    this.loading = false,
    this.saving = false,
    this.loaded = false,
    this.saved = false,
    this.problem = ProfileProblem.none,
  });
  final String nickname;
  final bool loading, saving, loaded, saved;
  final ProfileProblem problem;
}

class MemberProfileController extends Cubit<MemberProfileState> {
  MemberProfileController(this.session) : super(const MemberProfileState());
  final MemberProfile session;

  Future<void> load() async {
    if (state.loading || state.saving) return;
    emit(const MemberProfileState(loading: true));
    try {
      final nickname = await session.getNickname();
      if (!isClosed) emit(MemberProfileState(nickname: nickname, loaded: true));
    } catch (_) {
      if (!isClosed) {
        emit(const MemberProfileState(problem: ProfileProblem.unavailable));
      }
    }
  }

  Future<void> save(String nickname) async {
    if (!state.loaded || state.saving) return;
    final previous = state.nickname;
    emit(MemberProfileState(nickname: previous, loaded: true, saving: true));
    try {
      await session.setNickname(nickname.trim());
      if (!isClosed) {
        emit(
          MemberProfileState(
            nickname: nickname.trim(),
            loaded: true,
            saved: true,
          ),
        );
      }
    } catch (error) {
      if (!isClosed) {
        emit(
          MemberProfileState(
            nickname: previous,
            loaded: true,
            problem: _problem(error),
          ),
        );
      }
    }
  }

  void edited() {
    if (!state.saved && state.problem == ProfileProblem.none) return;
    emit(MemberProfileState(nickname: state.nickname, loaded: state.loaded));
  }

  ProfileProblem _problem(Object error) {
    if (error is! GrpcError) return ProfileProblem.unavailable;
    return switch (error.code) {
      StatusCode.alreadyExists => ProfileProblem.taken,
      StatusCode.invalidArgument => ProfileProblem.invalid,
      _ => ProfileProblem.unavailable,
    };
  }
}

class MemberProfileCard extends StatelessWidget {
  const MemberProfileCard({super.key, required this.controller});
  final ChatController controller;
  @override
  Widget build(BuildContext context) => BlocBuilder<ChatController, ChatState>(
    bloc: controller,
    builder: (context, state) {
      final session = controller.memberProfile;
      if (session == null) return const SizedBox.shrink();
      return _MemberProfileForm(key: ObjectKey(session), session: session);
    },
  );
}

class _MemberProfileForm extends StatefulWidget {
  const _MemberProfileForm({super.key, required this.session});
  final MemberProfile session;
  @override
  State<_MemberProfileForm> createState() => _MemberProfileFormState();
}

class _MemberProfileFormState extends State<_MemberProfileForm> {
  late final profile = MemberProfileController(widget.session)..load();
  final nickname = TextEditingController();
  @override
  void dispose() {
    profile.close();
    nickname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<MemberProfileController, MemberProfileState>(
        bloc: profile,
        listenWhen: (before, after) => before.loading && after.loaded,
        listener: (context, state) => nickname.text = state.nickname,
        builder: _profileForm,
      );

  Widget _profileForm(BuildContext context, MemberProfileState state) =>
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              key: const ValueKey('member-nickname'),
              controller: nickname,
              onChanged: (_) => profile.edited(),
              enabled: state.loaded && !state.saving,
              maxLength: 40,
              decoration: InputDecoration(
                labelText: context.strings.serverNickname,
                helperText: context.strings.nicknameUniqueHelp,
                helperMaxLines: 3,
              ),
            ),
            const SizedBox(height: 12),
            ..._profileStatus(context, state),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: state.loaded && !state.saving
                  ? () => profile.save(nickname.text)
                  : null,
              child: Text(context.strings.saveNickname),
            ),
            if (!state.loaded && !state.loading)
              TextButton(
                onPressed: profile.load,
                child: Text(context.strings.retryProfile),
              ),
          ],
        ),
      );

  List<Widget> _profileStatus(BuildContext context, MemberProfileState state) =>
      [
        if (state.loading || state.saving) const LinearProgressIndicator(),
        if (state.problem != ProfileProblem.none)
          Text(
            problemText(context, state.problem),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (state.saved) Text(context.strings.nicknameSaved),
      ];

  String problemText(BuildContext context, ProfileProblem problem) =>
      switch (problem) {
        ProfileProblem.taken => context.strings.nicknameTaken,
        ProfileProblem.invalid => context.strings.nicknameInvalid,
        _ => context.strings.nicknameFailed,
      };
}
