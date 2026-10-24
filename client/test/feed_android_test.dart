import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/feed.dart';
import 'package:space_client/ui/feed_management.dart';

import 'feed_test.dart' show FakeFeed;

Widget mobile(Widget child) => MaterialApp(
  theme: ThemeData(platform: TargetPlatform.android),
  locale: const Locale('ru'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(body: child),
);

void viewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetViewInsets);
}

void main() {
  testWidgets(
    'Android: системный Назад возвращает список и сохраняет черновики',
    (tester) async {
      viewport(tester, const Size(390, 844));
      await tester.pumpWidget(mobile(FeedArea(api: FakeFeed())));
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('feed-text'));
      final dynamic area = tester.state(find.byType(FeedArea));
      await tester.enterText(field, 'Черновик публикации');
      await area.controller.open('post');
      await tester.pumpAndSettle();
      await tester.enterText(field, 'Черновик комментария');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(area.controller.state.post, isNull);
      expect(
        tester.widget<TextField>(field).controller!.text,
        'Черновик публикации',
      );
      await area.controller.open('post');
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(field).controller!.text,
        'Черновик комментария',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('Android: неактивная лента не перехватывает Назад у меню', (
    tester,
  ) async {
    viewport(tester, const Size(390, 844));
    final api = FakeFeed();
    var active = true;
    late StateSetter update;
    var menuClosed = false;
    await tester.pumpWidget(
      mobile(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return PopScope(
              canPop: active,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop && !active) menuClosed = true;
              },
              child: FeedArea(api: api, active: active),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final dynamic area = tester.state(find.byType(FeedArea));
    await area.controller.open('post');
    update(() => active = false);
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(menuClosed, true);
    expect(area.controller.state.post!.id, 'post');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final size in [const Size(320, 640), const Size(640, 360)]) {
    testWidgets('Android: ввод с клавиатурой доступен на $size', (
      tester,
    ) async {
      viewport(tester, size);
      await tester.pumpWidget(mobile(FeedArea(api: FakeFeed())));
      await tester.pumpAndSettle();
      final field = find.byKey(const ValueKey('feed-text'));
      await tester.ensureVisible(field);
      await tester.enterText(field, 'Текст с экранной клавиатуры');
      tester.view.viewInsets = FakeViewPadding(bottom: size.height * 0.45);
      await tester.pumpAndSettle();
      await tester.ensureVisible(field);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final rect = tester.getRect(field);
      expect(rect.bottom, lessThanOrEqualTo(size.height * 0.55));
      expect(
        tester.widget<TextField>(field).controller!.text,
        'Текст с экранной клавиатуры',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('Android: диалог прав помещается при открытой клавиатуре', (
    tester,
  ) async {
    viewport(tester, const Size(320, 640));
    await tester.pumpWidget(
      mobile(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showFeedManagement(
              context,
              FakeFeed(),
              'first',
              action: 'policy',
            ),
            child: const Text('Права'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Права'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'участник');
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.byType(TextField)).bottom,
      lessThanOrEqualTo(360),
    );
    expect(
      tester.getRect(find.byType(OverflowBar)).bottom,
      lessThanOrEqualTo(360),
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(FeedManagementDialog), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
