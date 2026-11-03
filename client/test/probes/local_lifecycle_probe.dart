import 'dart:convert';
import 'dart:io';

import 'package:space_client/src/extensions_p1/local_lifecycle_types.dart';

import '../support/local_lifecycle_fixture.dart';

Future<void> main(List<String> args) async {
  final fixture = LifecycleFixture(args[0]);
  try {
    switch (args[1]) {
      case 'setup':
        await fixture.act(LocalLifecycleAction.install);
        await fixture.act(LocalLifecycleAction.prepare, plan: fixture.plan());
        await fixture.act(LocalLifecycleAction.advance);
      case 'publish':
        await fixture.act(
          LocalLifecycleAction.publish,
          checkpoint: (phase) {
            if (phase != args[2]) return;
            stdout.writeln('checkpoint:$phase');
            stdin.readLineSync();
          },
        );
      case 'read':
        stdout.writeln(jsonEncode(fixture.entry));
      default:
        throw ArgumentError('mode');
    }
  } finally {
    fixture.host.close();
  }
}
