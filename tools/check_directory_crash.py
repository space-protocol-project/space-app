"""SIGKILL настоящих Flutter-процессов и холодное восстановление каталога в CI."""
import argparse
import base64
import json
import os
from pathlib import Path
import signal
import shutil
import subprocess
import sys
import time

from check_community_interop import free_ports, ready, stop


class CrashRun:
    def __init__(self, args, origin, root, profile=None, replace=False, stage='', timeout=False):
        self.args, self.origin, self.root = args, origin, root
        self.root.mkdir(parents=True, exist_ok=False)
        self.target = profile or root / 'target-profile'
        self.source = root / 'source-profile'
        self.replace, self.stage, self.timeout = replace, stage, timeout
        self.processes = []
        self.logs = []

    def start(self, role, profile=None):
        profile = profile or (self.source if role in ('source', 'inspect-source') else self.target)
        profile.mkdir(parents=True, exist_ok=True)
        environment = dict(os.environ)
        environment.update({
            'DIRECTORY_CRASH_ROLE': role, 'DIRECTORY_CRASH_CONTROL': str(self.root),
            'DIRECTORY_CRASH_PROFILE': str(profile), 'DIRECTORY_CRASH_RELAY': self.origin,
            'DIRECTORY_CRASH_STAGE': self.stage, 'DIRECTORY_CRASH_REPLACE': '1' if self.replace else '0',
            'DIRECTORY_CRASH_TIMEOUT': '1' if self.timeout else '0',
            'XDG_DATA_HOME': str(profile / 'data'), 'XDG_CONFIG_HOME': str(profile / 'config'),
            'XDG_CACHE_HOME': str(profile / 'cache'), 'LIBGL_ALWAYS_SOFTWARE': '1',
        })
        log = (self.root / f'{role}-{len(self.processes)}.log').open('w', encoding='utf-8')
        self.logs.append(log)
        command = ['dbus-run-session', '--', sys.executable,
                   str(Path(__file__).with_name('directory_keyring_session.py')),
                   str(self.args.app.resolve())]
        if os.name == 'nt':
            # Mutex вычисляется по пути exe. Разные профили запускаются параллельно.
            bundle = profile / 'bundle'
            if not bundle.exists():
                shutil.copytree(self.args.app.resolve().parent, bundle)
            command = [str(bundle / self.args.app.name)]
            if role == 'target' and self.stage == 'encrypted-journal':
                environment['SPACE_VAULT_DRILL_KEY'] = 'space.directory.v1'
                environment['SPACE_VAULT_DRILL_READY'] = str(self.root / 'encrypted-ready')
        process = subprocess.Popen(command, env=environment, stdout=log, stderr=log,
                                   start_new_session=os.name != 'nt')
        self.processes.append(process)
        return process

    def wait_file(self, name, processes, timeout=90):
        path = self.root / f'{name}.json'
        deadline = time.monotonic() + timeout
        while not path.exists():
            for process in processes:
                if process.poll() is not None:
                    raise RuntimeError(f'Процесс {process.pid} завершился до {name}: {process.returncode}')
            if time.monotonic() >= deadline:
                raise TimeoutError(f'Нет контрольной точки {name}')
            time.sleep(.05)
        return json.loads(path.read_text(encoding='utf-8'))

    def finish(self, process, role, timeout=40):
        code = process.wait(timeout=timeout)
        if code or not (self.root / f'done-{role}.json').exists():
            raise RuntimeError(f'Роль {role} не подтверждена: {code}')
        if sys.platform == 'linux':
            proof = json.loads((self.root / f'storage-proof-{role}.json').read_text(encoding='utf-8'))
            done = json.loads((self.root / f'done-{role}.json').read_text(encoding='utf-8'))
            if (proof['pid'] != done['pid'] or proof['file_fixture'] or
                    not proof['independent_read'] or not proof['encrypted_keyring']):
                raise RuntimeError('Процесс не подтвердил настоящее системное хранилище')

    def run(self, role):
        self.finish(self.start(role), role)

    def kill(self, process, role):
        marker = self.wait_file(f'checkpoint-{role}', [process])
        actual_pid = marker['pid']
        if self.stage == 'encrypted-journal':
            deadline = time.monotonic() + 25
            while not (self.root / 'encrypted-ready').exists():
                if process.poll() is not None or time.monotonic() >= deadline:
                    raise RuntimeError('Нет контрольной точки внутри DPAPI-записи')
                time.sleep(.02)
        self.terminate(process, actual_pid)
        (self.root / f'killed-{role}.json').write_text(json.dumps(marker), encoding='utf-8')

    def terminate(self, process, actual_pid):
        if process.poll() is not None:
            raise RuntimeError('Процесс уже завершился')
        if os.name == 'nt':
            if actual_pid != process.pid:
                raise RuntimeError('PID не принадлежит созданному процессу')
            process.kill()
            if process.wait(timeout=15) == 0:
                raise RuntimeError('Не подтверждено принудительное завершение')
            return
        if os.getpgid(actual_pid) != process.pid or process.pid == os.getpgrp():
            raise RuntimeError('Чужой процесс либо неверная группа; SIGKILL запрещён')
        os.killpg(process.pid, signal.SIGKILL)
        if process.wait(timeout=15) != -signal.SIGKILL:
            raise RuntimeError('Не подтверждено принудительное завершение процесса')

    def pair(self, allow_apply=True):
        if allow_apply:
            (self.root / 'allow-apply.json').write_text('{}', encoding='utf-8')
        target = self.start('target')
        self.wait_file('qr', [target])
        source = self.start('source')
        return source, target

    def cleanup(self):
        for process in self.processes:
            if process.poll() is None:
                self.terminate(process, process.pid)
        for log in self.logs:
            log.close()


