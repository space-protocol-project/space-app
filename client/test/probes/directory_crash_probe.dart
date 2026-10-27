import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:space_client/src/core.dart';
import 'package:space_client/src/directory_transfer.dart';
import 'package:space_client/src/directory_transfer_qr.dart';
import 'package:space_client/src/directory_transfer_rpc.dart';

import 'directory_crash_support.dart';
import 'directory_crash_verify.dart';

class CrashRelay extends RpcDirectoryRelay {
  CrashRelay(super.server, this.hooks);
  final CrashHooks hooks;
  @override
  Future<void> write(WriteDirectoryFrameRequest request) async {
    await super.write(request);
    if (hooks.role == 'source' &&
        request.sequence == 4 &&
        hooks.stage == 'source-first-frame') {
      await hooks.wait('target-frame-seen');
      await hooks.hit('source-first-frame');
    }
  }

  @override
  Future<ReadDirectoryFrameResponse> read(
    ReadDirectoryFrameRequest request,
  ) async {
    final result = await super.read(request);
    if (hooks.role == 'target' && request.sequence == 4 && result.available) {
      await hooks.signal('target-frame-seen', {'pid': pid});
    }
    return result;
  }
}

Future<void> crashSource(
  CrashContext context,
  DirectoryTransfer transfer,
) async {
  final hooks = context.hooks;
  await context.service.apply(
    await context.service.preview(crashDocument()),
    replaceSettings: true,
  );
  final document = await context.service.capture(
    selectedOrigins: incomingOrigins,
  );
  await hooks.signal('expected', document.data);
  await hooks.wait('qr');
  final qr = DirectoryTransferQr.parse(await hooks.read('qr') as String);
  await transfer.sendStart(qr);
  await hooks.signal('sas-source', transfer.sas);
  await hooks.wait('sas-target');
  final comparison = await hooks.read('sas-target') as String;
  requireCrash(comparison == transfer.sas, 'SAS разных процессов не совпал');
  await transfer.send(comparison, document);
}

Future<void> crashTarget(
  CrashContext context,
  DirectoryTransfer transfer,
) async {
  final hooks = context.hooks;
  final qr = await transfer.receiveStart();
  await hooks.signal('qr', qr.encode());
  await hooks.signal('expires', qr.expires);
  await hooks.hit('handshake');
  await transfer.receiveHandshake();
  await hooks.signal('sas-target', transfer.sas);
  await hooks.wait('sas-source');
  requireCrash(
    await hooks.read('sas-source') == transfer.sas,
    'Получатель не сверил SAS',
  );
  final plan = await transfer.receive(context.service);
  await verifyCrashUnapplied(context);
  await hooks.signal('preview-ready');
  await hooks.hit('preview');
  await hooks.wait('allow-apply');
  context.storage.armed = true;
  context.preferences.armed = true;
  await context.service.apply(plan, replaceSettings: hooks.replace);
  await verifyCrashApplied(context);
}

Future<void> runCrashTransfer(CrashContext context) async {
  final hooks = context.hooks;
  final server = await discover(Platform.environment['DIRECTORY_CRASH_RELAY']!);
  final transfer = DirectoryTransfer(
    server,
    CrashRelay(server, hooks),
    CrashNoise(hooks),
  );
  try {
    if (hooks.role == 'source') {
      await crashSource(context, transfer);
    } else {
      await crashTarget(context, transfer);
    }
  } catch (_) {
    if (hooks.role != 'target' ||
        Platform.environment['DIRECTORY_CRASH_TIMEOUT'] != '1') {
      rethrow;
    }
    final expires = await hooks.read('expires') as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    requireCrash(
      now >= expires && now <= expires + 15,
      'Не соблюдён реальный срок передачи',
    );
    await transfer.close();
    await context.oldHandleRejected();
    await verifyCrashUnapplied(context);
    await hooks.signal('timeout-safe');
  } finally {
    await transfer.close();
  }
}

Future<void> runCrashRole(CrashContext context) async {
  switch (context.hooks.role) {
    case 'init':
      await initializeCrashTarget(context);
    case 'source' || 'target':
      await runCrashTransfer(context);
    case 'inspect':
      await context.oldHandleRejected();
      await verifyCrashUnapplied(context);
    case 'inspect-source':
      await context.oldHandleRejected('source');
    case 'resume':
      await context.oldHandleRejected();
      await context.service.resume();
      await verifyCrashApplied(context);
    case 'verify':
      await verifyCrashApplied(context);
    default:
      throw StateError('Неизвестная роль стенда');
  }
}

Future<void> main() async {
  if (Platform.environment['GITHUB_ACTIONS'] != 'true') exit(2);
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    stderr.writeln('DIRECTORY_CRASH_ERROR: ${details.exceptionAsString()}');
    exit(1);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    stderr.writeln('DIRECTORY_CRASH_ERROR: $error');
    exit(1);
  };
  runApp(const MaterialApp(home: Scaffold(body: Text('Directory crash CI'))));
  await WidgetsBinding.instance.endOfFrame;
  final context = CrashContext(CrashHooks());
  try {
    await context.open();
    await runCrashRole(context);
    await context.preferences.flush();
    await context.preferences.close();
    await context.hooks.signal('done-${context.hooks.role}', {'pid': pid});
    exit(0);
  } catch (error, stack) {
    stderr.writeln('DIRECTORY_CRASH_ERROR: $error\n$stack');
    exit(1);
  }
}
