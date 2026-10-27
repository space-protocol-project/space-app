import 'dart:io';

import 'package:space_client/src/core.dart';
import 'package:space_client/src/pairing.dart';

import 'community_space_search_interoperability.dart'
    show SearchVault, require, restart;

Future<SpaceSession> pair(
  SpaceSession source,
  SearchVault vault,
  bool full,
) async {
  final pending = await PendingPairing.start(
    source.server,
    fullManagement: full,
  );
  try {
    final request = await inspectPairing(source.server, pending.request.code);
    final expected = await source.preparePairing(request);
    final proposal = await pending.poll();
    require(
      expected ==
          await pairVerificationCode(
            source.server.serverId,
            request.id,
            proposal.rootPublicKey,
            request.publicKey,
            administrative: request.administrative,
            fullManagement: full,
          ),
      'Код проверки не совпал',
    );
    await source.approvePairing(request);
    final record = await pending.verifiedRecord(await pending.poll());
    require(
      record.fullManagement == full &&
          record.rootSeed.isEmpty &&
          record.recoverySeed.isEmpty,
      'Неверные полномочия или передача исходного секрета',
    );
    final session = await SpaceSession.connect(
      source.server,
      vault,
      restoredRecord: record,
      pairingId: request.id,
    );
    pending.claimed = true;
    require(session.principalId == source.principalId, 'Изменилась личность');
    return session;
  } finally {
    await pending.close();
  }
}

Future<void> denied(Future<Object?> Function() action) async {
  try {
    await action();
  } catch (_) {
    return;
  }
  throw StateError('Недостаточные полномочия приняты');
}

Future<void> main(List<String> args) async {
  final rootVault = SearchVault(),
      fullVault = SearchVault(),
      limitedVault = SearchVault();
  var root = await SpaceSession.connect(await discover(args.first), rootVault);
  SpaceSession? full, limited;
  try {
    full = await pair(root, fullVault, true);
    limited = await pair(full, limitedVault, false);
    require(
      full.hasDeviceAuthority &&
          !full.hasRootAuthority &&
          !limited.hasDeviceAuthority,
      'Полномочия режимов смешаны',
    );
    final grants = await full.listDevices();
    final child = grants.firstWhere((g) => g.id == limited!.currentGrantId);
    require(
      child.parentGrantId == full.currentGrantId &&
          !child.scopes.contains('device.manage'),
      'Нет ограничения цепочки',
    );
    await denied(limited.recoveryPayload);
    await denied(full.recoveryPayload);
    await limited.messages();
    await full.close();
    await limited.close();
    await root.close();
    await restart(args);
    root = await SpaceSession.connect(await discover(args.first), rootVault);
    full = await SpaceSession.connect(await discover(args.first), fullVault);
    limited = await SpaceSession.connect(
      await discover(args.first),
      limitedVault,
    );
    require(
      full.record.fullManagement && !limited.record.fullManagement,
      'Режим потерян после перезапуска',
    );
    // Настоящий повторный pairing проверяет подпись родителя после перезапуска.
    final another = await pair(full, SearchVault(), false);
    try {
      await another.messages();
      final own = (await full.listDevices()).firstWhere(
        (g) => g.id == full!.currentGrantId,
      );
      await full.revokeDevice(own);
      await denied(limited.messages);
      await denied(another.messages);
      await root.messages();
    } finally {
      await another.close();
    }
    stdout.writeln(
      'PAIRING_MODES_INTEROP_OK: root -> full -> limited, точные scopes, собственные ключи, перезапуск и каскадный отзыв',
    );
  } finally {
    await limited?.close();
    await full?.close();
    await root.close();
  }
}
