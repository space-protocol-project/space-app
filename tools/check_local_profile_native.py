"""Настоящие системные хранилища и независимые Flutter-процессы, только GitHub CI."""
from contextlib import nullcontext
import hashlib
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

from check_directory_macos import isolated_keychain


def run_role(binary, root, role, environment, kill=False):
    marker = root / f'done-{role}'
    marker.unlink(missing_ok=True)
    env = dict(environment, DIRECTORY_CRASH_ROLE=role)
    command = [str(binary)]
    if sys.platform == 'linux':
        command = ['dbus-run-session', '--', sys.executable,
                   str(Path(__file__).with_name('directory_keyring_session.py')), str(binary)]
    with (root / f'{role}.log').open('w', encoding='utf-8') as log:
        process = subprocess.Popen(command, env=env, stdout=log, stderr=log)
        try:
            deadline = time.monotonic() + 120
            while not marker.exists():
                if process.poll() is not None or time.monotonic() > deadline:
                    raise RuntimeError(f'Не завершён сценарий {role}')
                time.sleep(.1)
            child_pid = int(marker.read_text())
            if kill:
                if os.name == 'nt':
                    subprocess.run(['taskkill', '/F', '/PID', str(child_pid)], check=True,
                                   stdout=subprocess.DEVNULL)
                else:
                    os.kill(child_pid, signal.SIGKILL)
            code = process.wait(timeout=20)
            if not kill and code != 0:
                raise RuntimeError(f'Ошибка завершения {role}')
            result = root / f'result-{role}.json'
            return json.loads(result.read_text()) if result.exists() else {'role': role, 'pid': child_pid}
        finally:
            if process.poll() is None:
                process.kill()
                process.wait(timeout=10)


def main():
    if os.environ.get('GITHUB_ACTIONS') != 'true':
        raise RuntimeError('Только GitHub CI')
    binary = Path(sys.argv[1]).resolve(strict=True)
    root = Path(os.environ['RUNNER_TEMP']).resolve() / 'local-profile-native'
    root.mkdir(mode=0o700, exist_ok=False)
    profile = root / 'profile'
    profile.mkdir(mode=0o700)
    env = dict(os.environ, DIRECTORY_CRASH_PROFILE=str(profile),
               DIRECTORY_CRASH_CONTROL=str(root),
               DIRECTORY_CRASH_NAMESPACE='space-ci-' + hashlib.sha256(str(root).encode()).hexdigest(),
               XDG_DATA_HOME=str(profile / 'data'), XDG_CONFIG_HOME=str(profile / 'config'),
               XDG_CACHE_HOME=str(profile / 'cache'), LIBGL_ALWAYS_SOFTWARE='1')
    context = isolated_keychain(root) if sys.platform == 'darwin' else nullcontext()
    results = []
    with context as keychain:
        if keychain:
            env['DIRECTORY_CRASH_KEYCHAIN'] = str(keychain)
        try:
            results.append(run_role(binary, root, 'create', env, kill=True))
            results.append(run_role(binary, root, 'login', env))
            for count in range(1, 6):
                result = run_role(binary, root, 'wrong', env, kill=True)
                assert result['failures'] == count
                results.append(result)
            blocked = run_role(binary, root, 'blocked', env)
            assert blocked['failures'] == 5 and not blocked['unlocked']
            results.append(blocked)
            time.sleep(31)
            recovered = run_role(binary, root, 'login', env)
            assert recovered['failures'] == 0 and recovered['unlocked']
            results.append(recovered)
            assert len({r['identity_digest'] for r in results}) == 1
            results.append(run_role(binary, root, 'corrupt', env))
        finally:
            results.append(run_role(binary, root, 'cleanup', env))
    assert len({r['pid'] for r in results}) == len(results)
    (root / 'report.json').write_text(json.dumps({
        'result': 'success', 'platform': sys.platform, 'independent_processes': len(results),
        'forced_terminations': 6, 'checks': results,
        'backend': {'win32': 'Windows DPAPI', 'linux': 'GNOME Keyring',
                    'darwin': 'macOS login Keychain'}[sys.platform],
    }, indent=2), encoding='utf-8')
    print('PROFILE_NATIVE_CI_OK')


if __name__ == '__main__':
    main()
