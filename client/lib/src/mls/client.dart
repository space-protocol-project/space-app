import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';

import '../rpc_clients.dart';
import '../rpc_connection.dart';
import 'local_store.dart';
import 'envelope_checks.dart';

part 'delivery.dart';
part 'receive.dart';
part 'recovery.dart';
part 'maintenance.dart';

List<int> mlsId() => List.generate(16, (_) => Random.secure().nextInt(256));
String mlsFingerprint(Map<String, dynamic> binding) => sha256
    .convert(
      utf8.encode(
        jsonEncode([
          'space/mls/fingerprint/v1',
          (binding['device'] as Map)['server_id'],
          (binding['device'] as Map)['principal_id'],
          (binding['device'] as Map)['grant_id'],
          (binding['device'] as Map)['public_key'],
          binding['mls_public_key'],
        ]),
      ),
    )
    .toString();
Map<String, dynamic> mlsBinding(MlsDevice device) =>
    jsonDecode(utf8.decode(device.binding)) as Map<String, dynamic>;

List<Map<String, dynamic>> mergeMlsHistory(Iterable<dynamic> items) => {
  for (final item in items)
    jsonEncode([item['grant_id'], item['message']['id']]):
        Map<String, dynamic>.from(item as Map),
}.values.toList();

class MlsChannelData {
  MlsChannelData(this.channel, {this.untrusted = const []});
  final Map<String, dynamic> channel;
  final List<MlsDevice> untrusted;
  bool get joined => channel['joined'] == true;
  List<Map<String, dynamic>> get messages => mergeMlsHistory([
    ...?channel['archived_messages'] as List?,
    ...channel['messages'] as List,
  ]);
}

class MlsClient {
  MlsClient({
    required this.local,
    required this.connection,
    required this.options,
    this.pinChannel,
    this.attachmentsEnabled,
  });
  final MlsLocalStore local;
  final RpcConnection connection;
  final Future<RpcOptions> Function() options;
  final Future<void> Function(String id, List<int> group)? pinChannel;
  final bool Function()? attachmentsEnabled;
  bool get filesAllowed => attachmentsEnabled?.call() ?? true;
  bool _registered = false;
  Future<void>? _maintenance;
  DateTime? _maintainedAt;
  final _operationZone = Object();
  Future<void> _tail = Future.value();

  Future<T> _serial<T>(Future<T> Function() operation) async {
    if (Zone.current[_operationZone] == this) return operation();
    final previous = _tail;
    final done = Completer<void>();
    _tail = done.future;
    await previous;
    try {
      return await runZoned(operation, zoneValues: {_operationZone: this});
    } finally {
      done.complete();
    }
  }

  MlsServiceClient get rpc => MlsServiceClient(connection);

  Future<void> initialize() => _serial(_initialize);

  Future<void> _initialize() async {
    if (_registered) return;
    final package = await local.update('key_package', {});
    final document = await local.read();
    await rpc.registerMlsDevice(
      RegisterMlsDeviceRequest(
        binding: utf8.encode(jsonEncode(document['binding'])),
        keyPackage: base64Decode(package['key_package'] as String),
      ),
      options: await options(),
    );
    _registered = true;
  }

  Future<Map<String, dynamic>> ownBinding() async =>
      Map<String, dynamic>.from((await local.read())['binding'] as Map);

  Future<void> trust(MlsDevice device) => local.change((document) {
    final binding = mlsBinding(device);
    final scope = binding['device'] as Map;
    if (scope['grant_id'] != device.grantId ||
        scope['principal_id'] != device.principalId ||
        scope['server_id'] != local.scope['server_id']) {
      throw StateError('Привязка устройства не соответствует пространству');
    }
    (document['trusted'] as Map)[device.grantId] = mlsFingerprint(binding);
  });

  Future<List<MlsDevice>> devices(String channel) async {
    final result = <MlsDevice>[];
    var after = '';
    do {
      final page = await rpc.listMlsDevices(
        ListMlsDevicesRequest(channelId: channel, after: after),
        options: await options(),
      );
      result.addAll(page.devices);
      if (result.length > 4096 ||
          page.nextCursor.isNotEmpty &&
              (page.devices.isEmpty || page.nextCursor.compareTo(after) <= 0)) {
        throw StateError('Некорректная страница устройств MLS');
      }
      after = page.nextCursor;
    } while (after.isNotEmpty);
    return result;
  }

