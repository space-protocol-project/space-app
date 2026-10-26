import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/participant_follows.dart';

class ParticipantFollowScope extends StatefulWidget {
  const ParticipantFollowScope({
    super.key,
    required this.api,
    required this.channel,
    required this.ids,
    required this.active,
    required this.available,
    required this.child,
  });
  final ParticipantFollowApi? api;
  final String channel;
  final Iterable<String> ids;
  final bool active;
  final bool Function() available;
  final Widget child;
  @override
  State<ParticipantFollowScope> createState() => _ParticipantFollowScopeState();
}

class _ParticipantFollowScopeState extends State<ParticipantFollowScope> {
  FollowAuthorsController? controller;
  String binding = '';
  Timer? timer;
  void _select() {
    final api = widget.api;
    final ids =
        widget.ids
            .where((id) => id.isNotEmpty && id != api?.principalId)
            .toSet()
            .toList()
          ..sort();
    final next =
        '${api?.scopeId}|${widget.channel}|${widget.active}|${ids.join(',')}';
    if (next == binding) return;
    binding = next;
    unawaited(controller?.close());
    controller = null;
    if (api == null || !widget.active || widget.channel.isEmpty || ids.isEmpty) {
      return;
    }
    controller = FollowAuthorsController(
      api,
      widget.channel,
      ids.take(500).toList(),
      available: () => mounted && widget.active && widget.available(),
    );
    unawaited(controller!.refresh());
  }

  @override
  void initState() {
    super.initState();
    _select();
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => unawaited(controller?.refresh()),
    );
  }

  @override
  void didUpdateWidget(covariant ParticipantFollowScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    _select();
  }

  @override
  void dispose() {
    timer?.cancel();
    unawaited(controller?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _FollowScope(controller: controller, child: widget.child);
}

class _FollowScope extends InheritedWidget {
  const _FollowScope({required this.controller, required super.child});
  final FollowAuthorsController? controller;
  @override
  bool updateShouldNotify(_FollowScope oldWidget) =>
      oldWidget.controller != controller;
}

class ParticipantFollowButton extends StatelessWidget {
  const ParticipantFollowButton({super.key, required this.principal});
  final String principal;
  @override
  Widget build(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<_FollowScope>()
        ?.controller;
    if (controller == null) return const SizedBox.shrink();
    return BlocBuilder<FollowAuthorsController, FollowAuthorsState>(
      bloc: controller,
      builder: (context, state) {
        if (state.error != null) {
          return IconButton(
            onPressed: controller.refresh,
            tooltip: context.strings.followRefresh,
            icon: const Icon(Icons.refresh, size: 18),
          );
        }
        final following = state.entries[principal];
        if (following == null) return const SizedBox.shrink();
        return IconButton(
          key: ValueKey('follow-$principal'),
          onPressed: state.busy ? null : () => controller.toggle(principal),
          tooltip: following
              ? context.strings.followRemove
              : context.strings.followAdd,
          icon: Icon(
            following
                ? Icons.person_remove_outlined
                : Icons.person_add_outlined,
            size: 20,
          ),
        );
      },
    );
  }
}
