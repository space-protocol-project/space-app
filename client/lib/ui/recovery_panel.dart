import 'dart:io';
import 'dart:convert';

import '../src/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../src/chat_controller.dart';
import '../src/core.dart';
import '../src/generated/space/v1/space.pb.dart';
import '../src/recovery_card.dart';
import '../src/recovery_qr.dart';
import '../src/recovery_spaces.dart';
import 'pairing_approval_panel.dart';
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
    this.spaceOrigins,
    this.onPendingChanged,
  });
  final ChatController controller;
  final String? identityOrigin;
  final List<String>? spaceOrigins;
  final ValueChanged<bool>? onPendingChanged;
  final ChatController Function(String origin)? restoreController;
  final Future<void> Function(String origin, ChatController controller)?
  onRestored;
  @override
  State<RecoveryPanel> createState() => _RecoveryPanelState();
}

class _RecoveryPanelState extends State<RecoveryPanel> {
  Uint8List? qrBytes;
  String? cardPacket;
  String? spacesPacket;
  Uint8List? spacesQrBytes;
  bool includeSpaces = true;
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
      spacesPacket = null;
      spacesQrBytes = null;
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
      widget.onPendingChanged?.call(true);
      await action();
    } catch (error) {
      _showRecoveryError(error);
    } finally {
      if (mounted) {
        setState(() => pending = false);
        widget.onPendingChanged?.call(false);
      }
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
    setState(() {
      qrBytes = null;
      cardPacket = null;
      spacesPacket = null;
      spacesQrBytes = null;
    });
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
    if (includeSpaces && widget.spaceOrigins != null) {
      await _generateSpaces(pass);
    }
  }

  Future<void> _generateSpaces(String password) async {
    final records = <DeviceRecord>[];
    for (final origin in widget.spaceOrigins!) {
      final record = await widget.controller.vault.load(origin);
      if (record == null) {
        throw FormatException('Нет сохранённого доступа для $origin');
      }
      records.add(record);
    }
    final payload = await compute(recoverySpacesPayload, records);
    final packet = await compute(sealCardInWorker, [payload, password]);
    if (!mounted) return;
    setState(() => spacesPacket = packet);
    try {
      final bytes = await compute(pngInWorker, packet);
      if (mounted) setState(() => spacesQrBytes = bytes);
    } on LocalFailure catch (error) {
      if (error.code != LocalFailureCode.qrTooLarge) rethrow;
    }
  }

  Future<void> export({bool json = false, bool spaces = false}) async {
    final packet = spaces ? spacesPacket : cardPacket;
    final content = json && packet != null
        ? Uint8List.fromList(utf8.encode(packet))
        : spaces
        ? spacesQrBytes
        : qrBytes;
    if (content == null) return;
    final extension = json ? 'json' : 'png';
    if (!mounted) return;
    if (Platform.isWindows) {
      await _exportOnWindows(content, extension, json, spaces);
      return;
    }
    final destination = await getSaveLocation(
      suggestedName: '${spaces ? 'space-spaces' : 'space-recovery'}.$extension',
      acceptedTypeGroups: [
        XTypeGroup(
          label: context.strings.recoveryFileLabel,
          extensions: [extension],
        ),
      ],
    );
    if (destination == null) return;
    await SpaceFile.fromData(
      content,
      mimeType: json ? 'application/json' : 'image/png',
      name: '${spaces ? 'space-spaces' : 'space-recovery'}.$extension',
    ).saveTo(destination.path);
    if (mounted) {
      setState(() => messageKey = 'recoveryCardSaved');
    }
  }

  Future<void> _exportOnWindows(
    Uint8List content,
    String extension,
    bool json,
    bool spaces,
  ) async {
    final selected = await pickRecoveryQrDestination(
      context,
      name: '${spaces ? 'space-spaces' : 'space-recovery'}.$extension',
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
        ? (selectedPath == null ? null : SpaceFile(selectedPath))
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
    final restored = await compute(restoreAccessInWorker, [
      packet,
      pass,
    ]).timeout(const Duration(seconds: 60));
    final records = restored.records;
    if (!restored.isSpaceCollection) {
      if (await _restoreRecord(records.single)) {
        await refresh();
        if (mounted) setState(() => messageKey = 'recoveryRestored');
      }
      return;
    }
    await _restoreSpaces(records);
  }

  Future<void> _restoreSpaces(List<DeviceRecord> records) async {
    if (widget.restoreController == null || widget.onRestored == null) {
      throw const FormatException(
        'Восстановите набор пространств на экране «Устройство»',
      );
    }
    var restored = 0;
    final failed = <String>[];
    final missing = await missingRecoverySpaces(
      records,
      widget.controller.vault,
    );
    for (final record in missing) {
      if (!mounted) return;
      try {
        if (!await _restoreRecord(record)) break;
        restored++;
      } catch (_) {
        failed.add(record.origin);
      }
    }
    if (!mounted) return;
    setState(() {
      messageKey = null;
      message = context.strings.recoverySpacesResult(restored, records.length);
      if (failed.isNotEmpty) message += '\n${failed.join('\n')}';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.strings.recoverySpacesResult(restored, records.length),
        ),
      ),
    );
    await refresh();
  }

  Future<bool> _restoreRecord(DeviceRecord record) async {
    stage(3);
    final preview = widget.controller.preview;
    final endpoint = preview != null && preview.serverId == record.serverId
        ? preview.endpoint.toString()
        : record.connectionAddress;
    final server = await discoverConnection(
      parseConnectionInput(endpoint),
      record: record,
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
      return false;
    }
    final target =
        widget.restoreController?.call(record.origin) ?? widget.controller;
    if (mounted) {
      setState(() {
        qrBytes = null;
        cardPacket = null;
        spacesPacket = null;
        spacesQrBytes = null;
      });
    }
    stage(4);
    await target.disconnect();
    await target.inspect(
      server.endpoint.toString(),
      tlsFingerprint: record.tlsFingerprint,
      savedRecord: record,
    );
    await target.connect(restoredRecord: record);
    if (!target.connected) {
      throw RecoveryOperationError('recoveryConnectionDenied');
    }
    await widget.onRestored?.call(record.origin, target);
    return true;
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
        spacesPacket = null;
        spacesQrBytes = null;
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
        spacesPacket = null;
        spacesQrBytes = null;
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

  Future<DeviceRecord?> _readPairingAuthority() async {
    final file = await openFile(acceptedTypeGroups: files);
    if (file == null) return null;
    if (await file.length() > maxRecoveryImageBytes) {
      throw RecoveryOperationError('recoveryTooLarge');
    }
    final pass = await password(false);
    if (pass == null) return null;
    return recordFromRecovery(
      await compute(openCardInWorker, [
        await compute(artifactInWorker, await file.readAsBytes()),
        pass,
      ]),
    );
  }

  @override
  Widget build(BuildContext context) => RecoveryToolsView(
    recoveryOptions: widget.spaceOrigins == null
        ? null
        : CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(context.strings.recoveryIncludeSpaces),
            subtitle: Text(context.strings.recoveryIncludeSpacesHint),
            value: includeSpaces,
            onChanged: pending
                ? null
                : (value) => setState(() {
                    includeSpaces = value ?? true;
                    qrBytes = null;
                    cardPacket = null;
                    spacesPacket = null;
                    spacesQrBytes = null;
                  }),
          ),
    onExportJson: cardPacket == null
        ? null
        : () => run(() => export(json: true)),
    canCreateQr:
        localRoot ||
        widget.controller.deviceManagement?.hasRootAuthority == true,
    onCreateQr: () => run(generateQr),
    qrPreview: qrBytes == null ? null : _qrPreviews(),
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
    pairingTools: PairingApprovalPanel(controller: widget.controller, readAuthority: _readPairingAuthority, blocked: pending),
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
    onExport: () => run(export),
    onRestore: () => run(restore),
    onScan: () => run(() async {
      final packet = await scanRecoveryCamera(context);
      if (packet != null && mounted) await restore(cameraPacket: packet);
    }),
    onRefreshDevices: () => run(refresh),
    onRevoke: (id) => run(() => revoke(devices.firstWhere((g) => g.id == id))),
  );

  Widget _qrPreviews() => Column(
    children: [
      Text(context.strings.recoveryAccessQr),
      Image.memory(
        qrBytes!,
        width: 240,
        height: 240,
        filterQuality: FilterQuality.none,
      ),
      if (spacesPacket != null) ...[
        const SizedBox(height: 24),
        Text(context.strings.recoverySpacesQr),
        if (spacesQrBytes != null)
          Image.memory(
            spacesQrBytes!,
            width: 240,
            height: 240,
            filterQuality: FilterQuality.none,
          )
        else
          Text(context.strings.recoverySpacesUseFile),
        Wrap(
          spacing: 12,
          children: [
            if (spacesQrBytes != null)
              OutlinedButton(
                onPressed: pending
                    ? null
                    : () => run(() => export(spaces: true)),
                child: Text(context.strings.recoverySaveSpacesQr),
              ),
            TextButton(
              onPressed: pending
                  ? null
                  : () => run(() => export(spaces: true, json: true)),
              child: Text(context.strings.recoverySaveSpacesFile),
            ),
          ],
        ),
      ],
    ],
  );
}

Future<DeviceRecord> restoreRecordInWorker(List<String> input) async =>
    recordFromRecovery(await openCardInWorker(input));

Future<Map<String, dynamic>> rootCardPayloadInWorker(DeviceRecord record) =>
    recoveryAccessPayload(record);

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
