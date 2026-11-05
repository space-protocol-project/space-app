"""Проверка атомарной публикации через хост жизненного цикла, не прямую запись."""
import json
import os
import signal
import subprocess
import sys
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

exe = str(Path(sys.argv[1]).resolve())
checks = 0
for repetition in range(3):
    for phase in ('before', 'partial', 'after'):
        with tempfile.TemporaryDirectory(prefix='lifecycle-crash-') as folder:
            path = str(Path(folder) / 'registry')
            subprocess.run([exe, path, 'setup'], check=True, timeout=15)
            process = subprocess.Popen([exe, path, 'publish', phase], stdin=subprocess.PIPE,
                                       stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            try:
                with ThreadPoolExecutor(max_workers=1) as pool:
                    future = pool.submit(process.stdout.readline)
                    try:
                        assert future.result(timeout=15).strip() == 'checkpoint:' + phase
                    except BaseException:
                        process.kill()
                        raise
                process.kill()
                expected = 1 if os.name == 'nt' else -signal.SIGKILL
                assert process.wait(timeout=15) == expected
                process.communicate(timeout=15)
            finally:
                if process.poll() is None:
                    process.kill()
                    process.wait(timeout=15)
            entry = json.loads(subprocess.check_output([exe, path, 'read'], text=True, timeout=15))
            record = entry['lifecycle']
            published = phase == 'after'
            assert entry['package'] == ('b' if published else 'a') * 64
            assert entry['schema'] == (2 if published else 1)
            assert entry['state'] == ('disabled' if published else 'ready')
            assert json.loads(entry['data']) == ({'step': 1} if published else {})
            assert record['history'] == (['2' * 32] if published else [])
            assert record['data_revision'] == (1 if published else 0)
            assert any(e['action'] == 'publish' for e in record['audit']) == published
            assert record['audit'][-1]['action'] == 'reopen'
            if not published:
                assert entry['staged']['cursor'] == 1
                assert json.loads(entry['staged']['data']) == {'step': 1}
            again = json.loads(subprocess.check_output([exe, path, 'read'], text=True, timeout=15))
            assert again['lifecycle']['generation'] != record['generation']
            assert again['lifecycle']['history'] == record['history']
            checks += 1
print(json.dumps({'lifecycle_process_crash_checks': checks, 'result': 'success'}))
