"""Повтор UI разрешён только для неизменных исходников нативного стенда."""
import hashlib
import json
import os
import re
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
    assert re.fullmatch('[0-9a-f]{40}', build['source'])
    subprocess.run(['git', 'fetch', '--no-tags', 'origin', build['source']], check=True)
    changed = output('git', 'diff', '--name-only', build['source'], 'HEAD', '--', 'client', 'native', 'packages', 'packaging')
    assert not changed, 'Исходники приложения изменились, нужна новая сборка: ' + changed
    validation = str(build.get('validation_run', run))
    assert validation.isdigit()
    previous = json.loads(output('gh', 'run', 'view', validation, '--json', 'headSha,jobs'))
    assert previous['headSha'] == build['source']
    assert any(step['name'] == 'Анализ и регрессионные тесты до сборки' and step['conclusion'] == 'success'
               for job in previous['jobs'] for step in job['steps'])
    subprocess.run(['gh', 'run', 'download', validation, '-n', 'windows-launch', '-D', '.local/launch-validation'], check=True)
    Path('launch-tests.txt').write_bytes(Path('.local/launch-validation/launch-tests.txt').read_bytes())
    build['validation_run'] = validation
else:
    build = {'source': output('git', 'rev-parse', 'HEAD'), 'validation_run': os.environ['GITHUB_RUN_ID']}
digest = hashlib.sha256(Path('dist/Space-Setup-windows-x64.exe').read_bytes()).hexdigest()
if run:
    assert digest == build['sha256'], 'Неверная сумма установщика'
else:
    build['sha256'] = digest
Path('dist/build.json').write_text(json.dumps(build, indent=2), encoding='utf-8')
print(json.dumps(build))
