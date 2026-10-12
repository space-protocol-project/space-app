import 'dart:convert';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';
import '../src/pairing.dart';
import '../src/root_rotation.dart' as rotation;
import '../src/generated/space/v1/space.pbgrpc.dart' show AuthServiceClient;

import 'package:space_admin_ui/space_admin_ui.dart';

import 'camera_scanner.dart';
import 'recovery_file_picker.dart';
import '../l10n/strings.dart';
import '../l10n/failure_strings.dart';
import '../src/local_failure.dart';
import '../l10n/app_localizations.dart';

class RecoveryPanel extends StatefulWidget {
  const RecoveryPanel({
    super.key,
    required this.controller,
    this.restoreController,
    this.onRestored,
  });
  final ChatController controller;
  final ChatController Function(String origin)? restoreController;
  final Future<void> Function(String origin, ChatController controller)?
  onRestored;
  @override
  State<RecoveryPanel> createState() => _RecoveryPanelState();
}

class _RecoveryPanelState extends State<RecoveryPanel> {
  bool pending = false;
  int restoreStage = 0;
  void stage(int value) {
    if (mounted) setState(() => restoreStage = value);
  }

  String message = '';
  String? messageKey;
  LocalFailureCode? failureCode;
  String get localizedMessage => failureCode == null
      ? recoveryMessage(context.strings, messageKey) ?? message
      : localFailureText(context, failureCode!);
  List<DeviceGrant> devices = [];
  final pairingCode = TextEditingController();
  final pairingEntered = TextEditingController();
  Pairing? preparedPair;
  DeviceRecord? preparedAuthority;
  String pairingCheck = '';
  @override
  void dispose() {
    pairingCode.dispose();
    pairingEntered.dispose();
    super.dispose();
  }

  List<XTypeGroup> get files => [
    XTypeGroup(
      label: context.strings.recoveryFileLabel,
      extensions: ['json', 'png'],
    ),
  ];
  Future<void> run(Future<void> Function() action) async {
    if (pending || widget.controller.busy) return;
    setState(() {
      pending = true;
      restoreStage = 0;
      message = '';
      messageKey = null;
      failureCode = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) {
        setState(() {
          failureCode = error is RecoveryOperationError
              ? null
              : classifyFailure(error);
          messageKey = error is RecoveryOperationError
              ? error.key
              : error is FormatException
              ? null
              : 'recoveryOperationFailed';
          message = error is FormatException ? error.message.toString() : '';
        });
      }
    } finally {
      if (mounted) setState(() => pending = false);
    }
  }

  Future<bool> confirm(String Function(AppLocalizations) text) =>
      confirmRecoveryAction(
        context,
        '',
        textBuilder: (context) => text(context.strings),
      );
  Future<String?> password(bool creating) =>
      askRecoveryPassword(context, creating: creating);

