import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'local_lifecycle_record.dart';
import 'local_lifecycle_types.dart';
import 'local_registry_codec.dart';

const localTransitionStates = <LocalLifecycleAction, List<String>>{
  LocalLifecycleAction.enable: ['disabled'],
  LocalLifecycleAction.disable: ['enabled'],
  LocalLifecycleAction.drained: ['draining'],
  LocalLifecycleAction.prepare: ['disabled'],
  LocalLifecycleAction.advance: ['updating'],
  LocalLifecycleAction.publish: ['ready'],
  LocalLifecycleAction.abort: ['updating', 'ready'],
  LocalLifecycleAction.quarantine: [
    'disabled',
    'enabled',
    'draining',
    'updating',
    'ready',
  ],
  LocalLifecycleAction.recover: ['quarantined'],
  LocalLifecycleAction.remove: ['disabled'],
  LocalLifecycleAction.purge: ['removed'],
  LocalLifecycleAction.grant: ['enabled'],
  LocalLifecycleAction.revoke: [
    'enabled',
    'disabled',
    'draining',
    'quarantined',
  ],
};

void requireLocalPlan(Map<String, Object?> entry, Map<String, Object?> plan) {
  validateLifecyclePlan(plan);
  final record = lifecycleOf(entry);
  final history = record['history']! as List;
  if (plan['source'] != entry['package'] ||
      plan['target'] == plan['source'] ||
      plan['schema_from'] != entry['schema'] ||
      (plan['schema_to']! as int) - (plan['schema_from']! as int) !=
          plan['steps'] ||
      plan['data_revision'] != record['data_revision'] ||
      history.contains(plan['plan_id']) ||
      history.length >= 128) {
    throw StateError('InvalidPlan');
  }
}

class LocalLifecycleTransition {
  LocalLifecycleTransition(this.authority, this.command, this.entry);
  final LocalExtensionAuthority authority;
  final LocalLifecycleCommand command;
  final Map<String, Object?> entry;
  Map<String, Object?> get record => lifecycleOf(entry);

  Future<void> apply() async {
    final handlers = <LocalLifecycleAction, Future<void> Function()>{
      LocalLifecycleAction.enable: enable,
      LocalLifecycleAction.prepare: prepare,
      LocalLifecycleAction.advance: advance,
      LocalLifecycleAction.publish: publish,
      LocalLifecycleAction.recover: recover,
      LocalLifecycleAction.purge: purge,
    };
    final handler = handlers[command.action];
    if (handler != null) {
      await handler();
    } else {
      simple();
    }
  }

  Future<LocalVerifiedPackage> verified(String digest, int schema) async {
    final package = await authority.verifyPackage(digest);
    if (package.digest != digest || package.schema != schema) { {
      throw StateError('UntrustedPackage');
    }
    }
    return package;
  }

  Future<void> consent(String digest) async {
    if (!await authority.confirm(
      command.action.name,
      command.instance,
      digest,
    )) {
      throw StateError('PermissionDenied');
    }
  }

  Future<void> enable() async {
    final package = await verified(
      entry['package']! as String,
      entry['schema']! as int,
    );
    if (jsonEncode(package.requested) != jsonEncode(record['requested'])) { {
      throw StateError('UntrustedPackage');
    }
    }
    await consent(package.digest);
    entry['state'] = 'enabled';
  }

  Future<void> prepare() async {
    final plan = command.plan;
    if (plan == null) throw StateError('InvalidPlan');
    requireLocalPlan(entry, plan);
    await verified(plan['target']! as String, plan['schema_to']! as int);
    await checkpoint(plan['checkpoint']! as String);
    record['plan'] = plan;
    entry['staged'] = {
      'package': plan['target'],
      'schema': plan['schema_to'],
      'data': entry['data'],
      'cursor': 0,
    };
    entry['state'] = plan['steps'] == 0 ? 'ready' : 'updating';
  }

  Future<void> checkpoint(String digest) async {
    final data = entry['data']! as String;
    if (sha256.convert(utf8.encode(data)).toString() != digest) { {
      throw StateError('InvalidCheckpoint');
    }
    }
    await authority.verifyCheckpoint(digest, data);
  }

  Future<void> advance() async {
    final plan = registryObject(record['plan']);
    requireLocalPlan(entry, plan);
    final staged = registryObject(entry['staged']);
    final step = staged['cursor']! as int;
    if (step >= (plan['steps']! as int)) throw StateError('InvalidPlan');
    final data = await authority.migrate(
      Map.unmodifiable(plan),
      step,
      staged['data']! as String,
    );
    staged['data'] = data;
    staged['cursor'] = step + 1;
    if (staged['cursor'] == plan['steps']) entry['state'] = 'ready';
  }

  Future<void> publish() async {
    final plan = registryObject(record['plan']);
    requireLocalPlan(entry, plan);
    final staged = registryObject(entry['staged']);
    if (staged['cursor'] != plan['steps']) throw StateError('InvalidPlan');
    final package = await verified(
      plan['target']! as String,
      plan['schema_to']! as int,
    );
    await checkpoint(plan['checkpoint']! as String);
    await consent(package.digest);
    entry['package'] = staged['package'];
    entry['schema'] = staged['schema'];
    entry['data'] = staged['data'];
    record['requested'] = package.requested;
    record['data_revision'] = (record['data_revision']! as int) + 1;
    (record['history']! as List).add(plan['plan_id']);
    discardStage();
  }

  Future<void> recover() async {
    await verified(entry['package']! as String, entry['schema']! as int);
    final digest = sha256
        .convert(utf8.encode(entry['data']! as String))
        .toString();
    await checkpoint(digest);
    discardStage();
  }

  Future<void> purge() async {
    if (record['present'] != true) throw StateError('FailedPrecondition');
    await consent(entry['package']! as String);
    record['present'] = false;
    entry['data'] = 'null';
  }

  void discardStage() {
    record['plan'] = null;
    entry['staged'] = null;
    entry['state'] = 'disabled';
  }

  void simple() {
    if (command.action == LocalLifecycleAction.abort) {
      discardStage();
      return;
    }
    final states = {
      LocalLifecycleAction.disable: 'draining',
      LocalLifecycleAction.drained: 'disabled',
      LocalLifecycleAction.quarantine: 'quarantined',
      LocalLifecycleAction.remove: 'removed',
    };
    final next = states[command.action];
    if (next != null) entry['state'] = next;
    if (command.action == LocalLifecycleAction.reopen &&
        ['enabled', 'draining'].contains(entry['state'])) {
      entry['state'] = 'disabled';
    }
  }
}
