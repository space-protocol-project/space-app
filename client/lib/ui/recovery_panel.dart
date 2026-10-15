import 'dart:io';
import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';
import '../src/pairing.dart';
import '../src/root_rotation.dart' as rotation;
import '../src/rpc_clients.dart' show AuthServiceClient;

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
    this.identityOrigin,
  });
  final ChatController controller;
  final String? identityOrigin;
  final ChatController Function(String origin)? restoreController;
  final Future<void> Function(String origin, ChatController controller)?
  onRestored;
  @override
  State<RecoveryPanel> createState() => _RecoveryPanelState();
}

class _RecoveryPanelState extends State<RecoveryPanel> {
  Uint8List? qrBytes;
  String? cardPacket;
  bool localRoot = false;
  String? get identityOrigin =>
      widget.identityOrigin ?? widget.controller.preview?.origin.toString();
  @override
  void initState() {
    super.initState();
    loadLocalRoot();
  }

  @override
  void didUpdateWidget(covariant RecoveryPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.identityOrigin != widget.identityOrigin ||
        oldWidget.controller != widget.controller) {
      qrBytes = null;
      cardPacket = null;
      localRoot = false;
      loadLocalRoot();
    }
  }

  Future<void> loadLocalRoot() async {
    final origin = identityOrigin;
    if (origin == null) return;
    try {
      final record = await widget.controller.vault
          .load(origin)
          .timeout(const Duration(seconds: 10));
      if (mounted) setState(() => localRoot = record?.rootSeed.length == 32);
    } catch (_) {
      if (mounted) setState(() => localRoot = false);
    }
  }

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
      _showRecoveryError(error);
    } finally {
      if (mounted) setState(() => pending = false);
    }
  }

  void _showRecoveryError(Object error) {
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
  }

  Future<bool> confirm(String Function(AppLocalizations) text) =>
      confirmRecoveryAction(
        context,
        '',
        textBuilder: (context) => text(context.strings),
      );
  Future<String?> password(bool creating) =>
      askRecoveryPassword(context, creating: creating);

  Future<void> generateQr() async {
    final origin = identityOrigin;
    if (origin == null) return;
    final record = await widget.controller.vault.load(origin);
    if (record == null || record.rootSeed.isEmpty) {
      throw const LocalFailure(
        LocalFailureCode.identityInvalid,
        'На этом устройстве нет ключа восстановления. Используйте исходную карточку.',
      );
    }
    final pass = await password(true);
    if (pass == null) return;
    stage(5);
    final packet = await compute(sealCardInWorker, [
      await compute(rootCardPayloadInWorker, record),
      pass,
    ]);
    if (mounted) {
      setState(() {
        cardPacket = packet;
        qrBytes = null;
      });
    }
    final bytes = await compute(pngInWorker, packet);
    if (mounted) setState(() => qrBytes = bytes);
  }

  Future<void> export({bool json = false}) async {
    final content = json && cardPacket != null
        ? Uint8List.fromList(utf8.encode(cardPacket!))
        : qrBytes;
    if (content == null) return;
    final extension = json ? 'json' : 'png';
    if (!mounted) return;
    if (Platform.isWindows) {
      await _exportOnWindows(content, extension, json);
      return;
    }
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
      mimeType: json ? 'application/json' : 'image/png',
      name: 'space-recovery.$extension',
    ).saveTo(destination.path);
    if (mounted) {
      setState(() => messageKey = 'recoveryCardSaved');
    }
  }

  Future<void> _exportOnWindows(
    Uint8List content,
    String extension,
    bool json,
  ) async {
    final selected = await pickRecoveryQrDestination(
      context,
      name: 'space-recovery.$extension',
      label: json ? 'JSON' : null,
    );
    if (selected == null || !mounted) return;
    final destination = File(
      selected.toLowerCase().endsWith('.$extension')
          ? selected
          : '$selected.$extension',
    );
    if (await destination.exists() &&
        !await confirm((strings) => strings.recoveryOverwriteQr)) {
      return;
    }
    await destination.writeAsBytes(content, flush: true);
    if (mounted) setState(() => messageKey = 'recoveryCardSaved');
    return;
  }

  Future<String?> _readRestorePacket() async {
    final selectedPath = Platform.isWindows
        ? await pickRecoveryFile(context)
        : null;
    final file = Platform.isWindows
        ? (selectedPath == null ? null : XFile(selectedPath))
        : await openFile(acceptedTypeGroups: files);
    if (file == null) return null;
    stage(1);
    if (await file.length().timeout(const Duration(seconds: 10)) >
        maxRecoveryImageBytes) {
      throw RecoveryOperationError('recoveryTooLarge');
    }
    return await compute(
      artifactInWorker,
      await file.readAsBytes().timeout(const Duration(seconds: 10)),
    ).timeout(const Duration(seconds: 30));
  }

  Future<void> restore({String? cameraPacket}) async {
    final packet = cameraPacket ?? await _readRestorePacket();
    if (packet == null) return;
    final pass = await password(false);
    if (pass == null) return;
    stage(2);
    final record = await compute(restoreRecordInWorker, [
      packet,
      pass,
    ]).timeout(const Duration(seconds: 60));
    stage(3);
    final preview = widget.controller.preview;
    final endpoint = preview != null && preview.serverId == record.serverId
        ? preview.endpoint.toString()
        : record.connectionAddress;
    final server = await discover(
      endpoint,
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
    if (mounted) {
      setState(() {
        qrBytes = null;
        cardPacket = null;
      });
    }
    stage(4);
    await target.disconnect();
    await target.inspect(endpoint, tlsFingerprint: record.tlsFingerprint);
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
    if (mounted) {
      setState(() {
        qrBytes = null;
        cardPacket = null;
      });
    }
    final manager = widget.controller.deviceManagement;
    if (manager is! RootRotationControl) return;
    final rotationManager = manager as RootRotationControl;
    final retained = await rotationManager.previewRotationDevices();
    if (!await confirm(
      (strings) =>
          '${renew ? strings.rotationRenewConfirm : strings.rotationConfirm}'
          '${_rotationDeviceSummary(retained, strings)}',
    )) {
      return;
    }
    await rotationManager.prepareRotation(
      renew: renew,
      retainedDevices: retained,
    );
    await finishRotation();
  }

  String _rotationDeviceSummary(
    List<DeviceGrant> retained,
    AppLocalizations strings,
  ) {
    if (retained.isEmpty) return '';
    return '\n\n${strings.rotationDevicesReview}\n\n${retained.map((d) => [d.id, url64(d.publicKey), d.scopes.join(', '), DateTime.fromMillisecondsSinceEpoch(d.expiresAt.toInt() * 1000).toLocal().toString()].join('\n')).join('\n\n')}';
  }

  Future<void> finishRotation() async {
    if (mounted) {
      setState(() {
        qrBytes = null;
        cardPacket = null;
      });
    }
    final server = widget.controller.preview, vault = widget.controller.vault;
    if (server == null || vault is! RotationJournalVault) {
      throw RecoveryOperationError('rotationServerRequired');
    }
    final channel = server.openConnection();
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

  Future<DeviceRecord?> _readRevocationAuthority() async {
    final file = await openFile(acceptedTypeGroups: files);
    if (file == null) return null;
    if (await file.length() > maxRecoveryImageBytes) {
      throw RecoveryOperationError('recoveryTooLarge');
    }
    final pass = await password(false);
    if (pass == null) return null;
    return await recordFromRecovery(
      await compute(openCardInWorker, [
        await compute(artifactInWorker, await file.readAsBytes()),
        pass,
      ]),
    );
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
      authority = await _readRevocationAuthority();
      if (authority == null) return;
    }
    await manager.revokeDevice(grant, authority: authority);
    if (grant.id == manager.currentGrantId) {
      await widget.controller.clearOfflineData();
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
    onExportJson: cardPacket == null
        ? null
        : () => run(() => export(json: true)),
    canCreateQr:
        localRoot ||
        widget.controller.deviceManagement?.hasRootAuthority == true,
    onCreateQr: () => run(generateQr),
    qrPreview: qrBytes == null
        ? null
        : Center(
            child: Image.memory(
              qrBytes!,
              width: 240,
              height: 240,
              filterQuality: FilterQuality.none,
            ),
          ),
    progress: switch (restoreStage) {
      1 => context.strings.recoveryReadingFile,
      2 => context.strings.recoveryDecryptingCard,
      3 => context.strings.recoveryCheckingServer,
      4 => context.strings.recoveryConnectingDevice,
      5 => context.strings.recoveryGeneratingQr,
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

Future<Map<String, dynamic>> rootCardPayloadInWorker(
  DeviceRecord record,
) async {
  await record.identity();
  final pair = await Ed25519().newKeyPairFromSeed(record.rootSeed);
  return {
    'v': record.rootHistory.isEmpty ? 1 : 2,
    'origin': record.origin,
    'endpoint': record.connectionAddress,
    'server_id': record.serverId,
    'server_key': record.serverKey,
    if (record.tlsFingerprint.isNotEmpty)
      'tls_fingerprint': record.tlsFingerprint,
    'root_public_key': url64((await pair.extractPublicKey()).bytes),
    'credential': 'root',
    'secret': url64(record.rootSeed),
    if (record.rootHistory.isNotEmpty) 'root_history': record.rootHistory,
  };
}

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
