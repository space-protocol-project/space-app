import 'message_context_menu.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';
import '../src/markdown_policy.dart';

// Любой возможный синтаксис оставляем полноценному Markdown-обработчику.
final _markdownSyntax = RegExp(
  r'[\n\r\t\\`*_{}\[\]<>()#+|~:/&@]| {2}|^\s|^[-=]|^\d+[.)]|www\.',
);

class MessageMarkdown extends StatelessWidget {
  const MessageMarkdown({super.key, required this.text,this.highlightedNames=const [],this.style});
  final String text;
  final List<String> highlightedNames;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final paragraph = TextStyle(
      fontSize: 15,
      height: 1.45,
      color: colors.onSurface,
    ).merge(style);
    if (!_markdownSyntax.hasMatch(text)||!canFormatMarkdown(text)) {
      return SelectionArea(
        contextMenuBuilder: MessageContextMenu.contains(context)
            ? (_, _) => const SizedBox.shrink()
            : (_, state) => AdaptiveTextSelectionToolbar.selectableRegion(
                selectableRegionState: state,
              ),
        child: Text(text, style: paragraph),
      );
    }
    return SelectionArea(
      contextMenuBuilder: MessageContextMenu.contains(context)
          ? (_, _) => const SizedBox.shrink()
          : (_, state) => AdaptiveTextSelectionToolbar.selectableRegion(
              selectableRegionState: state,
            ),
      child: MarkdownBody(
        data: text,
        extensionSet: md.ExtensionSet.commonMark,
        inlineSyntaxes: highlightedNames.isEmpty?const []:[_MentionSyntax(highlightedNames)],
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
          final uri = safeMarkdownLink(href);
          if (uri != null) {
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

// Только визуальное выделение уже проверенных обращений. Новых уведомлений
// или действий по имени этот синтаксис не создаёт; исходные UTF-16 spans не меняются.
class _MentionSyntax extends md.InlineSyntax {
  _MentionSyntax(List<String> names):super((names.toSet().toList()..sort((a,b)=>b.length.compareTo(a.length))).map(RegExp.escape).join('|'));
  @override
  bool onMatch(md.InlineParser parser,Match match) {
    parser.addNode(md.Element.text('strong',match[0]!));
    return true;
  }
}
