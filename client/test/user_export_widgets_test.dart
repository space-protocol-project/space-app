import 'dart:async';

import 'package:flutter/material.dart' hide View;
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/generated/space/v1/space.pb.dart'
    show Channel, ChannelPermissions, View;
import 'package:space_client/ui/user_export.dart';

import 'feed_test.dart' show app;
import 'user_export_test.dart' show ExportApi;

void main() {
  testWidgets(
    'Экспорт готовится на узком экране, смена контекста очищает результат',
    (tester) async {
      tester.view.physicalSize = const Size(320, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ExportApi(), changes = StreamController<void>.broadcast();
      var active = true;
      addTearDown(changes.close);
      await tester.pumpWidget(
        app(
          UserExportDialog(
            api: api,
            channels: [
              Channel(
                id: 'general',
                title: 'Общий чат',
                views: [View(type: 'chat')],
                permissions: ChannelPermissions(read: true, visible: true),
              ),
            ],
            available: () => active,
            changes: changes.stream,
            chooseDestination: () async => null,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('prepare-user-export')),
      );
      await tester.tap(find.byKey(const ValueKey('prepare-user-export')));
      await tester.pumpAndSettle();
      expect(find.text('Записей подготовлено: 2'), findsOneWidget);
      expect(tester.takeException(), isNull);
      active = false;
      changes.add(null);
      await tester.pumpAndSettle();
      expect(find.text('Записей подготовлено: 2'), findsNothing);
      final save = tester.widget<FilledButton>(
        find.byKey(const ValueKey('save-user-export')),
      );
      expect(save.onPressed, isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
