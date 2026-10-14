import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart';
import 'message_bubble.dart';

class FavoriteMessages extends StatelessWidget {
  const FavoriteMessages({
    super.key,
    required this.messages,
    required this.principalId,
    required this.onJump,
    required this.onRemove,
  });
  final List<Content> messages;
  final String principalId;
  final ValueChanged<Content> onJump, onRemove;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: constraints.maxHeight * .65),
        child: SizedBox(
          width: 36,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final message in messages)
                  _FavoriteMarker(
                    key: ValueKey(message.id),
                    message: message,
                    mine: message.authorId == principalId,
                    onJump: () => onJump(message),
                    onRemove: () => onRemove(message),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _FavoriteMarker extends StatefulWidget {
  const _FavoriteMarker({
    super.key,
    required this.message,
    required this.mine,
    required this.onJump,
    required this.onRemove,
  });
  final Content message;
  final bool mine;
  final VoidCallback onJump, onRemove;
  @override
  State<_FavoriteMarker> createState() => _FavoriteMarkerState();
}

class _FavoriteMarkerState extends State<_FavoriteMarker> {
  final overlay = OverlayPortalController();
  final link = LayerLink();
  Timer? closing;
  void show() {
    closing?.cancel();
    overlay.show();
    setState(() {});
  }

  void hide() {
    closing?.cancel();
    closing = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      overlay.hide();
      setState(() {});
    });
  }

  @override
  void dispose() {
    closing?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final author = widget.mine ? context.strings.you : widget.message.authorId;
    return CompositedTransformTarget(
      link: link,
      child: OverlayPortal(
        controller: overlay,
        overlayChildBuilder: (context) => Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.centerRight,
            followerAnchor: Alignment.centerLeft,
            offset: const Offset(8, 0),
            child: MouseRegion(
              onEnter: (_) => show(),
              onExit: (_) => hide(),
              child: SizedBox(
                width: (MediaQuery.sizeOf(context).width - 100).clamp(160, 420),
                child: Material(
                  elevation: 8,
                  color: messageBubbleColor(colors, widget.mine),
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: widget.onJump,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  author,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: context.strings.removeFavorite,
                                onPressed: widget.onRemove,
                                icon: const Icon(Icons.bookmark, size: 18),
                              ),
                            ],
                          ),
                          Text(
                            widget.message.text,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: MouseRegion(
          onEnter: (_) => show(),
          onExit: (_) => hide(),
          child: Semantics(
            label:
                '${context.strings.favoriteMessages}: $author. ${widget.message.text}',
            button: true,
            child: InkWell(
              onTap: widget.onJump,
              onLongPress: show,
              onFocusChange: (focused) => focused ? show() : hide(),
              child: SizedBox(
                height: 20,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: overlay.isShowing ? 28 : 14,
                    height: 3,
                    decoration: BoxDecoration(
                      color: messageMarkerColor(colors, widget.mine),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
