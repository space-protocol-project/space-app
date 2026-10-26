import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/markdown_policy.dart';
import 'package:space_client/ui/message_markdown.dart';
import 'package:space_client/ui/community_mentions.dart';
import 'package:space_client/src/generated/space/v1/community_mentions.pb.dart';
import 'composer_markdown_test.dart' show NetworkCounter;

void main() {
  test('Ссылки разрешены только HTTP(S), без учётных данных и управляющих символов',() {
    expect(safeMarkdownLink('https://example.org/a?q=1'),isNotNull);
    for(final href in ['javascript:alert(1)','data:text/html,x','file:///keys','intent://app','//example.org','https://user:password@example.org','https://example.org/\npath','https://exam\u202eple.org','mailto:a@example.org']) {
      expect(safeMarkdownLink(href),isNull,reason:href);
    }
  });
  test('Сложный Markdown и чрезмерная вложенность остаются простым текстом',() {
    expect(canFormatMarkdown('**Текст**\n\n- список'),true);
    for(final text in ['x'*32769,'\n'*257,'['*17,'>'*9+' text','`'*257,' '*64+'text','\u0000']) {
      expect(canFormatMarkdown(text),false);
    }
  });
  testWidgets('HTML, SVG и внешние картинки не исполняются и не обращаются к сети',(tester) async {
    final network=NetworkCounter();HttpOverrides.global=network;addTearDown(()=>HttpOverrides.global=null);
    await tester.pumpWidget(const MaterialApp(home:Scaffold(body:MessageMarkdown(text:
      '**Заголовок**\n\n<script>alert(1)</script>\n<img src="https://example.org/pixel">\n<iframe src="https://example.org"></iframe>\n\n![Картинка](https://example.org/pixel.svg)\n\n![Данные](data:image/svg+xml,test)'))));
    await tester.pumpAndSettle();expect(network.requests,0);expect(find.byType(Image),findsNothing);expect(tester.takeException(),isNull);
  });
  testWidgets('Таблицы и расширения GFM выключены, сложный ввод не разбирается',(tester) async {
    await tester.pumpWidget(const MaterialApp(home:Scaffold(body:MessageMarkdown(text:'a | b\n--- | ---\n1 | 2'))));
    await tester.pumpAndSettle();expect(find.byType(Table),findsNothing);
    await tester.pumpWidget(MaterialApp(home:Scaffold(body:MessageMarkdown(text:'['*17))));
    await tester.pumpAndSettle();expect(find.byType(MarkdownBody),findsNothing);
  });
  testWidgets('Форматирование сохраняет текст проверенного упоминания',(tester) async {
    const text='**Привет** @Мария';
    await tester.pumpWidget(MaterialApp(home:Scaffold(body:CommunityMentionText(text,mentions:[CommunityMention(principalId:'maria',displayName:'Мария',start:11,length:6)]))));
    await tester.pumpAndSettle();expect(find.byType(MarkdownBody),findsOneWidget);expect(find.textContaining('@Мария',findRichText:true),findsWidgets);expect(tester.takeException(),isNull);
  });
}
