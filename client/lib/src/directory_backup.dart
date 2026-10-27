import 'dart:convert';

import 'package:cryptography/cryptography.dart';

import 'chat_controller.dart';
import 'core.dart';
import 'directory_archive.dart';
import 'directory_document.dart';
import 'directory_follows.dart';
import 'directory_repository.dart';
import 'preferences.dart';
import 'settings_snapshot.dart';

class DirectoryRestorePlan {
  DirectoryRestorePlan(
    this.document,
    this.digest,
    this.before,
    this.conflicts,
    this.unknown,
    this.ancestors,
    this.settingsMerge,
  );
  final DirectoryDocument document;
  final String digest, before;
  final List<String> conflicts;
  final bool unknown;
  final List<DirectoryDocument> ancestors;
  final SettingsMerge settingsMerge;
  bool settingsResolved(bool enabled, Map<String, SettingsChoice> choices) =>
      !enabled || settingsMerge.resolved(choices);
}

class DirectoryBackupService {
  DirectoryBackupService(
    this.repository,
    this.vault,
    this.preferences,
    this.controllers,
  );
  final DirectoryRepository repository;
  final IdentityVault vault;
  final AppPreferences preferences;
  final Map<String, ChatController> Function() controllers;

  Map<String, dynamic> settings() => preferences.settingsValues;
  Future<String> _fingerprint(Map<String, dynamic> state) async => url64(
    (await Sha256().hash(
      utf8.encode(
        jsonEncode([
          state,
          preferences.settingsSnapshot.data,
          preferences.origins,
        ]),
      ),
    )).bytes,
  );

  Future<Map<String, dynamic>> _space(
    String origin,
    Map<String, dynamic> catalog,
  ) async {
    final record = await vault.load(origin), cached = catalog[origin];
    Map<String, dynamic> data;
    if (record == null) {
      if (cached == null) {
        throw StateError('Нет закрепления пространства: $origin');
      }
      data = Map<String, dynamic>.from(cached as Map);
    } else {
      data = {
        'origin': record.origin,
        'endpoint': record.connectionAddress,
        'server_id': record.serverId,
        'server_key': record.serverKey,
        'tls_fingerprint': record.tlsFingerprint,
        'endpoint_revision': record.endpointRevision,
        'endpoint_digest': record.endpointDigest,
        'principal_id': (await record.identity()).principalId,
        'following': <String>[],
        'following_revision': 0,
        'following_status': 'unavailable',
      };
      if (cached != null) {
        directoryRequire(
          directoryPinConflict(cached as Map<String, dynamic>, data) == null,
        );
        data['following'] = cached['following'];
        data['following_revision'] = cached['following_revision'];
      }
    }
    data['following_status'] = 'unavailable';
    await _captureFollowing(origin, data);
    return checkedDirectorySpace(data);
  }

  Future<void> _captureFollowing(
    String origin,
    Map<String, dynamic> data,
  ) async {
    final controller = controllers()[origin],
        session = controllers()[origin]?.mlsSession;
    if (controller == null || !controller.connected || session == null) return;
    final api = SessionFeedApi(session).follows;
    if (api == null) return;
    bool active() =>
        !controller.isClosed &&
        identical(controllers()[origin], controller) &&
        controller.connected &&
        controller.mlsSession == session &&
        controller.principalId == data['principal_id'];
    try {
      final snapshot = await directoryFollowing(api, active);
      data['following'] = snapshot.ids;
      data['following_revision'] = snapshot.revision;
      data['following_status'] = 'complete';
    } catch (_) {
      /* Неполнота явно остаётся в манифесте. */
    }
  }

