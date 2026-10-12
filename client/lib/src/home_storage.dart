import 'dart:io';

import 'local_failure.dart';

class HomeSpaceReport {
  const HomeSpaceReport(this.requiredBytes, this.availableBytes);
  final int requiredBytes, availableBytes;
}

class HomeSpaceFailure extends LocalFailure {
  const HomeSpaceFailure(this.report)
    : super(
        LocalFailureCode.homeSpaceLow,
        'Недостаточно места для операции домашнего сервера',
      );
  final HomeSpaceReport report;
}

Future<int> homeDirectoryBytes(Directory directory) async {
  final type = await FileSystemEntity.type(directory.path, followLinks: false);
  if (type == FileSystemEntityType.notFound) return 0;
  if (type != FileSystemEntityType.directory) {
    throw const LocalFailure(
      LocalFailureCode.homeSpaceUnknown,
      'Не удалось проверить каталог данных',
    );
  }
  var bytes = 0;
  await for (final entry in directory.list(
    recursive: true,
    followLinks: false,
  )) {
    if (entry is File) {
      bytes += await entry.length();
    } else if (entry is! Directory) {
      throw const LocalFailure(
        LocalFailureCode.homeSpaceUnknown,
        'Внешние ссылки требуют отдельного сценария',
      );
    }
  }
  return bytes;
}

Future<int> availableHomeBytes(Directory root) async {
  try {
    final ProcessResult result;
    if (Platform.isWindows) {
      // Путь передаётся через окружение, а не вставляется в код PowerShell.
      const script = r'''
Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class SpaceStorageProbe { [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)] [return: MarshalAs(UnmanagedType.Bool)] public static extern bool GetDiskFreeSpaceEx(string path, out ulong available, out ulong total, out ulong free); }'
[System.UInt64]$spaceAvailable=0; [System.UInt64]$spaceTotal=0; [System.UInt64]$spaceFree=0
if (-not [SpaceStorageProbe]::GetDiskFreeSpaceEx($env:SPACE_HOME_STORAGE_PATH,[ref]$spaceAvailable,[ref]$spaceTotal,[ref]$spaceFree)) { throw 'Space storage probe failed' }
[Console]::Write($spaceAvailable.ToString([Globalization.CultureInfo]::InvariantCulture))
''';
      result = await Process.run(
        'powershell.exe',
        ['-NoProfile', '-NonInteractive', '-Command', script],
        environment: {'SPACE_HOME_STORAGE_PATH': root.absolute.path},
      );
      if (result.exitCode != 0) throw const FormatException();
      final bytes = int.parse((result.stdout as String).trim());
      if (bytes < 0) throw const FormatException();
      return bytes;
    }
    result = await Process.run(
      '/bin/df',
      ['-Pk', root.absolute.path],
      environment: {'LC_ALL': 'C'},
    );
    if (result.exitCode != 0) throw const FormatException();
    final line = (result.stdout as String).trim().split('\n').last;
    final match = RegExp(r'\s+\d+\s+\d+\s+(-?\d+)\s+\d+%\s+.+$')
        .firstMatch(line);
    if (match == null) throw const FormatException();
    final blocks = int.parse(match.group(1)!);
    return blocks > 0 ? blocks * 1024 : 0;
  } catch (_) {
    throw const LocalFailure(
      LocalFailureCode.homeSpaceUnknown,
      'Не удалось определить свободное место',
    );
  }
}

class HomeStorage {
  const HomeStorage({this.available = availableHomeBytes});
  final Future<int> Function(Directory) available;
  static const reserve = 256 * 1024 * 1024;
  Future<HomeSpaceReport> check(
    Directory root, {
    int additionalBytes = 0,
    int dataCopies = 3,
  }) async {
    try {
      if (additionalBytes < 0 || dataCopies < 0) throw const FormatException();
      final dataBytes = await homeDirectoryBytes(
        Directory('${root.path}/data'),
      );
      final report = HomeSpaceReport(
        dataBytes * dataCopies + additionalBytes + reserve,
        await available(root),
      );
      if (report.availableBytes < report.requiredBytes) {
        throw HomeSpaceFailure(report);
      }
      return report;
    } on LocalFailure {
      rethrow;
    } catch (_) {
      throw const LocalFailure(
        LocalFailureCode.homeSpaceUnknown,
        'Не удалось оценить место для операции',
      );
    }
  }
}
