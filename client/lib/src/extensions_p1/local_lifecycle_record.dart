import 'dart:math';

import 'registry_validation.dart';

String localGeneration() {
  final random = Random.secure();
  return List.generate(
    16,
    (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();
}

Map<String, Object?> lifecycleOf(Map<String, Object?> entry) =>
    registryObject(entry['lifecycle']);

void lifecycleInteger(
  Object? value, {
  int minimum = 0,
  int maximum = 2147483646,
}) {
  if (value is! int || value < minimum || value > maximum) {
    {
      throw const FormatException('lifecycle_integer');
    }
  }
}

void lifecycleToken(Object? value) {
  if (value is! String || !RegExp(r'^[0-9a-f]{32}$').hasMatch(value)) {
    {
      throw const FormatException('lifecycle_token');
    }
  }
}

void validateRequested(Object? value) {
  if (value is! List ||
      value.length > 1 ||
      value.any((item) => item != 'device.catalog.read')) {
    throw const FormatException('lifecycle_capabilities');
  }
}

void validateLifecyclePlan(Map<String, Object?> plan) {
  registryKeys(plan, [
    'plan_id',
    'source',
    'target',
    'schema_from',
    'schema_to',
    'data_revision',
    'checkpoint',
    'steps',
  ]);
  lifecycleToken(plan['plan_id']);
  for (final key in ['source', 'target', 'checkpoint']) {
    registryDigest(plan[key]);
  }
  registrySchema(plan['schema_from']);
  registrySchema(plan['schema_to']);
  lifecycleInteger(plan['data_revision']);
  lifecycleInteger(plan['steps'], maximum: 32);
}

void validateLifecycleRecord(Map<String, Object?> entry) {
  final record = lifecycleOf(entry);
  registryKeys(record, [
    'version',
    'revision',
    'generation',
    'epoch',
    'data_revision',
    'present',
    'requested',
    'plan',
    'history',
    'grants',
    'audit',
  ]);
  if (record['version'] != 1 || record['present'] is! bool) {
    {
      throw const FormatException('lifecycle_version');
    }
  }
  for (final key in ['revision', 'epoch']) {
    lifecycleInteger(record[key], minimum: 1);
  }
  lifecycleInteger(record['data_revision']);
  lifecycleToken(record['generation']);
  validateRequested(record['requested']);
  _validateHistory(record['history']);
  _validateGrants(registryObject(record['grants']));
  _validateAudit(record['audit'], record['revision']! as int);
  _validatePending(entry, record);
  _validateAccess(entry, record);
}

void _validateAccess(Map<String, Object?> entry, Map<String, Object?> record) {
  if (record['present'] == false &&
      (entry['state'] != 'removed' ||
          entry['data'] != 'null' ||
          entry['staged'] != null)) {
    throw const FormatException('purged_state');
  }
  for (final value in registryObject(record['grants']).values) {
    if (registryObject(value)['active'] != true) continue;
    if (entry['state'] != 'enabled' ||
        !(record['requested']! as List).contains('device.catalog.read')) {
      throw const FormatException('active_grant_state');
    }
  }
}

void _validateHistory(Object? value) {
  if (value is! List ||
      value.length > 128 ||
      value.toSet().length != value.length) {
    throw const FormatException('lifecycle_history');
  }
  for (final id in value) {
    lifecycleToken(id);
  }
}

void _validateGrants(Map<String, Object?> grants) {
  if (grants.length > 16) throw const FormatException('grant_limit');
  for (final item in grants.entries) {
    lifecycleToken(item.key);
    final grant = registryObject(item.value);
    registryKeys(grant, ['revision', 'active']);
    lifecycleInteger(grant['revision'], minimum: 1);
    if (grant['active'] is! bool) throw const FormatException('grant_state');
  }
}

void _validateAudit(Object? value, int revision) {
  if (value is! List || value.isEmpty || value.length > 256) {
    {
      throw const FormatException('audit_limit');
    }
  }
  var previous = 0;
  for (final item in value) {
    final event = registryObject(item);
    registryKeys(event, ['action', 'actor', 'revision']);
    validateRegistryName(event['action']! as String);
    validateRegistryName(event['actor']! as String);
    lifecycleInteger(
      event['revision'],
      minimum: previous + 1,
      maximum: revision,
    );
    previous = event['revision']! as int;
  }
  if (previous != revision) throw const FormatException('audit_revision');
}

void _validatePending(Map<String, Object?> entry, Map<String, Object?> record) {
  final plan = record['plan'];
  if (plan == null) {
    if (entry['staged'] != null) {
      throw const FormatException('unexpected_stage');
    }
    return;
  }
  final value = registryObject(plan);
  validateLifecyclePlan(value);
  _validatePlanBinding(entry, record, value);
  final staged = registryObject(entry['staged']);
  if (staged['package'] != value['target'] ||
      staged['schema'] != value['schema_to'] ||
      (staged['cursor']! as int) > (value['steps']! as int)) {
    throw const FormatException('stage_binding');
  }
  final complete = staged['cursor'] == value['steps'];
  if (entry['state'] == 'ready' && !complete ||
      entry['state'] == 'updating' && complete) {
    throw const FormatException('stage_state');
  }
}

void _validatePlanBinding(
  Map<String, Object?> entry,
  Map<String, Object?> record,
  Map<String, Object?> plan,
) {
  if (!['updating', 'ready', 'quarantined'].contains(entry['state']) ||
      plan['source'] != entry['package'] ||
      plan['schema_from'] != entry['schema'] ||
      plan['source'] == plan['target'] ||
      plan['data_revision'] != record['data_revision']) {
    throw const FormatException('plan_binding');
  }
  if ((plan['schema_to']! as int) - (plan['schema_from']! as int) !=
          plan['steps'] ||
      (record['history']! as List).contains(plan['plan_id'])) {
    throw const FormatException('plan_history');
  }
}

Map<String, Object?> newLifecycleRecord(List<String> requested, String actor) =>
    {
      'version': 1,
      'revision': 1,
      'generation': localGeneration(),
      'epoch': 1,
      'data_revision': 0,
      'present': true,
      'requested': requested,
      'plan': null,
      'history': <String>[],
      'grants': <String, Object?>{},
      'audit': <Object?>[
        {'action': 'install', 'actor': actor, 'revision': 1},
      ],
    };

void advanceLifecycleRecord(
  Map<String, Object?> entry,
  String action,
  String actor,
) {
  final record = lifecycleOf(entry);
  final revision = (record['revision']! as int) + 1;
  lifecycleInteger(revision, minimum: 1);
  final epoch = (record['epoch']! as int) + 1;
  lifecycleInteger(epoch, minimum: 1);
  record['revision'] = revision;
  record['epoch'] = epoch;
  record['generation'] = localGeneration();
  final grants = registryObject(record['grants']);
  for (final value in grants.values) {
    final grant = registryObject(value);
    grant['active'] = false;
    grant['revision'] = (grant['revision']! as int) + 1;
  }
  (record['audit']! as List).add({
    'action': action,
    'actor': actor,
    'revision': revision,
  });
  // Все пределы проверяются до записи снимка, включая журнал аудита и grants.
}