def fresh_retry(args, origin, old, reports):
    retry = CrashRun(args, origin, old.root / 'retry', profile=old.target)
    # Ожидаемый прежний профиль — из предыдущей попытки, а не новый init.
    (retry.root / 'baseline.json').write_bytes((old.root / 'baseline.json').read_bytes())
    try:
        source, target = retry.pair()
        retry.finish(source, 'source')
        retry.finish(target, 'target')
        retry.run('verify')
        before = json.loads((old.root / 'qr.json').read_text(encoding='utf-8'))
        after = json.loads((retry.root / 'qr.json').read_text(encoding='utf-8'))
        before = json.loads(base64.urlsafe_b64decode(before.split('v1:', 1)[1]))
        after = json.loads(base64.urlsafe_b64decode(after.split('v1:', 1)[1]))
        if before['id'] == after['id'] or before['public'] == after['public']:
            raise RuntimeError('Повтор использовал прежний канал либо публичный ключ')
        if (old.root / 'sas-target.json').exists():
            if (old.root / 'sas-target.json').read_bytes() == (retry.root / 'sas-target.json').read_bytes():
                raise RuntimeError('Повтор использовал прежний SAS')
        reports.append({'case': old.root.name + '/fresh-retry', 'result': 'passed'})
        print(f'DIRECTORY_CRASH_CASE_OK: {old.root.name}/fresh-retry', flush=True)
    finally:
        retry.cleanup()


def transfer_cases(args, origin, reports):
    for name, stage in [('handshake', 'handshake'), ('partial-receiver', 'source-first-frame'), ('preview', 'preview')]:
        case = CrashRun(args, origin, args.output / name, stage=stage)
        try:
            case.run('init')
            if name == 'handshake':
                target = case.start('target')
                case.kill(target, 'target')
            else:
                source, target = case.pair(allow_apply=False)
                if name == 'partial-receiver':
                    case.wait_file('checkpoint-source', [source, target])
                    # Получатель уже принял первый зашифрованный кадр.
                    actual_pid = case.wait_file('target-frame-seen', [source, target])['pid']
                    case.terminate(target, actual_pid)
                    (case.root / 'killed-target.json').write_text(json.dumps({'pid': actual_pid, 'stage': 'partial-frame-received'}), encoding='utf-8')
                    case.kill(source, 'source')
                else:
                    case.kill(target, 'target')
                    case.finish(source, 'source')
            case.run('inspect')
            reports.append({'case': name, 'result': 'passed'})
            print(f'DIRECTORY_CRASH_CASE_OK: {name}', flush=True)
            fresh_retry(args, origin, case, reports)
        finally:
            case.cleanup()


