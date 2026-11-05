"""Повтор UI разрешён только для неизменных исходников нативного стенда."""
import hashlib
import json
import os
from pathlib import Path
import subprocess

assert os.environ.get('GITHUB_ACTIONS') == 'true'


def output(*args):
    return subprocess.check_output(args, text=True, encoding='utf-8').strip()


run = os.environ.get('INSTALLER_RUN', '')
if run:
    assert run.isdigit()
    subprocess.run(['gh', 'run', 'download', run, '-n', 'windows-launch-installer', '-D', 'dist'], check=True)
    build = json.loads(Path('dist/build.json').read_text(encoding='utf-8'))
    subprocess.run(['git', 'fetch', '--no-tags', 'origin', build['source']], check=True)
    changed = output('git', 'diff', '--name-only', build['source'], 'HEAD', '--', 'client', 'native', 'packages', 'packaging')
    assert not changed, 'Исходники приложения изменились, нужна новая сборка: ' + changed
else:
    build = {'source': output('git', 'rev-parse', 'HEAD')}
digest = hashlib.sha256(Path('dist/Space-Setup-windows-x64.exe').read_bytes()).hexdigest()
if run:
    assert digest == build['sha256'], 'Неверная сумма установщика'
else:
    build['sha256'] = digest
    Path('dist/build.json').write_text(json.dumps(build, indent=2), encoding='utf-8')
print(json.dumps(build))
