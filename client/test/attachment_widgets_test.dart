import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/attachment_widgets.dart';
import 'package:space_client/ui/channel_files.dart';

import 'attachments_test.dart' show FilesSession;
import 'shell_test.dart' show TestController;

class FilesController extends TestController {
  final files = FilesSession();
  @override
  AttachmentSession? get attachmentSession => files;
}

void main() {
  for (final width in [390.0, 1100.0, 1500.0]) {
    testWidgets('Перетаскивание файлов и форма на ширине $width', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final controller = FilesController()..connected = true;
      controller.server(
        Discovery(
          localOrigin('http://127.0.0.1:8080'),
          'srv_files',
          List.filled(32, 1),
        ),
      );
      await tester.pumpWidget(SpaceApp(controller: controller));
      await tester.pumpAndSettle();
      if (width < 760) {
        await tester.tap(find.byType(NavigationDestination).at(1));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('server-inbox-http://127.0.0.1:8080')),
        );
      } else {
        await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      }
      await tester.pumpAndSettle();
      expect(
        find.byType(ChannelFilesPanel),
        width >= 1500 ? findsOneWidget : findsNothing,
      );
      final target = tester.widget<DropTarget>(find.byType(DropTarget));
      expect(target.enable, isTrue);
      target.onDragDone!(
        DropDoneDetails(
          files: List.generate(
            5,
            (i) => DropItemFile.fromData(
              Uint8List.fromList([1, 2, 3]),
              name: 'file-$i.txt',
              path: 'file-$i.txt',
            ),
          ),
          localPosition: Offset.zero,
          globalPosition: Offset.zero,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('5/5'), findsOneWidget);
      expect(find.text('file-0.txt'), findsOneWidget);
      expect(find.byType(AttachmentComposer), findsOneWidget);
      expect(tester.takeException(), isNull);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.tap(find.byKey(const ValueKey('chat-draft')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }
}
