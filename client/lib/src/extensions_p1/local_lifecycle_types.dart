import 'registry_validation.dart';
import 'local_lifecycle_record.dart';

enum LocalLifecycleAction {
  install,
  enable,
  disable,
  drained,
  prepare,
  advance,
  publish,
  abort,
  quarantine,
  recover,
  remove,
  purge,
  reopen,
  restore,
  grant,
  revoke,
}

class LocalLifecycleCommand {
  const LocalLifecycleCommand({
    required this.action,
    required this.installation,
    required this.instance,
    required this.revision,
    required this.generation,
    this.package,
    this.plan,
    this.checkpoint,
    this.root,
  });
  final LocalLifecycleAction action;
  final String installation;
  final String instance;
  final int revision;
  final String generation;
  final String? package;
  final Map<String, Object?>? plan;
  final String? checkpoint;
  final String? root;
}

class LocalVerifiedPackage {
  LocalVerifiedPackage(this.digest, this.schema, List<String> requested)
    : requested = List.unmodifiable(requested) {
    registryDigest(digest);
    registrySchema(schema);
    validateRequested(requested);
  }
  final String digest;
  final int schema;
  final List<String> requested;
}

typedef LocalRestoreSnapshot = ({
  String scope,
  String instance,
  Map<String, Object?> entry,
});

// Реализация принадлежит ядру. Гость не передаёт результаты этих проверок.
abstract interface class LocalExtensionAuthority {
  Future<LocalVerifiedPackage> verifyPackage(String digest);
  Future<void> verifyCheckpoint(String digest, String data);
  Future<String> migrate(Map<String, Object?> plan, int step, String data);
  Future<bool> confirm(String action, String instance, String package);
  Future<String> selectDirectory(String instance, String package);
  Future<LocalRestoreSnapshot> restore(String checkpoint);
}
