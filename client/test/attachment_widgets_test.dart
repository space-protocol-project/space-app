import 'package:cross_file/cross_file.dart' show FileSystemXFile;

import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/src/rpc_clients.dart';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_client/app.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/ui/attachment_widgets.dart';
import 'package:space_client/ui/channel_files.dart';
import 'package:space_client/ui/space_appearance.dart';

import 'attachments_test.dart' show FilesSession;
import 'shell_test.dart' show TestController;

class FilesController extends TestController {
  final files = FilesSession();
  bool allowFiles = true;
  @override
  bool get attachmentsEnabled => allowFiles;
  @override
  AttachmentSession? get attachmentSession => allowFiles ? files : null;
}

class FailingFilesSession extends FilesSession {
  FailingFilesSession(this.failure);
  Object? failure;
  @override
  Future<ListMyAssetsResponse> listMyAssets(ListMyAssetsRequest request) async {
    final error = failure;
    failure = null;
    if (error != null) throw error;
    return ListMyAssetsResponse();
  }
}

void main() {
  for (final error in [
    const GrpcError.unknown('HTTP 415'),
    const GrpcError.unavailable('network'),
  ]) {
    testWidgets('Мои файлы: понятная ошибка и повтор ${error.code}', (
      tester,
    ) async {
      final session = FailingFilesSession(error);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) =>
                      MyFilesDialog(session: session, channel: 'general'),
                ),
                child: const Text('Открыть'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Открыть'));
      await tester.pumpAndSettle();
      expect(find.textContaining('HTTP 415'), findsNothing);
      expect(find.text('Загрузить ещё'), findsNothing);
      expect(
        find.text(
          error.code == StatusCode.unknown
              ? 'Для списка вложений нужна актуальная версия сервера.'
              : 'Не удалось загрузить вложения. Попробуйте обновить список.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Обновить вложения'));
      await tester.pumpAndSettle();
      expect(
        find.text('Для списка вложений нужна актуальная версия сервера.'),
        findsNothing,
      );
      expect(
        find.text('Не удалось загрузить вложения. Попробуйте обновить список.'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }

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
      final attach = find.byKey(const ValueKey('attach-file-button'));
      expect(
        tester.widget<IconButton>(attach).icon,
        isA<Icon>().having((icon) => icon.icon, 'icon', Icons.add),
      );
      expect(
        find.ancestor(of: attach, matching: find.byType(GlassSurface)),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AttachmentComposer),
          matching: find.text('Мои файлы'),
        ),
        findsNothing,
      );
      if (width < 760) {
        await tester.tap(find.byKey(const ValueKey('navigation-menu-button')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.widgetWithText(ListTile, 'Обзор').last);
      await tester.pumpAndSettle();
      final mine = find.byKey(const ValueKey('sidebar-my-files'));
      await tester.ensureVisible(mine);
      await tester.tap(mine);
      await tester.pumpAndSettle();
      expect(find.byType(MyFilesDialog), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Закрыть').last);
      await tester.pumpAndSettle();
      final allFiles = find.byKey(const ValueKey('sidebar-channel-files'));
      await tester.ensureVisible(allFiles);
      await tester.tap(allFiles);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(ChannelFilesPanel),
        ),
        findsOneWidget,
      );
      await tester.tap(find.widgetWithText(TextButton, 'Закрыть').last);
      await tester.pumpAndSettle();
      if (width < 760) {
        await tester.tap(find.byKey(const ValueKey('navigation-menu-button')));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.widgetWithText(ListTile, 'Чаты'));
      await tester.pumpAndSettle();
      controller.allowFiles = false;
      controller.publishState();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('attach-file-button')), findsNothing);
      expect(find.byKey(const ValueKey('sidebar-my-files')), findsNothing);
      expect(find.byKey(const ValueKey('sidebar-channel-files')), findsNothing);
      expect(find.byType(ChannelFilesPanel), findsNothing);
      expect(
        tester.widget<DropTarget>(find.byType(DropTarget)).enabled,
        isFalse,
      );
      controller.allowFiles = true;
      controller.publishState();
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('attach-file-button')), findsOneWidget);
      final target = tester.widget<DropTarget>(find.byType(DropTarget));
      expect(target.enabled, isTrue);
      target.onDrop(
        DropDetails(
          operation: DropOperation.copy,
          items: List.generate(
            5,
            (i) => DropFileItem(
              file: _DropTestFile('file-$i.txt'),
              name: 'file-$i.txt',
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

final class _DropTestFile extends FileSystemXFile {
  _DropTestFile(super.path);
  @override
  Future<int> length() async => 3;
  @override
  Future<String> name() async => path;
  @override
  Stream<Uint8List> openRead([int? start, int? end]) =>
      Stream.value(Uint8List.fromList([1, 2, 3]));
}
