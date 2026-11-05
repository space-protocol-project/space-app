"""CI: обновление реальной systemd-службы, ошибки, откат и SIGKILL установщика."""
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import tempfile
import time

from check_client_wasm_linux import call, request
from check_client_wasm_protocol import control, install

STATE = Path('/var/lib/space-client-wasm-updater')
INSTALLED = Path('/usr/libexec/space-client-wasm/space-client-wasm')
SERVICE = Path('/etc/systemd/system/space-client-wasm.service')
SOCKET = SERVICE.with_suffix('.socket')
SOURCE = Path('packaging/linux-wasm')


def root(*args):
    return subprocess.run(['sudo', *map(str, args)], check=True, capture_output=True,
                          text=True, timeout=60).stdout.strip()


def snapshot():
    return {str(p): hashlib.sha256(p.read_bytes()).hexdigest()
            for p in (INSTALLED, SERVICE, SOCKET)}


def usable():
    assert json.loads(call(request('catalog')))['result']
    assert root('test', '!', '-d', STATE / 'pending') == ''


def candidate(directory, binary, service=None, broken=False):
    for path in SOURCE.iterdir():
        if path.is_file():
            (directory / path.name).write_bytes(path.read_bytes())
    target = directory / 'space-client-wasm'
    target.write_bytes(b'invalid executable' if broken else binary.read_bytes())
    target.with_suffix('.sha256').write_text(hashlib.sha256(target.read_bytes()).hexdigest())
    if service:
        (directory / SERVICE.name).write_text(service)
    return ['sudo', 'bash', str(directory / 'install-system-service.sh'), str(target)]


def failed_update(binary, kind, service=None, broken=False):
    before = snapshot()
    with tempfile.TemporaryDirectory() as folder:
        args = candidate(Path(folder), binary, service, broken)
        result = subprocess.run(args, capture_output=True, text=True, timeout=60)
        assert result.returncode != 0, kind
        assert 'Restoring previous WASM service' in result.stderr, result.stderr
    assert snapshot() == before, kind
    usable()
    return {'case': kind, 'files_restored': True, 'wasm_after_rollback': True}


def wait_for(predicate):
    deadline = time.monotonic() + 15
    while not predicate():
        assert time.monotonic() < deadline, 'installer checkpoint timeout'
        time.sleep(.05)


def interrupted_update(binary, service, sig):
    before = snapshot()
    with tempfile.TemporaryDirectory() as folder:
        directory = Path(folder)
        args = candidate(directory, binary, service)
        marker = directory / 'installer.pid'
        # Сохраняем PID именно root bash; ни один путь не интерполируется в код shell.
        command = ['sudo', 'bash', '-c', 'echo $$ > "$1"; exec bash "$2" "$3"',
                   'update-test', str(marker), args[2], args[3]]
        with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as process:
            wait_for(lambda: marker.exists() and marker.read_text().strip().isdigit())
            pid = int(marker.read_text())
            wait_for(lambda: SERVICE.read_text() == service and
                     subprocess.check_output(['systemctl', 'show', 'space-client-wasm.service',
                                              '-p', 'ActiveState', '--value'], text=True).strip() == 'activating')
            # Второй установщик не может менять файлы незавершённой транзакции.
            concurrent = install(binary)
            assert concurrent.returncode != 0
            assert SERVICE.read_text() == service
            root('kill', f'-{sig}', str(pid))
            process.communicate(timeout=30)
            assert process.returncode != 0
        if sig == signal.SIGKILL:
            root('test', '-d', STATE / 'pending')
            # Восстановление выполняется даже перед отклонением следующего плохого пакета.
            invalid = directory / 'invalid'
            invalid.write_bytes(b'invalid')
            invalid.with_suffix('.sha256').write_text('0' * 64)
            recovered = install(invalid)
            assert recovered.returncode != 0
            assert 'Restoring previous WASM service' in recovered.stderr
    assert snapshot() == before
    usable()
    return {'case': sig.name, 'concurrent_rejected': True, 'files_restored': True,
            'recovered_on_next_invocation': sig == signal.SIGKILL}