def timeout_case(args, origin, reports):
    case = CrashRun(args, origin, args.output / 'source-timeout', stage='source-first-frame', timeout=True)
    try:
        case.run('init')
        source, target = case.pair(allow_apply=False)
        case.kill(source, 'source')
        started = time.monotonic()
        print('DIRECTORY_CRASH_WAIT: настоящий срок Noise/relay — 300 секунд', flush=True)
        case.run('inspect-source')
        case.finish(target, 'target', timeout=330)
        if not (case.root / 'timeout-safe.json').exists():
            raise RuntimeError('Реальный срок не проверен')
        case.run('inspect')
        reports.append({'case': 'source-timeout', 'real_deadline_seconds': 300,
                        'elapsed_after_kill_seconds': round(time.monotonic() - started, 2), 'result': 'passed'})
        print('DIRECTORY_CRASH_CASE_OK: source-timeout', flush=True)
        fresh_retry(args, origin, case, reports)
    finally:
        case.cleanup()


def apply_cases(args, origin, reports):
    points = [('journal-before', False), ('journal-written', False), ('journal-written', True),
              ('settings-written', True), ('origin-written', False), ('origin-written', True),
              ('journal-cleared', False), ('journal-cleared', True)]
    if os.name == 'nt':
        points.append(('encrypted-journal', False))
    for stage, replace in points:
        name = f'{stage}-settings-{int(replace)}'
        case = CrashRun(args, origin, args.output / name, replace=replace, stage=stage)
        try:
            case.run('init')
            source, target = case.pair()
            case.kill(target, 'target')
            case.finish(source, 'source')
            unapplied = stage in ('journal-before', 'encrypted-journal')
            case.run('inspect' if unapplied else 'resume')
            if not unapplied:
                case.run('verify')
            reports.append({'case': name, 'result': 'passed'})
            print(f'DIRECTORY_CRASH_CASE_OK: {name}', flush=True)
            if unapplied:
                fresh_retry(args, origin, case, reports)
        finally:
            case.cleanup()


def main():
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--app', type=Path, required=True)
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if os.environ.get('GITHUB_ACTIONS') != 'true' or not os.environ.get('SPACE_DATABASE_URL'):
        raise RuntimeError('Сценарий разрешён только в GitHub CI с отдельной тестовой БД')
    args.output = args.output.resolve()
    args.output.relative_to(Path(os.environ['RUNNER_TEMP']).resolve())
    args.output.mkdir(parents=True, exist_ok=False)
    http, grpc = free_ports()
    origin = f'http://127.0.0.1:{http}'
    environment = dict(os.environ)
    environment.pop('SPACE_SETUP_CODE', None)
    reports = []
    server = None
    try:
        with (args.output / 'server.log').open('w', encoding='utf-8') as log:
            server = subprocess.Popen([str(args.server.resolve()), '-http', f'127.0.0.1:{http}',
                                       '-grpc', f'127.0.0.1:{grpc}', '-managed'], env=environment,
                                      stdin=subprocess.PIPE, stdout=log, stderr=log)
            try:
                ready(server, origin)
                transfer_cases(args, origin, reports)
                apply_cases(args, origin, reports)
                timeout_case(args, origin, reports)
            finally:
                stop(server)
                server = None
    finally:
        (args.output / 'report.json').write_text(json.dumps(reports, indent=2) + '\n', encoding='utf-8')
        for file in sorted(args.output.rglob('*.log')):
            print(f'\n{file.relative_to(args.output)}\n{file.read_text(encoding="utf-8", errors="replace")}')
    storage = 'Windows DPAPI' if os.name == 'nt' else 'Linux libsecret/GNOME Keyring'
    print(f'DIRECTORY_CRASH_CI_OK: {len(reports)} проверок, {storage}, принудительное завершение и холодный запуск')


if __name__ == '__main__':
    main()