  Future<DirectoryDocument> capture({List<String>? selectedOrigins}) async {
    final selectedSettings = await preferences.exportSettings();
    final state = await repository.read(),
        catalog = state['catalog'] as Map<String, dynamic>;
    directoryRequire(state['pending'] == null);
    final id = selectedOrigins != null || (state['outgoing'] as String).isEmpty
        ? url64(DirectoryArchive.random(16))
        : state['outgoing'] as String;
    final head = selectedOrigins == null
        ? (state['heads'] as Map)[id] as Map?
        : null;
    final spaces = <Map<String, dynamic>>[];
    final origins = selectedOrigins ?? preferences.origins.toSet().toList();
    if (selectedOrigins != null) {
      directoryRequire(
        origins.isNotEmpty &&
            origins.length <= 12 &&
            origins.toSet().length == origins.length,
      );
      directoryRequire(origins.every(preferences.origins.contains));
    }
    directoryRequire(origins.length <= 100);
    for (final origin in origins) {
      spaces.add(await _space(origin, catalog));
    }
    return DirectoryDocument.parse({
      'v': 2,
      'kind': 'space.directory',
      'id': id,
      'revision': head == null ? 1 : (head['revision'] as int) + 1,
      'parent': head == null ? '' : head['digest'],
      'created': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'settings': selectedSettings.values,
      'settings_versions': selectedSettings.versions,
      'spaces': spaces,
    });
  }

  Future<void> recordExport(
    DirectoryDocument document, {
    bool selectOutgoing = true,
  }) async {
    final state = await repository.read(), heads = state['heads'] as Map;
    final head = heads[document.id] as Map?;
    final digest = await document.digest();
    if (head?['revision'] == document.revision && head?['digest'] == digest) {
      return;
    }
    directoryRequire((head?['digest'] ?? '') == document.parent);
    heads[document.id] = {'revision': document.revision, 'digest': digest};
    final catalog = state['catalog'] as Map;
    for (final space in document.spaces) {
      catalog[space['origin']] = space;
    }
    if (selectOutgoing) state['outgoing'] = document.id;
    await repository.write(state);
  }

  Future<DirectoryRestorePlan> preview(
    DirectoryDocument document, {
    List<DirectoryDocument> ancestors = const [],
  }) async {
    final state = await repository.read(),
        digest = await document.digest(),
        conflicts = <String>[];
    if (state['pending'] != null) {
      conflicts.add('Сначала завершите прерванное восстановление');
    }
    final head = (state['heads'] as Map)[document.id] as Map?;
    if (head != null &&
        !await _validAncestry(document, digest, head, ancestors)) {
      conflicts.add('Откат или ветвление копии');
    }
    final catalog = state['catalog'] as Map<String, dynamic>;
    for (final incoming in document.spaces) {
      final origin = incoming['origin'] as String, local = catalog[origin];
      if (local != null) {
        _conflict(conflicts, local as Map<String, dynamic>, incoming);
      }
      final record = await vault.load(origin);
      if (record != null) {
        _conflict(conflicts, await _spacePin(record), incoming);
      }
    }
    return DirectoryRestorePlan(
      document,
      digest,
      await _fingerprint(state),
      List.unmodifiable(conflicts),
      head == null,
      List.unmodifiable(ancestors),
      SettingsMerge(
        preferences.settingsSnapshot,
        document.settingsSnapshot,
        unknown: !document.hasSettingsVersions,
      ),
    );
  }

  bool _validHead(DirectoryDocument document, String digest, Map head) {
    final revision = head['revision'] as int;
    if (document.revision == revision) return digest == head['digest'];
    return document.revision > revision && document.parent == head['digest'];
  }

  Future<bool> _validAncestry(
    DirectoryDocument document,
    String digest,
    Map head,
    List<DirectoryDocument> ancestors,
  ) async {
    var child = document;
    for (final parent in ancestors) {
      if (parent.id != document.id ||
          parent.revision != child.revision - 1 ||
          await parent.digest() != child.parent) {
        return false;
      }
      child = parent;
    }
    return _validHead(
      child,
      ancestors.isEmpty ? digest : await child.digest(),
      head,
    );
  }

  void _conflict(
    List<String> conflicts,
    Map<String, dynamic> local,
    Map<String, dynamic> incoming,
  ) {
    final issue = directoryPinConflict(local, incoming);
    if (issue != null) conflicts.add(issue);
  }

  Future<Map<String, dynamic>> _spacePin(DeviceRecord record) async => {
    'origin': record.origin,
    'server_id': record.serverId,
    'server_key': record.serverKey,
    'tls_fingerprint': record.tlsFingerprint,
    'endpoint_revision': record.endpointRevision,
    'endpoint_digest': record.endpointDigest,
    'principal_id': (await record.identity()).principalId,
  };

