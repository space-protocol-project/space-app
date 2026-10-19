import 'dart:io';

import 'package:space_client/src/home_controller.dart';
import 'package:space_client/src/home_network.dart';

import '../../tool/home_transfer_drill.dart' as transfer;

// Подставляет только управление процессом; экспорт, проверку и импорт
// выполняет опубликованный runtime с настоящей PostgreSQL.
class NativeMigrationHome extends HomeController {
  NativeMigrationHome(this.root, this.executable, this.runtime)
    : super(directory: () async => root);
  final Directory root;
  final String executable, runtime;

  @override
  Future<bool> exportData(String path) async {
    await transfer.maintenance(executable, runtime, [
      '-home-export',
      path,
      '-home-data',
      '${root.path}/data',
    ]);
    return true;
  }

  @override
  Future<HomeArchiveInspection?> inspectArchive(String path) =>
      transfer.inspectTransferArchive(executable, path);

  @override
  Future<bool> importData(
    String path, {
    String publicIP = '',
    HomeArchiveInspection? inspection,
  }) async {
    final imported = Directory('${root.path}/transferred');
    await transfer.maintenance(executable, runtime, [
      '-home-import',
      path,
      '-home-import-to',
      imported.path,
      '-public-ip',
      publicIP,
    ]);
    network = await HomeNetwork.read(imported);
    ip = network!.endpoints.first.host;
    await File('${root.path}/home-location.json')
        .writeAsString('{"format":1,"path":"transferred"}');
    return true;
  }
}
