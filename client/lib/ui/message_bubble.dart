import '../l10n/strings.dart';

import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.author,
    required this.mine,
    this.grouped = false,
    this.sentAt,
    this.accepted = false,
  });
  final String text, author;
  final bool mine, grouped, accepted;
  final DateTime? sentAt;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, box) => Row(
        mainAxisAlignment: mine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            SizedBox(
              width: 32,
              child: grouped
                  ? null
                  : CircleAvatar(
                      radius: 16,
                      backgroundColor: colors.surfaceContainerHighest,
                      child: Icon(
                        Icons.person_outline,
                        size: 18,
                        color: colors.onSurface,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: box.maxWidth * (box.maxWidth < 500 ? .85 : .72),
              ),
              child: CustomPaint(
                painter: _BubblePaint(
                  mine,
                  mine ? colors.primaryContainer : colors.surfaceContainerHigh,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!mine && !grouped) ...[
                        Text(
                          author,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: colors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      SelectableText(
                        text,
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.45,
                          color: colors.onSurface,
                        ),
                      ),
                      if (sentAt != null || accepted)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (sentAt != null)
                                Tooltip(
                                  message:
                                      '${MaterialLocalizations.of(context).formatFullDate(sentAt!)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(sentAt!))}',
                                  child: Text(
                                    MaterialLocalizations.of(context)
                                        .formatTimeOfDay(
                                          TimeOfDay.fromDateTime(sentAt!),
                                        ),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              if (accepted) ...[
                                const SizedBox(width: 6),
                                Tooltip(
                                  message: context.strings.messageAccepted,
                                  child: Icon(
                                    Icons.check,
                                    size: 14,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BubblePaint extends CustomPainter {
  const _BubblePaint(this.mine, this.color);
  final bool mine;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final body = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      );
    final edge = mine ? size.width : 0.0;
    final tail = Path()
      ..moveTo(edge, size.height - 16)
      ..lineTo(edge + (mine ? 6 : -6), size.height)
      ..lineTo(edge + (mine ? -16 : 16), size.height)
      ..close();
    canvas.drawPath(
      Path.combine(PathOperation.union, body, tail),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_BubblePaint oldDelegate) =>
      oldDelegate.mine != mine || oldDelegate.color != color;
}
