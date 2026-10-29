import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/extensions_p1/actions.dart';
import 'package:space_client/src/extensions_p1/document.dart';
import 'package:space_client/src/extensions_p1/strict_json.dart';
import 'package:space_client/ui/extensions_p1.dart';

Map<String, dynamic> source() => jsonDecode(File('test/fixtures/extensions_p1/ui.json').readAsStringSync()) as Map<String,dynamic>;
ExtensionDocument parse(Map<String,dynamic> value) => ExtensionDocument.parse(utf8.encode(jsonEncode(value)), {'vote'});

void main() {
  test('Строгий JSON не теряет дубликаты, хвост и бюджет', () {
    for (final raw in ['{"a":1,"a":2}',r'{"a":1,"\u0061":2}','{} {}','{"n":NaN}','[${'['*9}0${']'*9}]']) {
      expect(() => extensionJson(utf8.encode(raw)), throwsFormatException);
    }
    expect(() => extensionJson([255]),throwsFormatException);
    expect(() => extensionJson(List.filled(16385,32)),throwsFormatException);
  });

  test('Версии, неизвестные поля и команды отклоняются', () {
    for (final change in <void Function(Map<String,dynamic>)>[
      (d) => d['ui_api']='space.ui.v99',
      (d) => d['script']='execute()',
      (d) => d['body'][0]['children'][1]['command']='grant_admin',
      (d) => d['body'][0]['children'][0]['url']='https://example.com',
      (d) => d['body'][0]['children'][0]['id']='vote',
      (d) => d['body'][0]['children'][0]['label_key']='missing',
    ]) {
      final d=source(); change(d); expect(() => parse(d),throwsFormatException);
    }
  });

  test('Необязательный неизвестный компонент имеет проверяемый fallback', () {
    final d=source();
    d['body']=[{'id':'optional','component':'future.v9','required':false,'fallback':{'id':'safe','component':'text.v1','label_key':'title'}}];
    expect(parse(d).body.single.component,'text.v1');
    d['body'][0]['required']=true;
    expect(() => parse(d),throwsFormatException);
  });

  test('Лимит узлов и семантика Unicode текста', () {
    final d=source();
    d['strings']['en']['title']='😀'*512;
    expect(parse(d).text('fr','title'),'😀'*512);
    d['body']=List.generate(33,(i)=>{'id':'n$i','component':'text.v1','label_key':'title'});
    expect(() => parse(d),throwsFormatException);
  });

  testWidgets('Локализация, источник, семантика и клавиатура', (tester) async {
    var calls=0;
    final actions=ExtensionActions({'vote':() async {calls++;}});
    addTearDown(actions.close);
    final semantics=tester.ensureSemantics();addTearDown(semantics.dispose);
    await tester.pumpWidget(MaterialApp(home:Scaffold(body:ExtensionPanel(document:parse(source()),actions:actions,locale:'ru',originLabel:'Расширение: Опросы',errorText:'Повторите действие'))));
    expect(find.text('Выберите время'),findsOneWidget);
    expect(find.text('Расширение: Опросы'),findsOneWidget);
    expect(find.bySemanticsLabel('Проголосовать'),findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(calls,1);
  });

  testWidgets('Масштаб 3x и узкий экран сохраняют действие', (tester) async {
    tester.view.physicalSize=const Size(320,600);tester.view.devicePixelRatio=1;
    addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
    final actions=ExtensionActions({'vote':() async {}});addTearDown(actions.close);
    await tester.pumpWidget(MaterialApp(home:MediaQuery(data:const MediaQueryData(textScaler:TextScaler.linear(3)),child:Scaffold(body:ExtensionPanel(document:parse(source()),actions:actions,locale:'de',originLabel:'Extension: Polls',errorText:'Retry')))));
    await tester.pumpAndSettle();
    expect(find.text('Vote'),findsOneWidget);
    expect(tester.takeException(),isNull);
  });

  test('Двойное действие, отказ и закрытие Cubit', () async {
    final pending=Completer<void>();var calls=0;
    final actions=ExtensionActions({'vote':(){calls++;return pending.future;}});
    final running=actions.invoke('vote');await actions.invoke('vote');
    expect(calls,1);expect(actions.state,isA<ExtensionRunning>());
    await actions.close();pending.complete();await running;
    final failing=ExtensionActions({'vote':() async {throw StateError('secret');}});
    await failing.invoke('vote');expect(failing.state,isA<ExtensionFailed>());
    await failing.invoke('unregistered');expect(failing.state,isA<ExtensionFailed>());
    await failing.close();
  });
}