  Future<void> apply(
    DirectoryRestorePlan plan, {
    required bool mergeSettings,
    Map<String, SettingsChoice> settingsChoices = const {},
  }) => repository.exclusive(() async {
    final latest = await preview(plan.document, ancestors: plan.ancestors);
    directoryRequire(latest.conflicts.isEmpty && latest.before == plan.before);
    final state = await repository.read(), catalog = state['catalog'] as Map;
    for (final space in plan.document.spaces) {
      catalog[space['origin']] = space;
    }
    directoryRequire(catalog.length <= 100);
    (state['heads'] as Map)[plan.document.id] = {
      'revision': plan.document.revision,
      'digest': plan.digest,
    };
    final merged = mergeSettings
        ? latest.settingsMerge.resolve(
            preferences.settingsActor,
            settingsChoices,
          )
        : null;
    state['pending'] = {
      'origins': plan.document.spaces.map((s) => s['origin']).toList(),
      'settings': merged == null
          ? null
          : {
              'v': 2,
              'before': latest.settingsMerge.local.data,
              'after': merged.data,
            },
    };
    if (merged == null) {
      await repository.write(state);
    } else {
      await preferences.applyMergedSettings(
        latest.settingsMerge.local,
        merged,
        () => repository.write(state),
      );
    }
    await _finish(state);
  });

  Future<void> resume() =>
      repository.exclusive(() async => _finish(await repository.read()));
  Future<void> _finish(Map<String, dynamic> state) async {
    final pending = state['pending'] as Map?;
    if (pending == null) return;
    final settings = pending['settings'];
    if (settings != null) {
      await _resumeSettings(settings);
    }
    for (final origin in (pending['origins'] as List).cast<String>().reversed) {
      if (!preferences.origins.contains(origin)) {
        await preferences.remember(origin);
      }
    }
    await preferences.flush();
    state['pending'] = null;
    await repository.write(state);
  }

  Future<void> _resumeSettings(Object data) async {
    if (data case {'v': 2}) {
      final (before, after) = checkedSettingsPending(data);
      await preferences.resumeMergedSettings(before, after);
      return;
    }
    // Уже подтверждённый журнал предыдущего формата, не новый импорт.
    final before = preferences.settingsSnapshot;
    final merge = SettingsMerge(
      before,
      SettingsSnapshot.initial(checkedDirectorySettings(data)),
      unknown: true,
    );
    final target = merge.resolve(preferences.settingsActor, {
      for (final key in merge.conflicts) key: SettingsChoice.incoming,
    });
    await preferences.resumeMergedSettings(before, target);
  }

  Future<List<String>> restoreFollowing({bool Function()? active}) async {
    final state = await repository.read(), result = <String>[];
    for (final raw in (state['catalog'] as Map).values) {
      if (!(active?.call() ?? true)) break;
      final space = checkedDirectorySpace(raw),
          origin = space['origin'] as String;
      try {
        result.add(await _restoreFollowing(space, active));
      } catch (_) {
        result.add(
          '$origin: подписки восстановлены не полностью; проверьте подключение, личность и права. Повтор безопасен.',
        );
      }
    }
    return result;
  }

  Future<String> _restoreFollowing(
    Map<String, dynamic> space,
    bool Function()? operationActive,
  ) async {
    final origin = space['origin'] as String,
        controller = controllers()[space['origin']];
    final session = controller?.mlsSession;
    if (controller == null || session == null || !controller.connected) {
      throw StateError('Нет подключения');
    }
    final feed = SessionFeedApi(session), api = SessionFeedApi(session).follows;
    if (api == null || feed.sections.isEmpty) {
      throw StateError('Нет доступной ленты');
    }
    bool active() =>
        (operationActive?.call() ?? true) &&
        !controller.isClosed &&
        identical(controllers()[origin], controller) &&
        controller.connected &&
        controller.mlsSession == session &&
        controller.principalId == space['principal_id'];
    final count = await applyDirectoryFollowing(
      space,
      api,
      feed.sections.first.id,
      active,
    );
    return '$origin: добавлено подписок — $count';
  }
}
