import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../l10n/strings.dart';
import '../src/community_favorites.dart';
import 'community_reactions.dart';

class CommunityFavoriteScope extends StatefulWidget {
  const CommunityFavoriteScope({
    super.key,
    required this.api,
    required this.channel,
    required this.contents,
    required this.active,
    required this.child,
  });
  final CommunityFavoriteApi? api;
  final String channel;
  final Iterable<CommunityContentReference> contents;
  final bool active;
  final Widget child;

  @override
  State<CommunityFavoriteScope> createState() => _CommunityFavoriteScopeState();
}

class _CommunityFavoriteScopeState extends State<CommunityFavoriteScope> {
  CommunityFavoritesController? controller;
  Timer? timer;
  String? scopeId;

  void _create() {
    final api = widget.api;
    scopeId = api?.scopeId;
    controller = api == null
        ? null
        : CommunityFavoritesController(api, widget.channel);
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
  void didUpdateWidget(covariant CommunityFavoriteScope oldWidget) {
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
      _Favorites(controller: controller, child: widget.child);
}

class _Favorites extends InheritedWidget {
  const _Favorites({required this.controller, required super.child});
  final CommunityFavoritesController? controller;
  @override
  bool updateShouldNotify(_Favorites oldWidget) =>
      controller != oldWidget.controller;
}

class CommunityFavoriteButton extends StatelessWidget {
  const CommunityFavoriteButton({
    super.key,
    required this.content,
    this.onChanged,
  });
  final CommunityContentReference content;
  final VoidCallback? onChanged;
  @override
  Widget build(BuildContext context) {
    final controller = context
        .dependOnInheritedWidgetOfExactType<_Favorites>()
        ?.controller;
    if (controller == null) return const SizedBox.shrink();
    return BlocBuilder<CommunityFavoritesController, CommunityFavoritesState>(
      bloc: controller,
      builder: (context, state) => _button(context, controller, state),
    );
  }

  Widget _button(
    BuildContext context,
    CommunityFavoritesController controller,
    CommunityFavoritesState state,
  ) {
    final key = communityFavoriteKey(content);
    final entry = state.entries[key];
    final error = state.errors[key] ?? state.loadError;
    final busy = state.busy.contains(key);
    if (entry == null && error == null) return const SizedBox.shrink();
    return IconButton(
      key: ValueKey('favorite-$key'),
      tooltip: error != null
          ? context.strings.communityFavoriteRetry
          : entry?.saved == true
          ? context.strings.communityFavoriteRemove
          : context.strings.communityFavoriteAdd,
      icon: Icon(
        error != null
            ? Icons.sync_problem
            : entry?.saved == true
            ? Icons.bookmark
            : Icons.bookmark_border,
      ),
      onPressed: busy
          ? null
          : () => unawaited(_activate(controller, state, error)),
    );
  }

  Future<void> _activate(
    CommunityFavoritesController controller,
    CommunityFavoritesState state,
    Object? error,
  ) async {
    final key = communityFavoriteKey(content);
    if (error == null) {
      await controller.toggle(content);
    } else if (state.retryable.contains(key)) {
      await controller.retry(content);
    } else {
      await controller.recover(content);
    }
    if (controller.isClosed) return;
    final current = controller.state;
    if (current.entries.containsKey(key) && !current.errors.containsKey(key)) {
      onChanged?.call();
    }
  }
}

class CommunityContentActions extends StatelessWidget {
  const CommunityContentActions({
    super.key,
    required this.content,
    this.reactionsEnabled = true,
  });
  final CommunityContentReference content;
  final bool reactionsEnabled;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: CommunityReactionBar(
          content: content,
          enabled: reactionsEnabled,
        ),
      ),
      CommunityFavoriteButton(content: content),
    ],
  );
}
