import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:space_client/src/archive_documents.dart';
import 'package:space_client/src/archive_transfer_cubit.dart';
import 'package:space_client/l10n/app_localizations.dart';
import 'package:space_client/ui/android_archive_transfer.dart';

class Documents implements ArchiveDocuments {
  @override
  void Function(int)? progress;
  ArchiveWorkspace? current;
  Completer<bool>? saving;
  int prepared = 0, discarded = 0, cancelled = 0, completed = 0;
  @override
  Future<ArchiveWorkspace?> status() async => current;
  @override
  Future<ArchiveWorkspace> prepare() async {
    prepared++;
    return current = const ArchiveWorkspace(ArchiveMode.exporting, ArchivePhase.preparing, '/private/archive', false);
  }
  @override
  Future<ArchiveWorkspace?> pick() async => current = const ArchiveWorkspace(
    ArchiveMode.importing, ArchivePhase.ready, '/private/input', true,
  );
  @override
  Future<void> ready() async { current = ArchiveWorkspace(current!.mode, ArchivePhase.ready, current!.path, true); }
  @override
  Future<void> applying() async { current = ArchiveWorkspace(current!.mode, ArchivePhase.applying, current!.path, true); }
  @override
  Future<bool> save() async => saving == null ? true : saving!.future;
  @override
  Future<void> discard() async { discarded++; current = null; }
  @override
  Future<void> complete() async { completed++; current = null; }
  @override
  Future<void> acknowledgeCleanup() async {}
  @override
  Future<void> cancel() async {
    cancelled++;
    saving?.completeError(PlatformException(code: 'cancelled'));
  }
  @override
  void dispose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Future<void> noAction(String path, String password, void Function(String) progress, Future<void> Function() beforeCommit) async {}
  test('Экспорт сохраняется при отмене SAF и возобновляется без повторной остановки ключей', () async {
    final files = Documents();
    var exports = 0;
    final first = ArchiveTransferCubit(files, export: (_, _, _, _) async { exports++; }, restore: noAction);
    await first.prepare('password');
    expect(first.state.pending!.complete, isTrue);
    files.saving = Completer<bool>();
    final saving = first.save();
    await Future<void>.delayed(Duration.zero);
    files.progress?.call(2147483648);
    expect(first.state.bytes, 2147483648);
    await first.cancel();
    await saving;
    expect(first.state.error, isNull);
    expect(first.state.pending, isNotNull);
    expect(files.discarded, 0);
    await first.close();
    files.saving = null;
    final second = ArchiveTransferCubit(files, export: (_, _, _, _) async { exports++; }, restore: noAction);
    await second.load();
    await second.save();
    expect(second.state.saved, isTrue);
    expect(exports, 1);
    expect(files.prepared, 1);
    await second.close();
  });
  test('Отмена запрещена во время изменения ключей; второй контроллер не начинает перенос', () async {
    final files = Documents(), barrier = Completer<void>();
    final first = ArchiveTransferCubit(files, export: (_, _, _, _) => barrier.future, restore: noAction);
    final running = first.prepare('password');
    await Future<void>.delayed(Duration.zero);
    await first.cancel();
    expect(files.cancelled, 0);
    final secondFiles = Documents();
    final second = ArchiveTransferCubit(secondFiles, export: noAction, restore: noAction);
    await second.prepare('password');
    expect(second.state.error, isStateError);
    expect(secondFiles.prepared, 0);
    barrier.complete();
    await running;
    await first.close();
    await second.close();
  });
  test('Ошибка применения сохраняет тот же архив; повтор удаляет копию только после успеха', () async {
    final files = Documents();
    var attempts = 0;
    final cubit = ArchiveTransferCubit(files, export: noAction, restore: (_, _, _, beforeCommit) async {
      await beforeCommit();
      if (++attempts == 1) throw StateError('Запись прервана');
    });
    await cubit.pick();
    await cubit.apply('password');
    expect(cubit.state.error, isStateError);
    expect(files.current!.phase, ArchivePhase.applying);
    expect(files.completed, 0);
    await cubit.apply('password');
    expect(attempts, 2);
    expect(files.completed, 1);
    expect(cubit.state.finished, isTrue);
    await cubit.close();
  });
  test('Ошибка подготовки не удаляет pending и позволяет повтор', () async {
    final files = Documents();
    var attempts = 0;
    final cubit = ArchiveTransferCubit(files, restore: noAction, export: (_, _, _, _) async {
      if (++attempts == 1) throw StateError('Остановка до commit');
    });
    await cubit.prepare('password');
    expect(files.discarded, 0);
    await cubit.prepare('password');
    expect(attempts, 2);
    expect(files.prepared, 1);
    await cubit.close();
  });
  test('Неверный пароль до записи данных позволяет отказаться от импортированной копии', () async {
    final files = Documents();
    final cubit = ArchiveTransferCubit(files, export: noAction, restore: (_, _, _, _) async {
      throw const FormatException('Пароль не подходит');
    });
    await cubit.pick();
    await cubit.apply('wrong');
    expect(files.current!.phase, ArchivePhase.ready);
    expect(files.discarded, 0);
    await cubit.discard();
    expect(files.current, isNull);
    await cubit.close();
  });
  test('Канал передаёт только команды, строгие метаданные и 64-битный прогресс', () async {
    final calls = <MethodCall>[];
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(AndroidArchiveDocuments.channel, (call) async {
      calls.add(call);
      if (call.method == 'status') return {'mode': 'export', 'phase': 'ready', 'path': '/private/archive', 'complete': true};
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(AndroidArchiveDocuments.channel, null));
    final files = AndroidArchiveDocuments();
    expect((await files.status())!.mode, ArchiveMode.exporting);
    await files.cancel();
    expect(calls.map((call) => call.method), ['status', 'cancel']);
    expect(calls.every((call) => call.arguments == null), isTrue);
    expect(() => ArchiveWorkspace.parse({'mode': 'export', 'phase': 'ready', 'path': '/x', 'complete': true, 'extra': 1}), throwsFormatException);
    files.dispose();
  });
  for (final locale in [const Locale('ru'), const Locale('en'), const Locale('zh')]) {
    testWidgets('Сохранённый экспорт виден после запуска, узкий экран и крупный шрифт $locale', (tester) async {
      tester.view.physicalSize = const Size(360, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final files = Documents()..current = const ArchiveWorkspace(
        ArchiveMode.exporting, ArchivePhase.ready, '/private/archive', true,
      );
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(body: SingleChildScrollView(child: AndroidArchiveTransfer(
            export: noAction, restore: noAction, documents: files,
          )))),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(tester.takeException(), isNull);
      expect(files.discarded, 0);
      await tester.pumpWidget(const SizedBox());
    });
  }
}
