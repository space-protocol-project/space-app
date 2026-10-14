import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart';
import 'message_bubble.dart';
import 'space_appearance.dart';

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
  // Самостоятельный слой не переносит узлы доступности из списка маркеров.
  OverlayEntry? overlay;
  final markers = <String, GlobalKey>{};
  Timer? closing;
  String? selected;
  // Возврат фокуса после закрытия не должен открывать карточку снова.
  String? dismissedFocus;
  Rect anchor = Rect.zero;
  Content? get selectedMessage =>
      widget.messages.where((m) => m.id == selected).firstOrNull;

  void show(Content message) {
    closing?.cancel();
    final box = markers[message.id]?.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    dismissedFocus = null;
    anchor = box.localToGlobal(Offset.zero) & box.size;
    setState(() => selected = message.id);
    if (overlay == null) {
      overlay = OverlayEntry(
        builder: (_) => InheritedTheme.captureAll(context, preview(context)),
      );
      Overlay.of(context).insert(overlay!);
    } else {
      overlay!.markNeedsBuild();
    }
    widget.onPreviewChanged?.call(true);
  }

  void keepOpen() => closing?.cancel();
  void hideLater() {
    closing?.cancel();
    closing = Timer(const Duration(milliseconds: 150), close);
  }

  void close() {
    closing?.cancel();
    if (!mounted) return;
    dismissedFocus = selected ?? dismissedFocus;
    removeOverlay();
    setState(() => selected = null);
    widget.onPreviewChanged?.call(false);
  }

  void markerFocus(Content message, bool focused) {
    if (focused) {
      if (dismissedFocus != message.id) show(message);
      return;
    }
    if (dismissedFocus == message.id) dismissedFocus = null;
    hideLater();
  }

  void jump(Content message) {
    close();
    widget.onJump(message);
  }

  void remove(Content message) {
    close();
    widget.onRemove(message);
  }

  KeyEventResult closeOnEscape(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    close();
    return KeyEventResult.handled;
  }

  @override
  void didUpdateWidget(covariant FavoriteMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (selected != null && selectedMessage == null) {
        close();
      } else {
        overlay?.markNeedsBuild();
      }
    });
  }

  void removeOverlay() {
    overlay?.remove();
    overlay?.dispose();
    overlay = null;
  }

  @override
  void dispose() {
    closing?.cancel();
    removeOverlay();
    super.dispose();
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

  Widget marker(BuildContext context, int index) {
    final message = widget.messages[index];
    final author = message.authorId == widget.principalId
        ? context.strings.you
        : message.authorId;
    return MouseRegion(
      onEnter: (_) => show(message),
      onExit: (_) => hideLater(),
      child: Semantics(
        label: '${context.strings.favoriteMessages}: $author. ${message.text}',
        button: true,
        child: Focus(
          onKeyEvent: closeOnEscape,
          child: InkWell(
            key: markers.putIfAbsent(message.id, GlobalKey.new),
            onTap: () => jump(message),
            onLongPress: () => show(message),
            onFocusChange: (focused) => markerFocus(message, focused),
            child: SizedBox(
              height: 15,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: MediaQuery.disableAnimationsOf(context)
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  width: markerWidth(index),
                  height: 3,
                  color: messageMarkerColor(
                    Theme.of(context).colorScheme,
                    message.authorId == widget.principalId,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget preview(BuildContext context) {
    final message = selectedMessage;
    if (message == null) return const SizedBox.shrink();
    return Positioned.fill(
      child: CustomSingleChildLayout(
        delegate: _PreviewPlacement(anchor),
        child: MouseRegion(
          onEnter: (_) => keepOpen(),
          onExit: (_) => hideLater(),
          child: Focus(
            onKeyEvent: closeOnEscape,
            onFocusChange: (focused) => focused ? keepOpen() : hideLater(),
            child: _FavoriteCard(
              message: message,
              mine: message.authorId == widget.principalId,
              onJump: () => jump(message),
              onRemove: () => remove(message),
            ),
          ),
        ),
      ),
    );
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
                for (var i = 0; i < widget.messages.length; i++)
                  marker(context, i),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.message,
    required this.mine,
    required this.onJump,
    required this.onRemove,
  });
  final Content message;
  final bool mine;
  final VoidCallback onJump, onRemove;
  @override
  Widget build(BuildContext context) {
    final lines = message.text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
    final title = lines.firstOrNull ?? message.authorId;
    final excerpt = lines.length > 1 ? lines.skip(1).join('\n') : message.text;
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GlassSurface(
        radius: 20,
        color: Color.alphaBlend(
          messageMarkerColor(colors, mine).withValues(alpha: .15),
          SpaceAppearance.of(context).glass,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onJump,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      IconButton(
                        tooltip: context.strings.removeFavorite,
                        onPressed: onRemove,
                        icon: const Icon(Icons.bookmark, size: 18),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      excerpt,
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
    );
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
