import 'package:flutter/services.dart';

enum ArchiveMode { exporting, importing }
enum ArchivePhase { preparing, ready, applying }

class ArchiveWorkspace {
  const ArchiveWorkspace(this.mode, this.phase, this.path, this.complete);
  final ArchiveMode mode;
  final ArchivePhase phase;
  final String path;
  final bool complete;

  factory ArchiveWorkspace.parse(Object? value) {
    if (value case {
      'mode': String mode,
      'phase': String phase,
      'path': String path,
      'complete': bool complete,
    } when value.length == 4 && path.isNotEmpty) {
      return ArchiveWorkspace(
        switch (mode) {
          'export' => ArchiveMode.exporting,
          'import' => ArchiveMode.importing,
          _ => throw const FormatException('Неизвестный режим архива'),
        }, ArchivePhase.values.byName(phase), path, complete,
      );
    }
    throw const FormatException('Повреждено состояние переноса');
  }
}

abstract interface class ArchiveDocuments {
  set progress(void Function(int)? callback);
  Future<ArchiveWorkspace?> status();
  Future<ArchiveWorkspace> prepare();
  Future<ArchiveWorkspace?> pick();
  Future<bool> save();
  Future<void> ready();
  Future<void> applying();
  Future<void> discard();
  Future<void> complete();
  Future<void> acknowledgeCleanup();
  Future<void> cancel();
  void dispose();
}

class AndroidArchiveDocuments implements ArchiveDocuments {
  AndroidArchiveDocuments() {
    _owner = this;
    channel.setMethodCallHandler((call) async {
      if (call.method == 'progress' && call.arguments is int) {
        progress?.call(call.arguments as int);
      }
    });
  }
  static const channel = MethodChannel('space/archive-documents');
  static AndroidArchiveDocuments? _owner;
  @override
  void Function(int)? progress;
  Future<ArchiveWorkspace?> _workspace(String method) async {
    final value = await channel.invokeMethod<Object?>(method);
    return value == null ? null : ArchiveWorkspace.parse(value);
  }
  @override
  Future<ArchiveWorkspace?> status() => _workspace('status');
  @override
  Future<ArchiveWorkspace> prepare() async => (await _workspace('prepare'))!;
  @override
  Future<ArchiveWorkspace?> pick() => _workspace('import');
  @override
  Future<bool> save() async => await channel.invokeMethod<bool>('save') == true;
  @override
  Future<void> ready() => channel.invokeMethod<void>('ready');
  @override
  Future<void> applying() => channel.invokeMethod<void>('applying');
  @override
  Future<void> discard() => channel.invokeMethod<void>('discard');
  @override
  Future<void> complete() => channel.invokeMethod<void>('complete');
  @override
  Future<void> acknowledgeCleanup() => channel.invokeMethod<void>('acknowledgeCleanup');
  @override
  Future<void> cancel() => channel.invokeMethod<void>('cancel');
  @override
  void dispose() {
    if (identical(_owner, this)) {
      _owner = null;
      channel.setMethodCallHandler(null);
    }
  }
}
