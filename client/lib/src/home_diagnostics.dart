import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'server_endpoints.dart';

enum HomeDiagnosisError { unsupported, failed }

class HomeDiagnosisUnsupported implements Exception {
  const HomeDiagnosisUnsupported();
}

class HomeDiagnosticCheck {
  const HomeDiagnosticCheck(this.code, this.status, this.target);
  final String code, status, target;

  factory HomeDiagnosticCheck.fromJson(Map<String, dynamic> value) {
    final code = value['code'] as String;
    final status = value['status'] as String;
    final target = value['target'] as String? ?? '';
    if (!RegExp(r'^[a-z_]{1,64}$').hasMatch(code) ||
        !['ok', 'warning', 'failed', 'unknown'].contains(status) ||
        target.length > 512 ||
        RegExp(r'[\x00-\x1f]').hasMatch(target)) {
      throw const FormatException('Некорректный результат диагностики');
    }
    return HomeDiagnosticCheck(code, status, target);
  }
}

class HomeDiagnosis {
  const HomeDiagnosis._(
    this.checks,
    this.endpoints,
    this.fingerprint,
    this.serverId,
    this.externalCheckedAt,
  );
  final List<HomeDiagnosticCheck> checks;
  final List<ServerEndpoint> endpoints;
  final String fingerprint, serverId;
  final DateTime? externalCheckedAt;

  factory HomeDiagnosis.fromJson(Map<String, dynamic> value) {
    final checks = value['checks'] as List;
    final fingerprint = value['fingerprint'] as String? ?? '';
    final serverId = value['server_id'] as String? ?? '';
    final external = value['external'];
    final checkedAt = value['external_checked_at_unix_ms'];
    if (value['format'] != 1 ||
        !['unverified', 'observed'].contains(external) ||
        (external == 'unverified' && checkedAt != null) ||
        checks.length > 24 ||
        (fingerprint.isNotEmpty &&
            !RegExp(r'^[0-9a-f]{64}$').hasMatch(fingerprint)) ||
        (serverId.isNotEmpty &&
            !RegExp(r'^srv_[0-9a-f]{32}$').hasMatch(serverId))) {
      throw const FormatException('Некорректный отчёт диагностики');
    }
    final parsedChecks = List<HomeDiagnosticCheck>.unmodifiable(
      checks.map(
        (e) =>
            HomeDiagnosticCheck.fromJson(Map<String, dynamic>.from(e as Map)),
      ),
    );
    final endpoints = parseEndpoints(value['endpoints']);
    final observed = parsedChecks.where((c) => c.code == 'external_observed');
    DateTime? timestamp;
    if (external == 'observed') {
      timestamp = _observedTime(checkedAt);
      if (fingerprint.isEmpty ||
          serverId.isEmpty ||
          observed.isEmpty ||
          observed.any(
            (c) =>
                c.status != 'ok' ||
                !endpoints.any((e) => e.origin.toString() == c.target),
          )) {
        throw const FormatException('Нет подтверждения внешнего подключения');
      }
    } else if (observed.isNotEmpty) {
      throw const FormatException('Противоречивое подтверждение подключения');
    }
    return HomeDiagnosis._(
      parsedChecks,
      endpoints,
      fingerprint,
      serverId,
      timestamp,
    );
  }

  String get outsideCommand {
    if (fingerprint.isEmpty || serverId.isEmpty) return '';
    final addresses = endpoints.map((e) => "-endpoint '${e.origin}'").join(' ');
    return 'space-server doctor $addresses -fingerprint $fingerprint -server-id $serverId';
  }
}

DateTime _observedTime(dynamic value) {
  final now = DateTime.now().millisecondsSinceEpoch;
  if (value is! int || value > now || now - value > 130000) {
    throw const FormatException('Устаревшее подтверждение подключения');
  }
  return DateTime.fromMillisecondsSinceEpoch(value);
}

Future<Map<String, dynamic>> runHomeDoctor(
  Directory runtime,
  List<String> arguments,
) async {
  final capabilities = await _doctorProcess(runtime, [
    '-runtime-info',
  ], timeout: const Duration(seconds: 5));
  if (capabilities['networkDoctorVersion'] != 2) {
    throw const HomeDiagnosisUnsupported();
  }
  return _doctorProcess(runtime, arguments);
}

Future<Map<String, dynamic>> _doctorProcess(
  Directory runtime,
  List<String> arguments, {
  Duration timeout = const Duration(seconds: 40),
}) async {
  final executable = Platform.isWindows ? 'space-server.exe' : 'space-server';
  final process = await Process.start('${runtime.path}/$executable', arguments);
  final timer = Timer(timeout, process.kill);
  unawaited(process.stderr.drain<void>().catchError((Object _) {}));
  try {
    final output = await process.stdout.fold<List<int>>([], (bytes, chunk) {
      if (bytes.length + chunk.length > 16384) {
        throw const FormatException('Слишком большой отчёт диагностики');
      }
      return bytes..addAll(chunk);
    });
    if (await process.exitCode != 0) {
      throw const FormatException('Диагностика не выполнена');
    }
    return Map<String, dynamic>.from(jsonDecode(utf8.decode(output)) as Map);
  } finally {
    timer.cancel();
    process.kill();
  }
}