  Future<void> createChannel(
    String id,
    String title, {
    int position = 0,
  }) async {
    await initialize();
    final existing = ((await local.read())['channels'] as Map)[id] as Map?;
    final group = existing == null
        ? utf8.encode(
            jsonEncode([
              'space/mls/group/v1',
              local.scope['server_id'],
              id,
              base64UrlEncode(mlsId()),
            ]),
          )
        : base64Decode(existing['group_id'] as String);
    if (existing == null) {
      await local.update(
        'create_group',
        {'group_id': base64Encode(group)},
        change: (document, result) {
          (document['channels'] as Map)[id] = _newChannel(group)
            ..['joined'] = true
            ..['managers'] = [local.scope['grant_id']]
            ..['roster'] = [document['binding']];
        },
      );
    }
    await pinChannel?.call(id, group);
    try {
      await ChannelServiceClient(connection).createChannel(
        CreateChannelRequest(
          channelId: id,
          title: title,
          viewType: 'chat',
          position: position,
          mlsGroupId: group,
        ),
        options: await options(),
      );
    } on GrpcError catch (error) {
      if (error.code != StatusCode.alreadyExists) rethrow;
      final listed = await ChannelServiceClient(connection)
          .listChannels(ListChannelsRequest(), options: await options());
      final saved = listed.channels.where((c) => c.id == id).firstOrNull;
      if (saved == null ||
          base64Encode(saved.mlsGroupId) != base64Encode(group)) {
        rethrow;
      }
    }
  }

  Future<MlsChannelData> refresh(String channelId, List<int> groupId) =>
      _serial(() => _refresh(channelId, groupId));

  Future<MlsChannelData> _refresh(
    String channelId,
    List<int> groupId, {
    bool maintain = true,
  }) async {
    await initialize();
    _checkGroupContext(channelId, groupId);
    await _ensureLocalChannel(channelId, groupId);
    try {
      await _flush(channelId);
    } on GrpcError catch (error) {
      if (error.code != StatusCode.aborted &&
          error.code != StatusCode.failedPrecondition) {
        rethrow;
      }
    }
    final document = await local.read();
    final channel = _channel(document, channelId);
    final page = await rpc.listMlsEnvelopes(
      ListMlsEnvelopesRequest(
        channelId: channelId,
        afterSequence: Int64(channel['cursor'] as int),
      ),
      options: await options(),
    );
    requireMlsPage(channel, page);
    for (final envelope in page.envelopes) {
      final unknown = await _receive(channelId, envelope);
      if (unknown.isNotEmpty) {
        return MlsChannelData(
          _channel(await local.read(), channelId),
          untrusted: unknown,
        );
      }
    }
    if (maintain) {
      await maintainChannels();
      await _retryRebasedMessage(channelId);
    }
    return MlsChannelData(_channel(await local.read(), channelId));
  }

  Future<void> _ensureLocalChannel(String id, List<int> group) =>
      local.change((document) {
        final channels = document['channels'] as Map;
        if (channels[id] == null) channels[id] = _newChannel(group);
        if ((channels[id] as Map)['group_id'] != base64Encode(group)) {
          throw StateError('Идентификатор зашифрованной группы изменился');
        }
      });

  Map<String, dynamic> _newChannel(List<int> group) => {
    'group_id': base64Encode(group),
    'joined': false,
    'epoch': 0,
    'last_self_update': DateTime.now().millisecondsSinceEpoch,
    'cursor': 0,
    'revocation_pending': false,
    'revoked_devices': <dynamic>[],
    'messages': <dynamic>[],
    'managers': <dynamic>[],
    'roster': <dynamic>[],
    'outbox': <dynamic>[],
  };

  Map<String, dynamic> _channel(Map<String, dynamic> document, String id) =>
      (document['channels'] as Map)[id] as Map<String, dynamic>;

  void _checkGroupContext(String channel, List<int> group) {
    final context = jsonDecode(utf8.decode(group)) as List;
    if (context.length != 4 ||
        context[0] != 'space/mls/group/v1' ||
        context[1] != local.scope['server_id'] ||
        context[2] != channel) {
      throw StateError('MLS-группа не соответствует выбранному каналу');
    }
  }

  List<MlsDevice> _unknown(
    Map<String, dynamic> document,
    List<MlsDevice> roster,
  ) {
    final own = mlsFingerprint(
      Map<String, dynamic>.from(document['binding'] as Map),
    );
    return roster.where((device) {
      final fingerprint = mlsFingerprint(mlsBinding(device));
      return fingerprint != own &&
          (document['trusted'] as Map)[device.grantId] != fingerprint;
    }).toList();
  }
}