  Future<void> export() async {
    final manager = widget.controller.deviceManagement;
    if (manager == null) return;
    final pass = await password(true);
    if (pass == null) return;
    final packet = await compute(sealCardInWorker, [
      await manager.recoveryPayload(),
      pass,
    ]);
    if (!mounted) return;
    final png = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.strings.recoveryFormat),
        content: Text(context.strings.recoveryFormatHelp),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('JSON'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.strings.recoveryPng),
          ),
        ],
      ),
    );
    if (png == null) return;
    final extension = png ? 'png' : 'json';
    final content = png
        ? await compute(pngInWorker, packet)
        : Uint8List.fromList(utf8.encode(packet));
    if (!mounted) return;
    final destination = await getSaveLocation(
      suggestedName: 'space-recovery.$extension',
      acceptedTypeGroups: [
        XTypeGroup(
          label: context.strings.recoveryFileLabel,
          extensions: [extension],
        ),
      ],
    );
    if (destination == null) return;
    await XFile.fromData(
      content,
      mimeType: png ? 'image/png' : 'application/json',
      name: 'space-recovery.$extension',
    ).saveTo(destination.path);
    if (mounted) {
      setState(() => messageKey = 'recoveryCardSaved');
    }
  }

  Future<void> restore({String? cameraPacket}) async {
    String packet;
    if (cameraPacket != null) {
      packet = cameraPacket;
    } else {
      final selectedPath = Platform.isWindows
          ? await pickRecoveryFile(context)
          : null;
      final file = Platform.isWindows
          ? (selectedPath == null ? null : XFile(selectedPath))
          : await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      stage(1);
      if (await file.length().timeout(const Duration(seconds: 10)) >
          maxRecoveryImageBytes) {
        throw RecoveryOperationError('recoveryTooLarge');
      }
      packet = await compute(
        artifactInWorker,
        await file.readAsBytes().timeout(const Duration(seconds: 10)),
      ).timeout(const Duration(seconds: 30));
    }
    final pass = await password(false);
    if (pass == null) return;
    stage(2);
    final record = await compute(restoreRecordInWorker, [
      packet,
      pass,
    ]).timeout(const Duration(seconds: 60));
    stage(3);
    final server = await discover(
      record.origin,
      tlsFingerprint: record.tlsFingerprint,
    );
    checkTrust(server, record);
    final existing = await widget.controller.vault.load(record.origin);
    if (existing != null) checkTrust(server, existing);
    if (!mounted ||
        !await confirm(
          (strings) => strings.recoveryRestoreConfirm(
            record.origin,
            existing == null ? '' : strings.recoveryReplaceWarning,
          ),
        )) {
      return;
    }
    final target =
        widget.restoreController?.call(record.origin) ?? widget.controller;
    stage(4);
    await target.disconnect();
    await target.inspect(record.origin, tlsFingerprint: record.tlsFingerprint);
    await target.connect(restoredRecord: record);
    if (!target.connected) {
      throw RecoveryOperationError('recoveryConnectionDenied');
    }
    await widget.onRestored?.call(record.origin, target);
    await refresh();
    if (mounted) {
      setState(() => messageKey = 'recoveryRestored');
    }
  }

  Future<void> refresh() async {
    final result = await widget.controller.deviceManagement?.listDevices();
    if (mounted) setState(() => devices = result ?? []);
  }

  Future<void> rotate({bool renew = false}) async {
    final manager = widget.controller.deviceManagement;
    if (manager is! RootRotationControl) return;
    if (!await confirm(
      (strings) =>
          renew ? strings.rotationRenewConfirm : strings.rotationConfirm,
    )) {
      return;
    }
    await (manager as RootRotationControl).prepareRotation(renew: renew);
    await finishRotation();
  }

  Future<void> finishRotation() async {
    final server = widget.controller.preview, vault = widget.controller.vault;
    if (server == null || vault is! RotationJournalVault) {
      throw RecoveryOperationError('rotationServerRequired');
    }
    final channel = server.openChannel();
    try {
      final record = await rotation.finishRootRotation(
        server,
        vault,
        AuthServiceClient(channel),
      );
      if (record == null) {
        if (mounted) {
          setState(() => messageKey = 'rotationNotPending');
        }
        return;
      }
      await widget.controller.disconnect();
      await widget.controller.inspect(record.origin);
      await widget.controller.connect();
      if (!widget.controller.connected) {
        throw RecoveryOperationError('rotationReconnect');
      }
      await refresh();
      if (mounted) {
        setState(() => messageKey = 'rotationCompleted');
      }
    } finally {
      await channel.shutdown();
    }
  }

  Future<void> revoke(DeviceGrant grant) async {
    final manager = widget.controller.deviceManagement;
    if (manager == null) return;
    if (!await confirm(
      (strings) => grant.recovery
          ? strings.recoveryRevokeCard
          : strings.recoveryRevokeDevice,
    )) {
      return;
    }
    DeviceRecord? authority;
    if (!manager.hasRootAuthority && grant.id != manager.currentGrantId) {
      final file = await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      if (await file.length() > maxRecoveryImageBytes) {
        throw RecoveryOperationError('recoveryTooLarge');
      }
      final pass = await password(false);
      if (pass == null) return;
      authority = await recordFromRecovery(
        await compute(openCardInWorker, [
          await compute(artifactInWorker, await file.readAsBytes()),
          pass,
        ]),
      );
    }
    await manager.revokeDevice(grant, authority: authority);
    if (grant.id == manager.currentGrantId) {
      await widget.controller.disconnect();
      if (mounted) setState(() => devices = []);
    } else {
      await refresh();
    }
    if (mounted) setState(() => messageKey = 'recoveryRevoked');
  }

  Future<void> approve() async {
    final server = widget.controller.preview,
        manager = widget.controller.deviceManagement;
    if (server == null || manager == null) return;
    final pair = await inspectPairing(server, pairingCode.text);
    if (pair.state != 'pending') {
      throw RecoveryOperationError('pairingAlreadyUsed');
    }
    if (!await confirm(
      (strings) => strings.pairingPrepareConfirm(
        pair.deviceName,
        pair.administrative
            ? strings.pairingManageRequest
            : strings.pairingChatRequest,
      ),
    )) {
      return;
    }
    DeviceRecord? authority;
    if (!manager.hasRootAuthority) {
      final file = await openFile(acceptedTypeGroups: files);
      if (file == null) return;
      if (await file.length() > maxRecoveryImageBytes) {
        throw RecoveryOperationError('recoveryTooLarge');
      }
      final pass = await password(false);
      if (pass == null) return;
      authority = await recordFromRecovery(
        await compute(openCardInWorker, [
          await compute(artifactInWorker, await file.readAsBytes()),
          pass,
        ]),
      );
    }
    final code = await manager.preparePairing(pair, authority: authority);
    if (mounted) {
      setState(() {
        pairingCheck = code;
        preparedPair = pair;
        preparedAuthority = authority;
        pairingEntered.clear();
        messageKey = 'pairingReady';
      });
    }
  }

  Future<void> finishPairing() async {
    final manager = widget.controller.deviceManagement, pair = preparedPair;
    if (manager == null || pair == null) return;
    if (pairingEntered.text.replaceAll(RegExp(r'[\s-]'), '').toUpperCase() !=
        pairingCheck.replaceAll('-', '')) {
      throw RecoveryOperationError('pairingMismatch');
    }
    if (!await confirm((strings) => strings.pairingSignConfirm)) {
      return;
    }
    await manager.approvePairing(pair, authority: preparedAuthority);
    if (mounted) {
      setState(() {
        preparedPair = null;
        preparedAuthority = null;
        pairingEntered.clear();
        pairingCode.clear();
        messageKey = 'pairingSigned';
      });
    }
  }

  @override
  Widget build(BuildContext context) => RecoveryToolsView(
    progress: switch (restoreStage) {
      1 => context.strings.recoveryReadingFile,
      2 => context.strings.recoveryDecryptingCard,
      3 => context.strings.recoveryCheckingServer,
      4 => context.strings.recoveryConnectingDevice,
      _ => '',
    },
    connected: widget.controller.connected,
    hasServer: widget.controller.preview != null,
    hasDeviceManagement: widget.controller.deviceManagement != null,
    hasRootAuthority:
        widget.controller.deviceManagement?.hasRootAuthority == true,
    canRotate: widget.controller.deviceManagement is RootRotationControl,
    pending: pending,
    message: localizedMessage,
    pairingCode: pairingCode,
    pairingEntered: pairingEntered,
    pairingCheck: pairingCheck,
    pairingPrepared: preparedPair != null,
    currentGrantId: widget.controller.deviceManagement?.currentGrantId ?? '',
    devices: [
      for (final g in devices)
        RecoveryDeviceView(
          id: g.id,
          expiresAt: g.expiresAt.toInt(),
          revoked: g.revoked,
          recovery: g.recovery,
        ),
    ],
    onRotate: () => run(rotate),
    onRenewRotation: () => run(() => rotate(renew: true)),
    onFinishRotation: () => run(finishRotation),
    onPreparePairing: () => run(approve),
    onApprovePairing: () => run(finishPairing),
    onPairingCodeChanged: (_) => setState(() {
      preparedPair = null;
      preparedAuthority = null;
      pairingCheck = '';
    }),
    onExport: () => run(export),
    onRestore: () => run(restore),
    onScan: () => run(() async {
      final packet = await scanRecoveryCamera(context);
      if (packet != null && mounted) await restore(cameraPacket: packet);
    }),
    onRefreshDevices: () => run(refresh),
    onRevoke: (id) => run(() => revoke(devices.firstWhere((g) => g.id == id))),
  );
}

Future<DeviceRecord> restoreRecordInWorker(List<String> input) async =>
    recordFromRecovery(await openCardInWorker(input));

class RecoveryOperationError implements Exception {
  const RecoveryOperationError(this.key);
  final String key;
}

String? recoveryMessage(AppLocalizations strings, String? key) => switch (key) {
  'recoveryCardSaved' => strings.recoveryCardSaved,
  'recoveryRestored' => strings.recoveryRestored,
  'rotationNotPending' => strings.rotationNotPending,
  'rotationCompleted' => strings.rotationCompleted,
  'recoveryRevoked' => strings.recoveryRevoked,
  'pairingReady' => strings.pairingReady,
  'pairingSigned' => strings.pairingSigned,
  'recoveryTooLarge' => strings.recoveryTooLarge,
  'recoveryConnectionDenied' => strings.recoveryConnectionDenied,
  'rotationServerRequired' => strings.rotationServerRequired,
  'rotationReconnect' => strings.rotationReconnect,
  'pairingAlreadyUsed' => strings.pairingAlreadyUsed,
  'pairingMismatch' => strings.pairingMismatch,
  'recoveryOperationFailed' => strings.recoveryOperationFailed,
  _ => null,
};
