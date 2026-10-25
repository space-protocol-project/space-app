import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_admin_ui/member_avatar.dart';

import '../src/participant_directory.dart';
import '../src/participant_profiles.dart';
import '../src/generated/space/v1/space.pb.dart';

class ParticipantProfileScope extends StatefulWidget {
  const ParticipantProfileScope({
    super.key,
    required this.api,
    required this.channel,
    required this.ids,
    required this.child,
    this.active = true,
  });
  final ParticipantProfiles? api;
  final String channel;
  final Iterable<String> ids;
  final bool active;
  final Widget child;

  @override
  State<ParticipantProfileScope> createState() =>
      _ParticipantProfileScopeState();
}

class _ParticipantProfileScopeState extends State<ParticipantProfileScope> {
  late ParticipantDirectory directory;
  void _create() {
    directory = ParticipantDirectory(widget.api, widget.channel);
    directory.select(widget.ids, active: widget.active);
  }

  @override
  void initState() {
    super.initState();
    _create();
  }

  @override
  void didUpdateWidget(covariant ParticipantProfileScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.api, widget.api) ||
        oldWidget.channel != widget.channel) {
      directory.close();
      _create();
    } else {
      directory.select(widget.ids, active: widget.active);
    }
  }

  @override
  void dispose() {
    directory.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ParticipantDirectory, ParticipantDirectoryState>(
        bloc: directory,
        builder: (context, state) =>
            _Profiles(profiles: state.profiles, child: widget.child),
      );
}

class _Profiles extends InheritedWidget {
  const _Profiles({required this.profiles, required super.child});
  final Map<String, ParticipantProfile> profiles;
  @override
  bool updateShouldNotify(_Profiles oldWidget) =>
      !identical(profiles, oldWidget.profiles);
}

ParticipantProfile? currentParticipantProfile(
  BuildContext context,
  String id,
) => context.dependOnInheritedWidgetOfExactType<_Profiles>()?.profiles[id];

class ParticipantName extends StatelessWidget {
  const ParticipantName({
    super.key,
    required this.principal,
    required this.fallback,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });
  final String principal, fallback;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  @override
  Widget build(BuildContext context) {
    final profile = currentParticipantProfile(context, principal);
    final name = profile == null ? fallback : profile.displayName;
    final label = Text(
      name.isEmpty ? principal : name,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
    return principal.isEmpty
        ? label
        : Tooltip(message: principal, child: label);
  }
}

class ParticipantAvatar extends StatelessWidget {
  const ParticipantAvatar({
    super.key,
    required this.principal,
    this.radius = 16,
    this.fallback,
  });
  final String principal;
  final double radius;
  final Widget? fallback;
  @override
  Widget build(BuildContext context) => MemberAvatar(
    radius: radius,
    fallback: fallback,
    data: currentParticipantProfile(context, principal)?.avatarPng ?? const [],
  );
}
