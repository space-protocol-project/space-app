import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';

import '../l10n/strings.dart';
import '../src/community_reactions.dart';
import 'emoji_picker.dart';

class CommunityReactionScope extends StatefulWidget {
  const CommunityReactionScope({
    super.key,
    required this.api,
    required this.channel,
    required this.contents,
    required this.active,
    required this.child,
  });
  final CommunityReactionApi? api;
  final String channel;
  final Iterable<CommunityContentReference> contents;
  final bool active;
  final Widget child;

  @override
  State<CommunityReactionScope> createState() => _CommunityReactionScopeState();
}

class _CommunityReactionScopeState extends State<CommunityReactionScope> {
  CommunityReactionsController? controller;
  Timer? timer;
  String? scopeId;

  void _create() {
    final api = widget.api;
    scopeId = api?.scopeId;
    controller = api == null
        ? null
        : CommunityReactionsController(api, widget.channel);
    _select();
  }

  void _select() => unawaited(
    controller?.select(
      widget.contents,
      active: widget.active && widget.channel.isNotEmpty,
    ),
  );

  @override
  void initState() {
    super.initState();
    _create();
    timer = Timer.periodic(const Duration(seconds: 10), (_) {
      unawaited(controller?.refresh());
    });
  }

  @override
  void didUpdateWidget(covariant CommunityReactionScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.api, widget.api) ||
        oldWidget.channel != widget.channel ||
        scopeId != widget.api?.scopeId) {
      unawaited(controller?.close());
      _create();
    } else {
      _select();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    unawaited(controller?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _Reactions(controller: controller, child: widget.child);
}

class _Reactions extends InheritedWidget {
  const _Reactions({required this.controller, required super.child});
  final CommunityReactionsController? controller;
  @override
  bool updateShouldNotify(_Reactions oldWidget) =>
      controller != oldWidget.controller;
}

class CommunityReactionBar extends StatelessWidget {
  const CommunityReactionBar({
    super.key,
    required this.content,
    this.enabled = true,
  });
  final CommunityContentReference content;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<_Reactions>()
        ?.controller;
    if (controller == null) return const SizedBox.shrink();
    return BlocBuilder<CommunityReactionsController, CommunityReactionsState>(
      bloc: controller,
      builder: (context, state) => _bar(context, controller, state),
    );
  }

  Widget _bar(
    BuildContext context,
    CommunityReactionsController controller,
    CommunityReactionsState state,
  ) {
    final key = communityReactionKey(content);
    final entry = state.entries[key];
    final error = state.errors[key] ?? state.loadError;
    final busy = state.busy.contains(key);
    final retry = state.retryable.contains(key);
    final writable = enabled && entry?.canReact == true && !busy && !retry;
    if (_empty(entry, writable, error, busy)) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _choices(context, controller, entry, writable, busy),
          if (error != null) _failure(context, controller, error, busy, retry),
        ],
      ),
    );
  }

  bool _empty(
    CommunityReactionState? entry,
    bool writable,
    Object? error,
    bool busy,
  ) {
    if (error != null || busy) return false;
    return entry == null || (entry.reactions.isEmpty && !writable);
  }

  Widget _choices(
    BuildContext context,
    CommunityReactionsController controller,
    CommunityReactionState? entry,
    bool writable,
    bool busy,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (final reaction in entry?.reactions ?? <CommunityReaction>[])
        _chip(controller, reaction, writable),
      if (writable)
        IconButton(
          key: ValueKey('reaction-add-${communityReactionKey(content)}'),
          tooltip: context.strings.addReaction,
          icon: const Icon(Icons.add_reaction_outlined, size: 20),
          onPressed: () => _pick(context, controller),
        ),
      if (busy)
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
    ],
  );

  Widget _chip(
    CommunityReactionsController controller,
    CommunityReaction reaction,
    bool writable,
  ) => InputChip(
    key: ValueKey(
      'reaction-${communityReactionKey(content)}-${reaction.emoji}',
    ),
    selected: reaction.selected,
    label: Text('${reaction.emoji} ${reaction.count}'),
    onSelected: writable
        ? (_) => unawaited(controller.toggle(content, reaction.emoji))
        : null,
  );

  Widget _failure(
    BuildContext context,
    CommunityReactionsController controller,
    Object error,
    bool busy,
    bool retry,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _error(context, error),
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      TextButton(
        key: ValueKey('reaction-retry-${communityReactionKey(content)}'),
        onPressed: busy
            ? null
            : () => unawaited(
                retry ? controller.retry(content) : controller.refresh(),
              ),
        child: Text(context.strings.communityReactionsRetry),
      ),
    ],
  );

  String _error(BuildContext context, Object error) => switch (error) {
    GrpcError(code: StatusCode.aborted) =>
      context.strings.communityReactionsConflict,
    GrpcError(
      code: StatusCode.permissionDenied ||
          StatusCode.unauthenticated ||
          StatusCode.notFound ||
          StatusCode.failedPrecondition,
    ) =>
      context.strings.communityReactionsDenied,
    _ => context.strings.communityReactionsFailure,
  };

  Future<void> _pick(
    BuildContext context,
    CommunityReactionsController controller,
  ) async {
    final emoji = await pickEmoji(context);
    if (emoji != null && context.mounted) {
      await controller.toggle(content, emoji);
    }
  }
}
