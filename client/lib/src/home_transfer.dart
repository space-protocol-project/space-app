import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import 'home_installation.dart';
import 'home_runtime.dart';
import 'home_update_executor.dart';

class HomeTransfer {
  HomeTransfer(
    this.root,
    this.runtime,
    this.release, {
    this.tool = runHomeTool,
  });
  final Directory root, runtime;
  final HomeRelease release;
  final HomeTool tool;

  Future<void> requireSupport() async {
    final capabilities = await tool(runtime, ['-runtime-info']);
    if (capabilities['portableTransferVersion'] != 1) {
      throw const FormatException(
        'Обновите приложение и runtime для переноса пространства',
      );
    }
  }

  Future<void> exportTo(String destination) async {
    await requireSupport();
    await tool(runtime, [
      '-home-export',
      destination,
      '-home-data',
      '${root.path}/data',
      '-home-runtime',
      runtime.path,
    ]);
  }

  Future<Directory> importFrom(String source, {String publicIP = ''}) async {
    publicIP = publicIP.trim().toLowerCase();
    await _requireEmptyDestination();
    final imported = Directory('${root.path}/transferred');
    if (!await imported.exists()) {
      await requireSupport();
      await tool(runtime, [
        '-home-import',
        source,
        '-home-import-to',
        imported.path,
        '-home-runtime',
        runtime.path,
        if (publicIP.isNotEmpty) ...['-public-ip', publicIP],
      ]);
    }
    await _verifyPreparedImport(imported, source, publicIP);
    await _installImportedRuntime(imported);
    final pending = File('${root.path}/home-location.json.tmp');
    await pending.writeAsString(
      jsonEncode({'format': 1, 'path': 'transferred'}),
      flush: true,
    );
    await pending.rename('${root.path}/home-location.json');
    return imported;
  }

  Future<void> _requireEmptyDestination() async {
    if (await Directory('${root.path}/data').exists() ||
        await File('${root.path}/config.json').exists()) {
      throw const FormatException(
        'Импорт доступен только на компьютере без созданного пространства',
      );
    }
  }

  Future<void> _verifyPreparedImport(
    Directory imported,
    String source,
    String publicIP,
  ) async {
    final receipt = File('${imported.path}/import-source.sha256');
    if (await receipt.length() != 64 ||
        await receipt.readAsString() !=
            (await sha256.bind(File(source).openRead()).first).toString()) {
      throw const FormatException(
        'Подготовленный импорт относится к другому архиву',
      );
    }
    final config = jsonDecode(
      await File('${imported.path}/config.json').readAsString(),
    ) as Map;
    if (publicIP.isNotEmpty && config['ip'] != publicIP) {
      throw const FormatException(
        'Подготовленный импорт относится к другому IP',
      );
    }
    await tool(runtime, [
      '-home-check',
      '-home-data',
      '${imported.path}/data',
      '-home-runtime',
      runtime.path,
    ]);
  }

  Future<void> _installImportedRuntime(Directory imported) async {
    final installation = HomeInstallation(imported);
    final target = installation.runtime(release);
    if (!await target.exists()) {
      await target.parent.create(recursive: true);
      await runtime.rename(target.path);
    }
    if (!await installation.selection.exists()) {
      await installation.selectInitial(release);
    }
  }
}

Future<Directory> resolveHomeLocation(Directory root) async {
  final pointer = File('${root.path}/home-location.json');
  if (!await pointer.exists()) return root;
  if (await pointer.length() > 256) {
    throw const FormatException('Повреждён путь домашнего сервера');
  }
  final record = jsonDecode(await pointer.readAsString()) as Map;
  if (record['format'] != 1 || record['path'] != 'transferred') {
    throw const FormatException('Повреждён путь домашнего сервера');
  }
  final imported = Directory('${root.path}/transferred');
  if (await FileSystemEntity.type(imported.path, followLinks: false) !=
      FileSystemEntityType.directory) {
    throw const FormatException('Импортированное пространство недоступно');
  }
  return imported;
}
