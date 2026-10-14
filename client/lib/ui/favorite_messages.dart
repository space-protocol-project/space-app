import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart';
import 'message_bubble.dart';

class FavoriteMessages extends StatefulWidget {
  const FavoriteMessages({
    super.key,
    required this.messages,
    required this.principalId,
    required this.onJump,
    required this.onRemove,
    this.onPreviewChanged,
  });
  final List<Content> messages;
  final String principalId;
  final ValueChanged<Content> onJump, onRemove;
  final ValueChanged<bool>? onPreviewChanged;
  @override
  State<FavoriteMessages> createState() => _FavoriteMessagesState();
}

class _FavoriteMessagesState extends State<FavoriteMessages> {
  String? selected;
  void previewChanged(String id, bool visible) {
    if (!visible && selected != id) return;
    setState(() => selected = visible ? id : null);
    widget.onPreviewChanged?.call(visible);
  }

  double markerWidth(int index) {
    if (selected == null) return 8;
    final active = widget.messages.indexWhere((m) => m.id == selected);
    return switch ((index - active).abs()) {
      0 => 38,
      1 => 24,
      2 => 14,
      _ => 8,
    };
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: constraints.maxHeight * .65),
        child: SizedBox(
          width: 44,
          child: SingleChildScrollView(
            primary: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, message) in widget.messages.indexed)
                  _FavoriteMarker(
                    key: ValueKey(message.id),
                    message: message,
                    mine: message.authorId == widget.principalId,
                    width: markerWidth(index),
                    selected: selected,
                    onPreviewChanged: (visible) =>
                        previewChanged(message.id, visible),
                    onJump: () => widget.onJump(message),
                    onRemove: () => widget.onRemove(message),
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
    required this.width,
    required this.selected,
    required this.onPreviewChanged,
  });
  final Content message;
  final bool mine;
  final VoidCallback onJump, onRemove;
  final double width;
  final String? selected;
  final ValueChanged<bool> onPreviewChanged;
  @override
  State<_FavoriteMarker> createState() => _FavoriteMarkerState();
}

class _FavoriteMarkerState extends State<_FavoriteMarker> {
  final overlay = OverlayPortalController();
  final link = LayerLink();
  final markerKey = GlobalKey();
  Timer? closing;
  void show() {
    closing?.cancel();
    if (overlay.isShowing) return;
    overlay.show();
    widget.onPreviewChanged(true);
    setState(() {});
  }

  void hide() {
    closing?.cancel();
    closing = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) return;
      overlay.hide();
      widget.onPreviewChanged(false);
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant _FavoriteMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != widget.message.id && overlay.isShowing) {
      overlay.hide();
    }
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
        overlayChildBuilder: (context) => Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _PreviewPlacement(markerRect()),
            child: MouseRegion(
              onEnter: (_) => show(),
              onExit: (_) => hide(),
              child: Focus(
                onFocusChange: (focused) => focused ? show() : hide(),
                onKeyEvent: closeOnEscape,
                child: SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 110).clamp(
                    160,
                    480,
                  ),
                  child: Material(
                    elevation: 8,
                    color: messageBubbleColor(colors, widget.mine),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: jump,
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
                                    widget.message.text
                                        .split('\n')
                                        .firstWhere(
                                          (line) => line.trim().isNotEmpty,
                                          orElse: () => author,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: context.strings.removeFavorite,
                                  onPressed: remove,
                                  icon: const Icon(Icons.bookmark, size: 18),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Text(
                                widget.message.text.split('\n').length > 1
                                    ? widget.message.text
                                          .split('\n')
                                          .skip(1)
                                          .join('\n')
                                    : widget.message.text,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: colors.onSurfaceVariant,
                                  height: 1.65,
                                ),
                              ),
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
        ),
        child: MouseRegion(
          key: markerKey,
          onEnter: (_) => show(),
          onExit: (_) => hide(),
          child: Semantics(
            label:
                '${context.strings.favoriteMessages}: $author. ${widget.message.text}',
            button: true,
            child: Focus(
              onKeyEvent: closeOnEscape,
              child: InkWell(
                onTap: jump,
                onLongPress: show,
                onFocusChange: (focused) => focused ? show() : hide(),
                child: SizedBox(
                  height: 15,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                      width: widget.width,
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
      ),
    );
  }

  void jump() {
    overlay.hide();
    widget.onPreviewChanged(false);
    widget.onJump();
  }

  void remove() {
    overlay.hide();
    widget.onPreviewChanged(false);
    widget.onRemove();
  }

  KeyEventResult closeOnEscape(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    overlay.hide();
    widget.onPreviewChanged(false);
    return KeyEventResult.handled;
  }

  Rect markerRect() {
    final box = markerKey.currentContext?.findRenderObject();
    if (box is! RenderBox) return Rect.zero;
    return box.localToGlobal(Offset.zero) & box.size;
  }
}

class _PreviewPlacement extends SingleChildLayoutDelegate {
  _PreviewPlacement(this.marker);
  final Rect marker;
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(
        maxWidth: math.min(
          480,
          math.max(80, constraints.maxWidth - marker.right - 26),
        ),
        maxHeight: math.max(0, constraints.maxHeight - 24),
      );
  @override
  Offset getPositionForChild(Size size, Size childSize) => Offset(
    (marker.right + 14).clamp(
      12,
      math.max(12, size.width - childSize.width - 12),
    ),
    (marker.center.dy - childSize.height / 2).clamp(
      12,
      math.max(12, size.height - childSize.height - 12),
    ),
  );
  @override
  bool shouldRelayout(_PreviewPlacement oldDelegate) =>
      marker != oldDelegate.marker;
}
