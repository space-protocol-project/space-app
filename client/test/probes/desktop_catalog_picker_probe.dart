import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:space_client/src/extensions_p1/desktop_catalog.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_host.dart';
import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';

import '../support/local_lifecycle_fixture.dart';

Future<void> main() async {
  if (Platform.environment['GITHUB_ACTIONS'] != 'true') exit(2);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: Scaffold(body: Text('Space Catalog CI'))));
  await WidgetsBinding.instance.endOfFrame;
  final root = Platform.environment['CATALOG_DRILL']!;
  final picker = DesktopCatalogPicker(
    Platform.environment['SPACE_CATALOG_HELPER']!,
  );
  final fixture = LifecycleFixture('$root/registry', picker: picker);
  try {
    await fixture.act(LocalLifecycleAction.install);
    await fixture.act(LocalLifecycleAction.enable);
    await fixture.act(LocalLifecycleAction.grant);
    final id = fixture.authority.confirmedRoot!;
    late String handle;
    await fixture.host.listCatalog(fixture.session, 'games', id, (page) {
      handle = page.entries.single.handle;
    });
    late String value;
    await fixture.host.readCatalog(
      fixture.session,
      'games',
      id,
      handle,
      (chunk) {
        value = utf8.decode(chunk.bytes);
      },
      offset: 0,
      limit: 128,
    );
    if (value != 'catalog-native-ui') throw StateError('WrongSelection');
    await fixture.act(LocalLifecycleAction.revoke, root: id);
    await picker.stopped;
    if (picker.selectedPath(id) != null) throw StateError('RootStillOpen');
    await File('$root/picker.json').writeAsString(
      jsonEncode({'system_dialog': 'GTK', 'read': true, 'revoked': true}),
      flush: true,
    );
  } catch (error) {
    stderr.writeln('Catalog UI: ${error.runtimeType}');
    exit(1);
  } finally {
    fixture.host.close();
  }
  exit(0);
}
