"""CI-стенд с настоящей базой и отдельным worker на Linux/Windows."""
import os
from pathlib import Path
import subprocess
import sys
import time

from contributions_postgres import database


def isolation_root(out):
    if os.name == 'nt':
        root = out / 'worker-root'
        root.mkdir()
        return str(root)
    root = '/sys/fs/cgroup/space-p1-contributions-client'
    subprocess.run(['sudo', 'mkdir', root], check=True)
    subprocess.run(['sudo', 'sh', '-c', f'echo "+memory +pids +cpu" > {root}/cgroup.subtree_control'], check=True)
    return root


def fixture_command(private, root, url):
    windows = os.name == 'nt'
    directory = Path('.local/p1-native-bin').resolve() if windows else Path('/tmp')
    suffix = '.exe' if windows else ''
    environment = dict(os.environ, SPACE_TEST_DATABASE_URL=url,
                       SPACE_P1_CONTRIBUTIONS_CLIENT=str(private), SPACE_P1_CGROUP=root,
                       SPACE_P1_WORKER=str(directory / ('space-contributions-worker' + suffix)))
    command = [str(directory / ('space-contributions-fixture' + suffix)),
               '-test.run=^TestContributionsNativeClientFixture$', '-test.v', '-test.timeout=28m']
    if not windows:
        variables = [f'{key}={value}' for key, value in environment.items()
                     if key.startswith('SPACE_')]
        command = ['sudo', 'env', *variables, *command]
    return command, environment


def wait_ready(process, private):
    deadline = time.monotonic() + 45
    while not (private / 'connection.json').exists():
        if process.poll() is not None or time.monotonic() > deadline:
            raise RuntimeError('Стенд не запущен')
        time.sleep(.1)


def cleanup(private, root):
    names = ('connection.json', 'connection.tmp', 'completed')
    if os.name == 'nt':
        for name in names:
            (private / name).unlink(missing_ok=True)
        Path(root).rmdir()
    else:
        subprocess.run(['sudo', 'rm', '-f', *(str(private / name) for name in names)], check=True)
        subprocess.run(['sudo', 'rmdir', root], check=True)


def run_native(out, private, url):
    root = isolation_root(out)
    command, environment = fixture_command(private, root, url)
    with (out / 'server.log').open('w', encoding='utf-8') as log:
        process = subprocess.Popen(command, env=environment, stdout=log, stderr=log)
        try:
            wait_ready(process, private)
            native = [sys.executable, 'tools/check_contributions_ui.py']
            subprocess.run(native if os.name == 'nt' else ['xvfb-run', '-a', *native], check=True)
        finally:
            stop = private / 'next-control'
            stop.write_text('stop', encoding='ascii')
            stop.replace(private / 'control')
            try:
                result = process.wait(timeout=30)
            finally:
                cleanup(private, root)
            if result != 0:
                raise RuntimeError('Серверный стенд завершился с ошибкой')


def main():
    out = Path('.local/p1-contributions-client').resolve()
    private = out / 'private'
    private.mkdir(parents=True, mode=0o700)
    with database(out, private) as url:
        run_native(out, private, url)


if __name__ == '__main__':
    main()
