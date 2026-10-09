import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_admin_ui/space_admin_ui.dart';
import 'package:space_api/space_api.dart';

Map<String, dynamic> copy(Map<String, dynamic> value) =>
    jsonDecode(jsonEncode(value));
List<Map<String, dynamic>> defaults() => [
  {
    'role': 'member',
    'permissions': {
      'visible': true,
      'read': true,
      'write': true,
      'manage': false,
    },
  },
  {
    'role': 'reader',
    'permissions': {
      'visible': true,
      'read': true,
      'write': false,
      'manage': false,
    },
  },
];

class ChannelServer {
  final channels = <String, Map<String, dynamic>>{
    'general': {
      'id': 'general',
      'title': 'Общий чат',
      'revision': '1',
      'position': 0,
    },
  };
  final access = <String, List<Map<String, dynamic>>>{'general': defaults()};
  Future<Map<String, dynamic>> call(
    String path, {
    Map<String, dynamic>? body,
    String? method,
  }) async {
    final uri = Uri.parse(path);
    if (uri.path == '/api/v1/space/members') {
      return {
        'members': [
          {'principalId': 'u_${'0' * 64}', 'role': 'member'},
        ],
      };
    }
    if (uri.path == '/api/v1/channels') {
      if (method == 'POST') {
        final id = body!['channelId'] as String;
        channels[id] = {
          'id': id,
          'title': body['title'],
          'position': body['position'],
          'revision': '1',
          'archived': false,
          'publicPreview': false,
        };
        access[id] = defaults();
        return {'channel': copy(channels[id]!)};
      }
      return {'channels': channels.values.map(copy).toList()};
    }
    final id = uri.path.split('/')[4];
    final c = channels[id]!;
    if (method == 'PATCH' || method == 'PUT') {
      if (body!['expectedRevision'] != c['revision']) {
        throw SpaceApiError(409, 'Конфликт');
      }
      c['revision'] = '${int.parse(c['revision'] as String) + 1}';
      if (method == 'PATCH') {
        c.addAll({
          'title': body['title'],
          'position': body['position'],
          'archived': body['archived'],
          'publicPreview': body['publicPreview'],
        });
      } else {
        access[id] = (jsonDecode(jsonEncode(body['rules'])) as List)
            .map((r) => Map<String, dynamic>.from(r as Map))
            .toList();
      }
    }
    if (uri.path.endsWith('/access')) {
      return {'channelId': id, 'revision': c['revision'], 'rules': access[id]};
    }
    return {'channel': copy(c)};
  }
}

Future<void> press(WidgetTester tester, String label) async {
  tester.testTextInput.hide();
  await tester.pump();
  await tester.ensureVisible(find.text(label));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> toggle(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(ValueKey(key)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'Каналы: создание, зависимости прав, архив и конфликт без потери формы',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final server = ChannelServer();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ChannelsPanel(call: server.call),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await press(tester, 'Создать чат-канал');
      await tester.enterText(
        find.byKey(const ValueKey('new-channel-id')),
        'team',
      );
      await tester.enterText(
        find.byKey(const ValueKey('new-channel-title')),
        'Рабочая группа',
      );
      await press(tester, 'Создать канал');
      expect(server.channels.containsKey('team'), true);
      await toggle(tester, 'rule-0-read');
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('rule-0-write')),
            )
            .value,
        false,
      );
      await toggle(tester, 'rule-0-visible');
      await toggle(tester, 'rule-0-manage');
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('rule-0-visible')),
            )
            .value,
        true,
      );
      expect(
        tester
            .widget<CheckboxListTile>(find.byKey(const ValueKey('rule-0-read')))
            .value,
        false,
      );
      await press(tester, 'Сохранить права');
      expect(server.access['team']!.first['permissions']['manage'], true);
      await tester.ensureVisible(find.text('Архивировать канал'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Архивировать канал'));
      await tester.pumpAndSettle();
      await press(tester, 'Сохранить канал');
      expect(server.channels['team']!['archived'], true);
      server.channels['team']!['revision'] = '99';
      await tester.ensureVisible(find.byKey(const ValueKey('channel-title')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('channel-title')),
        'Несохранённое название',
      );
      await press(tester, 'Сохранить канал');
      expect(
        find.text(
          'Канал или права уже изменены. Загрузите их заново; несохранённые поля остаются в форме.',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('channel-title')))
            .controller!
            .text,
        'Несохранённое название',
      );
      expect(server.channels['team']!['title'], 'Рабочая группа');
      await press(tester, 'Рабочая группа');
      expect(
        tester
            .widget<TextField>(find.byKey(const ValueKey('channel-title')))
            .controller!
            .text,
        'Несохранённое название',
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
