import 'package:grpc/grpc.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart';

import '../generated/space/v1/builtin.pb.dart';
import '../generated/space/v1/builtin.connect.spec.dart';
import '../rpc_connection.dart';
import 'commands.dart';

abstract interface class BuiltinTransport {
  Future<List<BuiltinSection>> list();
  Future<BuiltinSection> open(String instance);
}

class ConnectBuiltinTransport implements BuiltinTransport {
  ConnectBuiltinTransport(
    this.connection,
    this.options,
    this.prepare,
    this.scope,
  );
  final RpcConnection connection;
  final RpcOptions Function() options;
  final Future<void> Function() prepare;
  final String Function() scope;
  String? _owner;
  Map<String, BuiltinSection> _sections = {};
  final _releaseSections = <String, BuiltinSection>{};

  void _check(String owner) {
    if (scope() != owner) {
      _sections = {};
      _releaseSections.clear();
      throw const GrpcError.cancelled('Сессия изменилась');
    }
  }

  @override
  Future<List<BuiltinSection>> list() async {
    await prepare();
    final owner = scope();
    final result = await connection.unary(
      BuiltinExtensionService.listBuiltinSections,
      ListBuiltinSectionsRequest(),
      options: options(),
    );
    _check(owner);
    final sections = result.sections.map(validateSection).toList();
    _sections = {for (final section in sections) section.channel.id: section};
    if (_sections.length != sections.length) {
      throw const FormatException('Повтор экземпляра');
    }
    if (_owner != owner) _releaseSections.clear();
    _releaseSections.addAll(_sections);
    _owner = owner;
    connection.commandAdapter = route;
    return sections;
  }

  @override
  Future<BuiltinSection> open(String instance) async {
    await prepare();
    final owner = scope();
    final result = await connection.unary(
      BuiltinExtensionService.openBuiltinSection,
      OpenBuiltinSectionRequest(instanceId: instance),
      options: options(),
    );
    _check(owner);
    final section = validateSection(result.section);
    if (section.instanceId != instance) {
      throw const FormatException('Подмена экземпляра');
    }
    validateContent(section, result.content);
    return section;
  }

  Future<Any>? route(GeneratedMessage input, RpcOptions? callOptions) {
    final plugin = commandPlugins[input.info_.qualifiedMessageName];
    if (plugin == null) return null;
    return _command(input, plugin, callOptions);
  }

  Future<Any> _command(
    GeneratedMessage input,
    String plugin,
    RpcOptions? callOptions,
  ) async {
    final owner = _owner;
    if (owner == null) throw const GrpcError.unauthenticated();
    _check(owner);
    final id = commandChannel(input);
    final release =
        input.info_.qualifiedMessageName == 'space.v1.LeaveVoiceRoomRequest';
    if (!release && !_sections.containsKey(id)) await list();
    _check(owner);
    final section = release ? _releaseSections[id] : _sections[id];
    if (section == null || section.pluginId != plugin) {
      throw const GrpcError.notFound('Раздел отсутствует в реестре');
    }
    // Снимок исключает изменение текста/ключа вызывающим кодом между повторами.
    final payload = Any(
      typeUrl: 'type.googleapis.com/${input.info_.qualifiedMessageName}',
      value: input.writeToBuffer(),
    );
    final request = ExecuteBuiltinCommandRequest(
      instanceId: section.instanceId,
      command: payload,
    )..freeze();
    return _send(request, callOptions, owner, retryableCommand(input));
  }

  Future<Any> _send(
    ExecuteBuiltinCommandRequest request,
    RpcOptions? callOptions,
    String owner,
    bool retry,
  ) async {
    try {
      final result = await connection.unary(
        BuiltinExtensionService.executeBuiltinCommand,
        request,
        options: callOptions,
      );
      _check(owner);
      return result.result;
    } on GrpcError catch (error) {
      _check(owner);
      if (!retry ||
          ![
            StatusCode.unavailable,
            StatusCode.deadlineExceeded,
          ].contains(error.code)) {
        rethrow;
      }
      return _send(request, callOptions, owner, false);
    }
  }
}

const builtinViews = {
  'space.chat': 'chat',
  'space.rooms': 'voice_room',
  'space.discussions': 'forum',
  'space.feed': 'feed',
};

BuiltinSection validateSection(BuiltinSection section) {
  final view = builtinViews[section.pluginId];
  final channel = section.channel;
  if (view == null ||
      section.viewId != view ||
      section.installationId != 'builtin:$view' ||
      section.instanceId != 'builtin:${channel.id}:$view') {
    throw const FormatException('Некорректная связь экземпляра');
  }
  if (channel.id.isEmpty ||
      channel.archived ||
      !channel.permissions.read ||
      section.version != 'legacy.p2') {
    throw const FormatException('Раздел недоступен');
  }
  return section..freeze();
}

void validateContent(BuiltinSection section, Any content) {
  final name = switch (section.pluginId) {
    'space.chat' =>
      section.channel.mlsGroupId.isEmpty
          ? 'ListContentResponse'
          : 'ListMlsEnvelopesResponse',
    'space.rooms' => 'GetVoiceRoomResponse',
    'space.discussions' => 'ListForumThreadsResponse',
    'space.feed' => 'ListFeedPostsResponse',
    _ => '',
  };
  if (content.typeUrl != 'type.googleapis.com/space.v1.$name') {
    throw const FormatException('Неверный тип содержимого');
  }
}
