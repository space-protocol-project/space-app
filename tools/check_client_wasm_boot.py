"""CI: зависимость systemd не открывает сокет до восстановления журнала."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

from check_client_wasm_protocol import control, install
from check_client_wasm_update import (STATE, SERVICE, SOURCE, INSTALLED, SOCKET,
                                      candidate, root, snapshot, usable, wait_for)

RECOVERY = 'space-client-wasm-recovery.service'
BLOCKED = Path('/run/space-client-wasm-recovery-blocked')


def stop_for_boot():
    control('stop', 'space-client-wasm.socket', 'space-client-wasm.service')
    control('stop', RECOVERY)
    control('reset-failed')
    root('rm', '-f', BLOCKED)


def interrupted(binary):
    service = (SOURCE / SERVICE.name).read_text().replace(
        '[Service]', '[Service]\nExecStartPre=/usr/bin/sleep 20')
    with tempfile.TemporaryDirectory() as folder:
        directory = Path(folder)
        args = candidate(directory, binary, service)
        marker = directory / 'installer.pid'
        command = ['sudo', 'bash', '-c', 'echo $$ > "$1"; exec bash "$2" "$3"',
                   'boot-test', str(marker), args[2], args[3]]
        with subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as process:
            wait_for(lambda: marker.exists() and marker.read_text().strip().isdigit())
            wait_for(lambda: SERVICE.read_text() == service and
                     subprocess.check_output(['systemctl', 'show', 'space-client-wasm.service',
                                              '-p', 'ActiveState', '--value'], text=True).strip() == 'activating')
            root('kill', '-KILL', marker.read_text().strip())
            process.communicate(timeout=30)
            assert process.returncode != 0
    root('test', '-d', STATE / 'pending')


def activate(expect_success):
    result = subprocess.run(['sudo', 'systemctl', 'start', 'space-client-wasm.socket'],
                            capture_output=True, text=True, timeout=60)
    assert (result.returncode == 0) == expect_success, result.stderr
    if not expect_success:
        assert not Path('/run/space-client-wasm/control.sock').exists()


def enabled_recovery(binary):
    before = snapshot()
    interrupted(binary)
    stop_for_boot()
    activate(True)
    assert snapshot() == before
    usable()
    assert root('systemctl', 'is-active', RECOVERY) == 'active'
    # Идемпотентный следующий запуск systemd без журнала.
    stop_for_boot()
    activate(True)
    assert snapshot() == before
    usable()
    return {'case': 'enabled_sigkill', 'automatic_dependency': True, 'repeat_passed': True}


def disabled_recovery(binary):
    control('disable', '--now', 'space-client-wasm.socket')
    control('stop', 'space-client-wasm.service')
    before = snapshot()
    interrupted(binary)
    stop_for_boot()
    activate(False)
    assert snapshot() == before and BLOCKED.exists()
    root('test', '!', '-d', STATE / 'pending')
    assert subprocess.run(['systemctl', 'is-enabled', '--quiet', 'space-client-wasm.socket']).returncode != 0
    installed = install(binary)
    assert installed.returncode == 0, installed.stderr
    usable()
    return {'case': 'disabled_sigkill', 'queued_socket_blocked': True}


def corrupt_recovery(binary, kind):
    interrupted(binary)
    corrupted = STATE / 'pending' / ('format' if kind == 'format' else 'old/space-client-wasm')
    root('cp', corrupted, STATE / 'repair-copy')
    root('truncate', '-s', '0', corrupted)
    before = snapshot()
    stop_for_boot()
    activate(False)
    assert snapshot() == before and BLOCKED.exists()
    root('test', '-d', STATE / 'pending')
    root('mv', STATE / 'repair-copy', corrupted)
    control('reset-failed', RECOVERY, 'space-client-wasm.socket', 'space-client-wasm.service')
    activate(True)
    usable()
    return {'case': 'corrupt_' + kind, 'closed_before_writes': True, 'retry_passed': True}


def committed_recovery():
    before = snapshot()
    root('mv', STATE / 'previous', STATE / 'committed')
    stop_for_boot()
    activate(True)
    assert snapshot() == before
    root('test', '-d', STATE / 'previous')
    root('test', '!', '-d', STATE / 'committed')
    usable()
    return {'case': 'committed', 'not_rolled_back': True}


def first_install_recovery(binary):
    control('disable', '--now', 'space-client-wasm.socket')
    control('stop', 'space-client-wasm.service')
    root('rm', '-f', INSTALLED, SERVICE, SOCKET)
    control('daemon-reload')
    interrupted(binary)
    stop_for_boot()
    activate(False)
    assert all(not path.exists() for path in (INSTALLED, SERVICE, SOCKET))
    root('test', '!', '-d', STATE / 'pending')
    installed = install(binary)
    assert installed.returncode == 0, installed.stderr
    usable()
    return {'case': 'first_install_sigkill', 'partial_install_removed': True}


def main():
    assert os.environ.get('GITHUB_ACTIONS') == 'true' and os.geteuid() != 0
    binary = Path(os.environ['SPACE_CLIENT_WASM_BINARY'])
    cases = [enabled_recovery(binary), disabled_recovery(binary),
             corrupt_recovery(binary, 'snapshot'), corrupt_recovery(binary, 'format'),
             committed_recovery(), first_install_recovery(binary)]
    journal = root('journalctl', '-u', RECOVERY, '--no-pager', '-o', 'cat')
    Path('client-wasm-linux-boot.log').write_text(journal + '\n')
    result = {'passed': True, 'cases': cases, 'mode': 'systemd dependency restart',
              'recovery_enabled': root('systemctl', 'is-enabled', RECOVERY) == 'enabled'}
    Path('client-wasm-linux-boot.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result))


if __name__ == '__main__':
    main()
