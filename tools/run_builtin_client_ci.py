"""Проверка Flutter/Cubit с настоящими сессиями PostgreSQL через Connect."""
import json
import os
from pathlib import Path
import subprocess
import time


def main():
    out = Path('.local/p2-client').resolve()
    private = out / 'private'
    private.mkdir(parents=True, exist_ok=True)
    environment = dict(os.environ, SPACE_P2_CLIENT=str(private))
    with (out / 'server.log').open('w', encoding='utf-8') as log:
        server = subprocess.Popen([
            str(Path('.local/p2-server-fixture').resolve()),
            '-test.run=^TestBuiltinClientFixture$', '-test.v', '-test.timeout=12m',
        ], env=environment, stdout=log, stderr=subprocess.STDOUT)
        try:
            deadline = time.monotonic() + 45
            while not (private / 'connection.json').exists():
                if server.poll() is not None or time.monotonic() > deadline:
                    raise RuntimeError('Стенд не запущен')
                time.sleep(.1)
            with (out / 'client.jsonl').open('w', encoding='utf-8') as output:
                subprocess.run([
                    'flutter', 'test', '--no-pub', '--reporter=json',
                    'test/builtin_client_ci_test.dart',
                ], cwd='client', env=environment, stdout=output,
                    stderr=subprocess.STDOUT, check=True, timeout=240)
            server.wait(timeout=20)
            if server.returncode != 0:
                raise RuntimeError('Ошибка проверки серверной записи')
            rows = [json.loads(line) for line in (out / 'client.jsonl').read_text().splitlines()
                    if line.startswith('{')]
            tests = [r for r in rows if r.get('type') == 'testDone' and not r.get('hidden')]
            assert tests and all(not r['skipped'] and r['result'] == 'success' for r in tests)
            (out / 'result.json').write_text(json.dumps({'success': True, 'tests': tests}, indent=2))
        finally:
            if server.poll() is None:
                server.terminate()
                server.wait(timeout=10)


if __name__ == '__main__':
    main()
