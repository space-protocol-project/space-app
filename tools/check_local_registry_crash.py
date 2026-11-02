"""Настоящее завершение Dart-процесса на границах записи журнала."""
import json
import subprocess
import sys
import tempfile
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

exe = str(Path(sys.argv[1]).resolve())


def read(path):
    return json.loads(subprocess.check_output([exe, str(path), 'read'], text=True, timeout=15))


def write(path, entries, phase):
    fixture = path.with_suffix('.json')
    fixture.write_text(json.dumps(entries), encoding='utf-8')
    return subprocess.Popen([exe, str(path), 'write', str(fixture), phase], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


def entry(package, schema, data, state='disabled', staged=None):
    return dict(installation='games', package=package*64, schema=schema, data=json.dumps(data), state=state, staged=staged)


checks = 0
for repetition in range(3):
    for phase in ('before', 'partial', 'after'):
        with tempfile.TemporaryDirectory(prefix='registry-crash-') as directory:
            path = Path(directory)/'registry'
            initial = read(path)
            old = {'games':entry('a',1,{'value':1}), 'other':entry('a',1,{})}
            process = write(path, old, 'none')
            stdout, stderr = process.communicate(timeout=15)
            assert process.returncode == 0, stderr
            before = read(path)
            new = {'games':entry('b',2,{'value':2}), 'other':entry('b',2,{'added':True})}
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
                process.communicate(timeout=15)
            finally:
                if process.poll() is None: process.kill(); process.wait(timeout=15)
            after = read(path)
            assert after['entries'] == (new if phase=='after' else old), (phase,after)
            assert after['generation'] != before['generation'] != initial['generation']
            assert read(path)['entries'] == after['entries']
            checks += 1
print(json.dumps({'process_crash_checks':checks,'result':'success'}))
