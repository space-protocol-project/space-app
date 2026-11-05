import 'registry_validation.dart';

void gitObjectId(Object? value) {
  if (value is! String || !RegExp(r'^[0-9a-f]{40}$').hasMatch(value)) {
    throw const FormatException('git_object');
  }
}

String gitRepository(String value) {
  final uri = Uri.parse(value);
  if (value.length > 256 ||
      uri.scheme != 'https' ||
      uri.host != 'github.com' ||
      uri.hasPort ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      !RegExp(r'^/[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+$').hasMatch(uri.path)) {
    throw const FormatException('github_repository');
  }
  var repository = uri.path.toLowerCase();
  if (repository.endsWith('.git')) {
    repository = repository.substring(0, repository.length - 4);
  }
  if (repository.endsWith('/.') ||
      repository.endsWith('/..') ||
      repository.endsWith('/')) {
    throw const FormatException('github_repository');
  }
  return 'https://github.com$repository';
}

void gitPath(String value) {
  if (value.length > 160 ||
      !RegExp(r'^[a-zA-Z0-9_-]+(/[a-zA-Z0-9_-]+)*$').hasMatch(value)) {
    throw const FormatException('package_path');
  }
}

void gitRef(String value) {
  if (RegExp(r'^[0-9a-f]{40}$').hasMatch(value)) return;
  if (value.length > 160 ||
      !RegExp(r'^refs/(heads|tags)/[A-Za-z0-9_./-]+$').hasMatch(value) ||
      value.endsWith('/') ||
      value.endsWith('.') ||
      value.endsWith('.lock') ||
      value.contains('..') ||
      value.contains('//')) {
    throw const FormatException('git_ref');
  }
}

class GitPackageSource {
  GitPackageSource(Map<String, Object?> value)
    : json = Map.unmodifiable(value) {
    registryKeys(value, [
      'kind',
      'repository',
      'ref',
      'ref_commit',
      'commit',
      'object_format',
      'path',
      'method',
      'publisher',
      'plugin',
    ]);
    if (value['kind'] != 'git' ||
        value['object_format'] != 'sha1' ||
        value['method'] != 'prebuilt-directory' ||
        gitRepository(value['repository'] as String) != value['repository']) {
      throw const FormatException('git_source');
    }
    gitRef(value['ref'] as String);
    gitObjectId(value['ref_commit']);
    gitObjectId(value['commit']);
    gitPath(value['path'] as String);
    registryDigest(value['publisher']);
    if (!RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9_-]*)+$')
            .hasMatch(value['plugin'] as String) ||
        (value['plugin'] as String).length > 128) {
      throw const FormatException('plugin_id');
    }
  }
  final Map<String, Object?> json;
}
