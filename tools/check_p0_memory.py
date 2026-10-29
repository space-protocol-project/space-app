"""Шесть независимых процессов Flutter/runtime с PostgreSQL в GitHub CI Windows."""
import argparse
import json
import os
from pathlib import Path
import platform
import subprocess
import time

from check_community_interop import free_ports, ready, stop
from p0_windows_memory import memory

HIDDEN = subprocess.CREATE_NO_WINDOW


def run(command, log, env=None):
    subprocess.run([str(x) for x in command], check=True, stdout=log,
                   stderr=log, env=env, creationflags=HIDDEN)


def seed(args, work, url, objects, owner):
    with (work / 'seed.log').open('w', encoding='utf-8') as log:
        run([args.pg / 'psql.exe', url, '-X', '-v', f'objects={objects}',
             '-v', f'owner={owner}', '-f', Path(__file__).with_name('p0_memory_seed.sql')], log)


def measure(args, pg_port, objects, round_number):
    work = args.output / f'{objects}-{round_number}'
    work.mkdir()
    database = f'p0_{objects}_{round_number}'
    http, grpc = free_ports()
    origin = f'http://127.0.0.1:{http}'
    url = f'postgres://p0@127.0.0.1:{pg_port}/{database}?sslmode=disable'
    env = dict(os.environ, SPACE_DATABASE_URL=url, SPACE_P0_MEMORY_CHECK='1',
               SPACE_P0_ORIGIN=origin, SPACE_P0_WORK=str(work))
    env.pop('SPACE_SETUP_CODE', None)
    samples = []
    start = time.monotonic()
    server = client = None
    try:
        with (work / 'runtime.log').open('w', encoding='utf-8') as server_log, \
                (work / 'flutter.log').open('w', encoding='utf-8') as client_log:
            run([args.pg / 'createdb.exe', '-h', '127.0.0.1', '-p', str(pg_port),
                 '-U', 'p0', database], server_log)
            server = subprocess.Popen([str(args.server), '-http', f'127.0.0.1:{http}',
                '-grpc', f'127.0.0.1:{grpc}', '-managed'], env=env, stdin=subprocess.PIPE,
                stdout=server_log, stderr=server_log, creationflags=HIDDEN)
            ready(server, origin)
            client = subprocess.Popen([str(args.client)], cwd=args.client.parent, env=env,
                stdin=subprocess.DEVNULL, stdout=client_log, stderr=client_log, creationflags=HIDDEN)
            seeded = False
            while client.poll() is None:
                if server.poll() is not None:
                    raise RuntimeError('Runtime завершился во время измерения')
                ready_file = work / 'ready.json'
                if not seeded and ready_file.exists():
                    owner = json.loads(ready_file.read_text())['principal']
                    seed(args, work, url, objects, owner)
                    (work / 'seeded').write_text('ready')
                    seeded = True
                phase = (work / 'phase').read_text() if (work / 'phase').exists() else 'startup'
                try:
                    sample = {'seconds': time.monotonic()-start, 'phase': phase,
                              'flutter': memory(client.pid), 'runtime': memory(server.pid)}
                    samples.append(sample)
                except OSError:
                    if client.poll() is None:
                        raise
                if time.monotonic()-start > 300:
                    raise TimeoutError('Превышен бюджет одного прогона')
                time.sleep(.2)
            if client.returncode != 0:
                raise RuntimeError(f'Flutter: код {client.returncode}; см. {work}')
            result = json.loads((work / 'result.json').read_text())
            if not result['success'] or len([s for s in samples if s['phase']=='sampling']) < 100:
                raise RuntimeError('Нет подтверждения экранов или достаточно длинной выборки')
    finally:
        if client is not None and client.poll() is None:
            client.kill()
            client.wait(timeout=15)
        (work / 'memory.json').write_text(json.dumps({
            'objects_per_type': objects, 'round': round_number,
            'client_pid': client.pid if client else None, 'runtime_pid': server.pid if server else None,
            'client_exit_code': client.returncode if client else None, 'samples': samples,
            'scope': 'Windows working set и private bytes отдельных процессов; PostgreSQL не включён.'},
            indent=2, ensure_ascii=False), encoding='utf-8')
        stop(server)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--postgres', type=Path, required=True)
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--client', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.pg = args.postgres.resolve() / 'postgres/bin'
    args.server = args.server.resolve()
    args.client = args.client.resolve()
    args.output = args.output.resolve()
    args.output.mkdir(parents=True)
    data = args.output / 'database'
    port, _ = free_ports()
    with (args.output / 'postgres-control.log').open('w', encoding='utf-8') as log:
        run([args.pg / 'initdb.exe', '-D', data, '-U', 'p0', '-A', 'trust', '--encoding=UTF8', '--no-locale'], log)
        run([args.pg / 'pg_ctl.exe', '-D', data, '-l', args.output / 'postgres.log',
             '-o', f'-h 127.0.0.1 -p {port}', 'start'], log)
        try:
            (args.output / 'platform.json').write_text(json.dumps({'platform': platform.platform(),
                'processor': platform.processor(), 'logical_cpus': os.cpu_count()}), encoding='utf-8')
            for objects in (1000, 10000):
                for round_number in (1, 2, 3):
                    measure(args, port, objects, round_number)
        finally:
            run([args.pg / 'pg_ctl.exe', '-D', data, '-m', 'fast', 'stop'], log)


if __name__ == '__main__':
    main()
