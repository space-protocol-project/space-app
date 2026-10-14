import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// Любой возможный синтаксис оставляем полноценному Markdown-обработчику.
final _markdownSyntax = RegExp(
  r'[\n\r\t\\`*_{}\[\]<>()#+|~:/&@]| {2}|^\s|^[-=]|^\d+[.)]|www\.',
);

class MessageMarkdown extends StatelessWidget {
  const MessageMarkdown({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paragraph = TextStyle(
      fontSize: 15,
      height: 1.45,
      color: colors.onSurface,
    );
    if (!_markdownSyntax.hasMatch(text)) {
      return SelectionArea(child: Text(text, style: paragraph));
    }
    return SelectionArea(
      child: MarkdownBody(
        data: text,
        selectable: false,
        softLineBreak: true,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          p: paragraph,
          code: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 13,
            color: colors.onSurface,
          ),
          a: TextStyle(
            color: colors.primary,
            decoration: TextDecoration.underline,
          ),
          codeblockDecoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Внешние изображения не загружаются автоматически из чужого сообщения.
        imageBuilder: (_, _, alt) => Text(
          alt?.isNotEmpty == true ? '🖼 $alt' : '🖼',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTapLink: (_, href, _) {
          final uri = Uri.tryParse(href ?? '');
          if (uri != null &&
              ['https', 'http'].contains(uri.scheme) &&
              uri.host.isNotEmpty &&
              uri.userInfo.isEmpty) {
            unawaited(
              launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              ).catchError((_) => false),
            );
          }
        },
      ),
    );
  }
}
