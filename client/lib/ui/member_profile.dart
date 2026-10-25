import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/member_avatar.dart';

import '../src/member_profile_controller.dart';
import '../src/file_picker.dart';
export '../src/member_profile_controller.dart';

import '../l10n/strings.dart';
import '../src/chat_controller.dart';
import '../src/core.dart';
import 'components.dart';

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
  final ParticipantProfiles session;
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
        listenWhen: (before, after) => before.draftName != after.draftName,
        listener: (context, state) {
          if (identical(state, profile.state) &&
              nickname.text != state.draftName) {
            nickname.text = state.draftName;
          }
        },
        builder: _profileForm,
      );

  Widget _profileForm(BuildContext context, MemberProfileState state) =>
      SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar(context, state),
            const SizedBox(height: 20),
            TextField(
              key: const ValueKey('member-nickname'),
              controller: nickname,
              onChanged: profile.editName,
              enabled: state.loaded && !state.busy,
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: state.loaded && !state.busy
                      ? () => profile.save(nickname.text)
                      : null,
                  child: Text(context.strings.saveProfile),
                ),
                TextButton(
                  onPressed: state.busy ? null : profile.load,
                  child: Text(context.strings.retryProfile),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(context.strings.profileSpaceHelp),
          ],
        ),
      );

  List<Widget> _profileStatus(BuildContext context, MemberProfileState state) =>
      [
        if (state.busy) const LinearProgressIndicator(),
        if (state.problem != ProfileProblem.none)
          Text(
            problemText(context, state.problem),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        if (state.saved) Text(context.strings.profileSaved),
      ];

  String problemText(BuildContext context, ProfileProblem problem) =>
      switch (problem) {
        ProfileProblem.taken => context.strings.nicknameTaken,
        ProfileProblem.invalid => context.strings.nicknameInvalid,
        ProfileProblem.avatar => context.strings.avatarInvalid,
        ProfileProblem.conflict => context.strings.profileConflict,
        _ => context.strings.nicknameFailed,
      };
  Widget _avatar(BuildContext context, MemberProfileState state) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(context.strings.profileAvatar),
      const SizedBox(height: 12),
      Wrap(
        spacing: 16,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          MemberAvatar(data: state.previewAvatar, radius: 32),
          OutlinedButton.icon(
            key: const ValueKey('profile-pick-avatar'),
            onPressed: state.loaded && !state.busy ? _chooseAvatar : null,
            icon: const Icon(Icons.image_outlined),
            label: Text(context.strings.chooseAvatar),
          ),
          TextButton(
            key: const ValueKey('profile-remove-avatar'),
            onPressed: !state.busy && state.previewAvatar.isNotEmpty
                ? profile.removeAvatar
                : null,
            child: Text(context.strings.removeAvatar),
          ),
        ],
      ),
    ],
  );

  Future<void> _chooseAvatar() async {
    try {
      final file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(
            label: 'PNG / JPEG',
            extensions: ['png', 'jpg', 'jpeg'],
            mimeTypes: ['image/png', 'image/jpeg'],
          ),
        ],
      );
      if (mounted && file != null) await profile.selectAvatar(file);
    } catch (_) {
      if (mounted) profile.avatarFailed();
    }
  }
}
