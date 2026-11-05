"""Настоящее завершение Dart-процесса на границах записи журнала."""
import json
import os
import signal
import subprocess
import sys
import tempfile
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
from itertools import product

exe = str(Path(sys.argv[1]).resolve())


def read(path):
    return json.loads(subprocess.check_output([exe, str(path), 'read'], text=True, timeout=15))


def write(path, entries, phase):
    fixture = path.with_suffix('.json')
    fixture.write_text(json.dumps(entries), encoding='utf-8')
    return subprocess.Popen([exe, str(path), 'write', str(fixture), phase], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


def entry(package, schema, data, state='disabled', staged=None):
    return dict(installation='games', package=package*64, schema=schema, data=json.dumps(data), state=state, staged=staged)


def snapshots(kind):
    old = {'games':entry('a',1,{'value':1}), 'other':entry('a',1,{})}
    prepared = {key: dict(value, state='updating', staged=dict(package='b'*64, schema=2, data=json.dumps({'step':0}), cursor=0)) for key,value in old.items()}
    advanced = {key: dict(value, state='ready', staged=dict(value['staged'], data=json.dumps({'step':1}), cursor=1)) for key,value in prepared.items()}
    published = {key: entry('b',2,{'step':1}) for key in old}
    return {'prepare':(old,prepared), 'advance':(prepared,advanced), 'publish':(advanced,published)}[kind]


checks = 0
for repetition, kind in product(range(3), ('prepare', 'advance', 'publish')):
    for phase in ('before', 'partial', 'after'):
        with tempfile.TemporaryDirectory(prefix='registry-crash-') as directory:
            path = Path(directory)/'registry'
            initial = read(path)
            old, new = snapshots(kind)
            process = write(path, old, 'none')
            stdout, stderr = process.communicate(timeout=15)
            assert process.returncode == 0, stderr
            before = read(path)
            process = write(path, new, phase)
            try:
                with ThreadPoolExecutor(max_workers=1) as pool:
                    future = pool.submit(process.stdout.readline)
                    try:
                        assert future.result(timeout=15).strip() == 'checkpoint:'+phase
                    except BaseException:
                        process.kill()
                        raise
                # Второй процесс не получает доступ, пока первый удерживает lock.
                contender = subprocess.run([exe,str(path),'read'],capture_output=True,timeout=15)
                assert contender.returncode != 0
                process.kill()
                expected = 1 if os.name == 'nt' else -signal.SIGKILL
                assert process.wait(timeout=15) == expected
                process.communicate(timeout=15)
            finally:
                if process.poll() is None: process.kill(); process.wait(timeout=15)
            after = read(path)
            assert after['entries'] == (new if phase=='after' else old), (phase,after)
            assert after['generation'] != before['generation'] != initial['generation']
            assert read(path)['entries'] == after['entries']
            checks += 1
print(json.dumps({'process_crash_checks':checks,'result':'success'}))
