"""Запускает только CI-стенд в отдельной тестовой базе и удаляет его секреты."""
import os
from pathlib import Path
import subprocess
import sys
import time

out = Path('.local/p1-contributions-client').resolve()
private = out / 'private'
private.mkdir(parents=True, exist_ok=True, mode=0o700)
root = '/sys/fs/cgroup/space-p1-contributions-client'
subprocess.run(['sudo', 'mkdir', root], check=True)
subprocess.run(['sudo', 'sh', '-c', f'echo "+memory +pids +cpu" > {root}/cgroup.subtree_control'], check=True)
command = ['sudo', 'env', f'SPACE_TEST_DATABASE_URL={os.environ["SPACE_TEST_DATABASE_URL"]}',
           f'SPACE_P1_CONTRIBUTIONS_CLIENT={private}', f'SPACE_P1_CGROUP={root}',
           'SPACE_P1_WORKER=/tmp/space-contributions-worker', '/tmp/space-contributions-fixture',
           '-test.run=^TestContributionsNativeClientFixture$', '-test.v', '-test.timeout=28m']
with (out / 'server.log').open('w') as log:
    process = subprocess.Popen(command, stdout=log, stderr=log)
    try:
        deadline = time.monotonic() + 30
        while not (private / 'connection.json').exists():
            if process.poll() is not None or time.monotonic() > deadline:
                raise RuntimeError('Стенд не запущен')
            time.sleep(.1)
        subprocess.run(['xvfb-run', '-a', sys.executable, 'tools/check_contributions_ui.py'], check=True)
    finally:
        stop = private / 'next-control'
        stop.write_text('stop')
        stop.replace(private / 'control')
        try:
            result = process.wait(timeout=30)
        finally:
            # Каталог принадлежит этому стенду и содержит только временные учётные данные.
            subprocess.run(['sudo', 'rm', '-f', str(private / 'connection.json'), str(private / 'completed')], check=True)
            subprocess.run(['sudo', 'rmdir', root], check=True)
        if result != 0:
            raise RuntimeError('Серверный стенд завершился с ошибкой')
