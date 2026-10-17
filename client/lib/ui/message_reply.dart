import 'package:flutter/material.dart';

import '../l10n/strings.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/message_summary.dart';

class MessageReply extends StatelessWidget {
  const MessageReply({
    super.key,
    required this.message,
    this.onJump,
    this.onCancel,
  });
  final Content? message;
  final VoidCallback? onJump, onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              button: onJump != null,
              child: InkWell(
                onTap: onJump,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 6, 8, 6),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: colors.primary, width: 3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message?.participantNames[message?.authorId] ??
                            message?.authorId ??
                            context.strings.replyMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _summary(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (onCancel != null)
            IconButton(
              tooltip: context.strings.cancelReply,
              onPressed: onCancel,
              icon: const Icon(Icons.close, size: 18),
            ),
        ],
      ),
    );
  }

  String _summary(BuildContext context) {
    final target = message;
    if (target == null) return context.strings.replyUnavailable;
    if (target.deleted) return context.strings.messageDeleted;
    return messageSummary(target);
  }
}
