import 'dart:async';
import 'dart:convert';

import 'package:space_directory_noise/space_directory_noise.dart';

import 'core.dart' show Discovery, url64;
import 'directory_backup.dart';
import 'directory_document.dart';
import 'directory_transfer_noise.dart';
import 'directory_transfer_qr.dart';
import 'directory_transfer_rpc.dart';

typedef _TransferLease = ({String id, String token, int created, int expires});

/// Одна попытка передачи. Секреты и полномочия не попадают в состояние экрана.
class DirectoryTransfer {
  DirectoryTransfer(this.server, this.relay, this.engine);
  final Discovery server;
  final DirectoryRelay relay;
  final DirectoryNoiseEngine engine;
  DirectoryNoiseChannel? _noise;
  String _id = '', _token = '';
  int _expires = 0;
  final _age = Stopwatch()..start();
  bool _closed = false, _delivered = false, _started = false;
  String get sas => _noise?.sas ?? '';

  void _begin() {
    _active();
    if (_started) throw StateError('Directory transfer already started');
    _started = true;
  }

  void _active() {
    if (_closed || _age.elapsed.inSeconds >= 300) {
      throw StateError('Directory transfer closed');
    }
    if (_expires != 0) {
      directoryRequire(
        DateTime.now().millisecondsSinceEpoch ~/ 1000 < _expires,
      );
    }
  }

  void _lease(_TransferLease lease, {required String prefix}) {
    final (:id, :token, :created, :expires) = lease;
    _id = id;
    _token = token;
    _expires = expires;
    _active();
    directoryRequire(RegExp(r'^dt_[A-Za-z0-9_-]{43}$').hasMatch(id));
    directoryRequire(RegExp('^${prefix}_[A-Za-z0-9_-]{43}\$').hasMatch(token));
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    directoryRequire(created <= now + 5 && created >= now - 300);
    directoryRequire(expires == created + 300 && expires <= now + 305);
  }

  Future<void> _channel(bool initiator, DirectoryTransferQr qr) async {
    final channel = await DirectoryNoiseChannel.open(
      engine,
      initiator: initiator,
      context: qr.context,
      expected: initiator
          ? null
          : base64Url.decode(base64Url.normalize(qr.public)),
    );
    if (_closed) {
      await channel.close();
      throw StateError('Directory transfer cancelled');
    }
    _noise = channel;
    _active();
  }

  Future<DirectoryTransferQr> receiveStart() async {
    _begin();
    final lease = await relay.create(
      CreateDirectoryTransferRequest(profile: directoryNoiseProfile),
    );
    _lease((
      id: lease.id,
      token: lease.ownerToken,
      created: lease.createdAt.toInt(),
      expires: lease.expiresAt.toInt(),
    ), prefix: 'dr');
    directoryRequire(RegExp(r'^dc_[A-Za-z0-9_-]{43}$').hasMatch(lease.code));
    final qr = DirectoryTransferQr(
      server.origin.toString(),
      server.serverId,
      url64(server.publicKey),
      server.tlsFingerprint,
      _id,
      lease.code,
      '',
      _expires,
    );
    await _channel(true, qr);
    await _put(0, await _noise!.writeHandshake());
    return DirectoryTransferQr(
      qr.origin,
      qr.server,
      qr.key,
      qr.tls,
      qr.id,
      qr.code,
      url64(_noise!.public),
      qr.expires,
    );
  }

  Future<void> receiveHandshake() async {
    await _noise!.readHandshake(await _control(1));
    await _put(2, await _noise!.writeHandshake());
  }

  Future<void> sendStart(DirectoryTransferQr qr) async {
    _begin();
    qr.checkServer(server);
    final lease = await relay.open(OpenDirectoryTransferRequest(code: qr.code));
    _lease((
      id: lease.id,
      token: lease.peerToken,
      created: lease.createdAt.toInt(),
      expires: lease.expiresAt.toInt(),
    ), prefix: 'ds');
    directoryRequire(lease.id == qr.id && _expires == qr.expires);
    await _channel(false, qr);
    await _noise!.readHandshake(await _control(0));
    await _put(1, await _noise!.writeHandshake());
    await _noise!.readHandshake(await _control(2));
    _active();
  }

  Future<void> _put(
    int sequence,
    List<int> data, {
    bool finalRecord = false,
  }) async {
    _active();
    final request = WriteDirectoryFrameRequest(
      id: _id,
      token: _token,
      sequence: sequence,
      data: data,
      finalRecord: finalRecord,
    );
    try {
      await relay.write(request);
    } catch (_) {
      _active();
      // Повторяем те же байты, а не шифрование с новым nonce.
      await relay.write(request);
    }
    _active();
  }

  Future<ReadDirectoryFrameResponse> _read(int sequence) async {
    while (true) {
      _active();
      final frame = await relay.read(
        ReadDirectoryFrameRequest(id: _id, token: _token, sequence: sequence),
      );
      _active();
      directoryRequire(frame.expiresAt.toInt() == _expires);
      if (frame.available) {
        directoryRequire(frame.data.isNotEmpty && frame.data.length <= 65535);
        return frame;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<List<int>> _control(int sequence) async {
    final frame = await _read(sequence);
    directoryRequire(!frame.finalRecord && frame.data.length <= 512);
    return frame.data;
  }

  Future<DirectoryRestorePlan> receive(DirectoryBackupService service) async {
    _active();
    await _noise!.confirm(sas);
    await _put(3, await _noise!.confirmation());
    final frames = <List<int>>[];
    var wire = 0;
    while (frames.length < 71) {
      final frame = await _read(4 + frames.length);
      wire += frame.data.length;
      directoryRequire(wire <= 5 * 1024 * 1024);
      frames.add(frame.data);
      if (frame.finalRecord) break;
    }
    directoryRequire((await _read(3 + frames.length)).finalRecord);
    final plain = await _noise!.openDirectory(frames);
    try {
      final document = DirectoryDocument.parse(jsonDecode(utf8.decode(plain)));
      directoryRequire(
        document.spaces.isNotEmpty && document.spaces.length <= 12,
      );
      directoryRequire(document.revision == 1 && document.parent.isEmpty);
      final plan = await service.preview(document);
      _active();
      await _put(4 + frames.length, await _noise!.receipt());
      _delivered = true;
      await _noise!.close();
      return plan;
    } finally {
      plain.fillRange(0, plain.length, 0);
    }
  }

  Future<void> send(String comparison, DirectoryDocument document) async {
    _active();
    await _noise!.confirm(comparison);
    await _noise!.receiveConfirmation(await _control(3));
    final plain = document.encode();
    late final List<List<int>> frames;
    try {
      frames = await _noise!.seal(plain);
    } finally {
      plain.fillRange(0, plain.length, 0);
    }
    for (var i = 0; i < frames.length; i++) {
      await _put(4 + i, frames[i], finalRecord: i == frames.length - 1);
    }
    await _noise!.receiveReceipt(await _control(4 + frames.length));
    await close();
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _noise?.close();
    try {
      if (_id.isNotEmpty && !_delivered) {
        await relay.close(
          CloseDirectoryTransferRequest(id: _id, token: _token),
        );
      }
    } catch (_) {
      // Истёкший либо уже удалённый relay не возобновляется.
    } finally {
      _token = '';
      await relay.dispose();
    }
  }
}
