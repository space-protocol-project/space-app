import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/strings.dart';
import 'emoji_picker.dart';

class MessageContextMenu extends StatefulWidget {
  const MessageContextMenu({
    super.key,
    required this.child,
    required this.text,
    this.onReact,
    this.onEdit,
    this.onDelete,
    this.onFavorite,
    this.favorite = false,
  });
  final Widget child;
  final String text;
  final ValueChanged<String>? onReact;
  final VoidCallback? onEdit, onDelete, onFavorite;
  final bool favorite;
  static bool contains(BuildContext context) =>
      context.findAncestorStateOfType<_MessageContextMenuState>() != null;
  @override
  State<MessageContextMenu> createState() => _MessageContextMenuState();
}

class _MessageContextMenuState extends State<MessageContextMenu> {
  Timer? timer;
  Offset? start;
  bool open = false;
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> show(Offset position) async {
    if (open || !mounted) return;
    if (widget.text.isEmpty &&
        widget.onReact == null &&
        widget.onEdit == null &&
        widget.onDelete == null &&
        widget.onFavorite == null) {
      return;
    }
    open = true;
    final overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final local = overlay.globalToLocal(position);
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        local.dx,
        local.dy,
        max(0, overlay.size.width - local.dx),
        max(0, overlay.size.height - local.dy),
      ),
      constraints: BoxConstraints(
        minWidth: min(300, overlay.size.width - 32),
        maxWidth: min(340, overlay.size.width - 32),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      items: _items(),
    );
    open = false;
    if (!mounted || value == null) return;
    await _perform(value);
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: (event) {
      timer?.cancel();
      start = event.position;
      if (event.buttons == kSecondaryMouseButton) {
        unawaited(show(event.position));
      }
      if (event.kind == PointerDeviceKind.touch ||
          event.kind == PointerDeviceKind.stylus) {
        timer = Timer(const Duration(milliseconds: 500), () {
          if (mounted) unawaited(show(event.position));
        });
      }
    },
    onPointerMove: (event) {
      if (start != null && (event.position - start!).distance > 10) {
        timer?.cancel();
      }
    },
    onPointerUp: (_) => timer?.cancel(),
    onPointerCancel: (_) => timer?.cancel(),
    child: widget.child,
  );
  List<PopupMenuEntry<String>> _items() => [
    if (widget.onReact != null)
      PopupMenuItem<String>(
        enabled: false,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (final emoji in quickEmoji)
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () => Navigator.pop(context, 'emoji:$emoji'),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            IconButton(
              tooltip: context.strings.emojiPicker,
              onPressed: () => Navigator.pop(context, 'more'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    if (widget.text.isNotEmpty)
      PopupMenuItem(
        value: 'copy',
        child: ListTile(
          leading: const Icon(Icons.copy_outlined),
          title: Text(context.strings.copyMessage),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    if (widget.onFavorite != null)
      PopupMenuItem(
        value: 'favorite',
        child: ListTile(
          leading: const Icon(Icons.star_outline),
          title: Text(
            widget.favorite
                ? context.strings.removeFavorite
                : context.strings.addFavorite,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    if (widget.onEdit != null)
      PopupMenuItem(
        value: 'edit',
        child: ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: Text(context.strings.editMessage),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    if (widget.onDelete != null)
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            context.strings.deleteMessage,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
  ];

  Future<void> _perform(String value) async {
    if (value.startsWith('emoji:')) {
      widget.onReact?.call(value.substring(6));
      return;
    }
    switch (value) {
      case 'more':
        final emoji = await pickEmoji(context);
        if (mounted && emoji != null) widget.onReact?.call(emoji);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: widget.text));
        if (mounted) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            SnackBar(content: Text(context.strings.messageCopied)),
          );
        }
      case 'edit':
        widget.onEdit?.call();
      case 'delete':
        widget.onDelete?.call();
      case 'favorite':
        widget.onFavorite?.call();
    }
  }
}
