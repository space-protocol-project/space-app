"""Отдельный Secret Service с зашифрованным профилем для одного процесса CI."""
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time


def wait_service(daemon):
    deadline = time.monotonic() + 20
    while daemon.poll() is None and time.monotonic() < deadline:
        result = subprocess.run([
            'gdbus', 'call', '--session', '--dest', 'org.freedesktop.DBus',
            '--object-path', '/org/freedesktop/DBus', '--method',
            'org.freedesktop.DBus.NameHasOwner', 'org.freedesktop.secrets',
        ], capture_output=True, text=True, timeout=3)
        if result.returncode == 0 and result.stdout.strip() == '(true,)':
            return
        time.sleep(.05)
    raise RuntimeError('GNOME Keyring не занял имя Secret Service')


def main():
    if os.environ.get('GITHUB_ACTIONS') != 'true' or sys.platform != 'linux':
        raise RuntimeError('Стенд разрешён только в Linux GitHub CI')
    profile = Path(os.environ['DIRECTORY_CRASH_PROFILE']).resolve()
    profile.relative_to(Path(os.environ['RUNNER_TEMP']).resolve())
    runtime = profile / 'runtime'
    runtime.mkdir(mode=0o700, exist_ok=True)
    os.chmod(runtime, 0o700)
    os.environ['XDG_RUNTIME_DIR'] = str(runtime)
    os.environ['SECRET_BACKEND'] = 'service'
    # Только синтетические данные CI. Непустой пароль включает шифрование keyring.
    daemon = subprocess.Popen([
        'gnome-keyring-daemon', '--foreground', '--unlock', '--components=secrets',
        '--control-directory', str(runtime / 'keyring'),
    ], stdin=subprocess.PIPE)
    try:
        daemon.stdin.write(b'space-ci-keyring-only\n')
        daemon.stdin.close()
        wait_service(daemon)
        control = Path(os.environ['DIRECTORY_CRASH_CONTROL'])
        role = os.environ['DIRECTORY_CRASH_ROLE']
        (control / f'keyring-session-{role}.json').write_text(json.dumps({
            'daemon_pid': daemon.pid, 'session_pid': os.getpid(),
            'backend': 'GNOME Keyring', 'fresh_service': True,
        }), encoding='utf-8')
        result = subprocess.run([sys.argv[1]])
        return result.returncode
    finally:
        if daemon.poll() is None:
            daemon.send_signal(signal.SIGTERM)
            try:
                daemon.wait(timeout=5)
            except subprocess.TimeoutExpired:
                daemon.kill()
                daemon.wait(timeout=5)


if __name__ == '__main__':
    sys.exit(main())