def failed_first_install(binary):
    control('disable', '--now', 'space-client-wasm.socket')
    control('stop', 'space-client-wasm.service')
    root('rm', '-f', INSTALLED, SERVICE, SOCKET)
    control('daemon-reload')
    with tempfile.TemporaryDirectory() as folder:
        result = subprocess.run(candidate(Path(folder), binary, broken=True),
                                capture_output=True, text=True, timeout=60)
        assert result.returncode != 0 and 'Restoring previous' in result.stderr
    assert all(not p.exists() for p in (INSTALLED, SERVICE, SOCKET))
    root('test', '!', '-d', STATE / 'pending')
    assert subprocess.run(['systemctl', 'is-active', '--quiet', 'space-client-wasm.socket']).returncode != 0
    restored = install(binary)
    assert restored.returncode == 0, restored.stderr
    usable()
    return {'case': 'first_install_failure', 'no_partial_installation': True}


def successful_update(binary):
    before = snapshot()
    with tempfile.TemporaryDirectory() as folder:
        directory = Path(folder)
        args = candidate(directory, binary)
        target = directory / 'space-client-wasm'
        # ELF допускает хвост: другой хеш поставки, та же проверенная реализация.
        target.write_bytes(target.read_bytes() + b'P1 update fixture\n')
        digest = hashlib.sha256(target.read_bytes()).hexdigest()
        target.with_suffix('.sha256').write_text(digest)
        result = subprocess.run(args, capture_output=True, text=True, timeout=60)
        assert result.returncode == 0, result.stderr
        assert hashlib.sha256(INSTALLED.read_bytes()).hexdigest() == digest
    assert snapshot()[str(INSTALLED)] != before[str(INSTALLED)]
    saved = root('sha256sum', STATE / 'previous/old/space-client-wasm').split()[0]
    assert saved == before[str(INSTALLED)]
    usable()
    restored = install(binary)
    assert restored.returncode == 0, restored.stderr
    return {'case': 'successful_update', 'changed_package_hash': True, 'previous_bytes_retained': True}


def disabled_rollback(binary):
    control('disable', '--now', 'space-client-wasm.socket')
    control('stop', 'space-client-wasm.service')
    before = snapshot()
    with tempfile.TemporaryDirectory() as folder:
        result = subprocess.run(candidate(Path(folder), binary, broken=True),
                                capture_output=True, text=True, timeout=60)
        assert result.returncode != 0 and 'Restoring previous' in result.stderr
    assert snapshot() == before
    for action in ('is-enabled', 'is-active'):
        assert subprocess.run(['systemctl', action, '--quiet', 'space-client-wasm.socket']).returncode != 0
    control('enable', '--now', 'space-client-wasm.socket')
    usable()
    return {'case': 'disabled_rollback', 'disabled_inactive_preserved': True}


def main():
    assert os.environ.get('GITHUB_ACTIONS') == 'true' and os.geteuid() != 0
    binary = Path(os.environ['SPACE_CLIENT_WASM_BINARY'])
    service = (SOURCE / SERVICE.name).read_text()
    cases = [successful_update(binary), failed_update(binary, 'invalid_executable', broken=True)]
    cases.append(failed_update(binary, 'service_start_failure',
                              service.replace(' --linux-broker', ' --invalid-argument')))
    cases.append(failed_update(binary, 'worker_isolation_failure',
                              service.replace('AmbientCapabilities=CAP_SETUID', 'AmbientCapabilities=')))
    delayed = service.replace('[Service]', '[Service]\nExecStartPre=/usr/bin/sleep 20')
    cases.append(failed_update(binary, 'health_timeout', delayed))
    for sig in (signal.SIGTERM, signal.SIGKILL):
        cases.append(interrupted_update(binary, delayed, sig))
    cases.append(failed_first_install(binary))
    cases.append(disabled_rollback(binary))
    assert root('stat', '-c', '%u:%a', STATE) == '0:700'
    assert root('stat', '-c', '%u:%a', INSTALLED) == '0:755'
    root('test', '-d', STATE / 'previous')
    result = {'passed': True, 'client_uid': os.geteuid(), 'cases': cases,
              'healthy_install': True, 'private_journal': True, 'previous_snapshot_retained': True}
    Path('client-wasm-linux-update.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result))


if __name__ == '__main__':
    main()
