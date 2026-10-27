"""Настоящий Dart/Connect-клиент и перезапуск изолированного сервера в CI."""
import argparse
import os
from pathlib import Path
import socket
import subprocess
import time
import urllib.request


def free_ports():
    with socket.socket() as http, socket.socket() as grpc:
        http.bind(('127.0.0.1', 0))
        grpc.bind(('127.0.0.1', 0))
        return http.getsockname()[1], grpc.getsockname()[1]


def ready(server, origin):
    for _ in range(100):
        if server.poll() is not None:
            raise RuntimeError('Сервер завершился до проверки готовности')
        try:
            with urllib.request.urlopen(origin + '/healthz', timeout=1):
                return
        except OSError:
            time.sleep(.2)
    raise TimeoutError('Сервер не запустился')


def stop(server):
    if server is None:
        return
    if server.stdin and not server.stdin.closed:
        server.stdin.close()
    try:
        code = server.wait(timeout=25)
    except subprocess.TimeoutExpired:
        server.kill()
        server.wait(timeout=10)
        raise TimeoutError('Сервер превысил время штатной остановки')
    if code:
        raise RuntimeError(f'Сервер завершился с кодом {code}')


def probe(args, log):
    http, grpc = free_ports()
    origin = f'http://127.0.0.1:{http}'
    marker = args.output / 'restart'
    environment = dict(os.environ)
    environment.pop('SPACE_SETUP_CODE', None)
    command = [str(args.server.resolve()), '-http', origin.removeprefix('http://'),
               '-grpc', f'127.0.0.1:{grpc}', '-managed']

    def start():
        instance = subprocess.Popen(command, env=environment, stdin=subprocess.PIPE,
                                    stdout=log, stderr=log)
        try:
            ready(instance, origin)
        except Exception:
            stop(instance)
            raise
        return instance

    server = client = None
    try:
        server = start()
        client = subprocess.Popen(
            ['dart', 'run', f'tool/community_{args.scenario}_interoperability.dart', origin, str(marker)],
            cwd=args.client, env=environment, stdin=subprocess.DEVNULL, stdout=log, stderr=log)
        deadline = time.monotonic() + 600
        while not marker.with_suffix('.ready').exists():
            if client.poll() is not None:
                raise RuntimeError('Клиент завершился до проверки перезапуска')
            if time.monotonic() > deadline:
                raise TimeoutError('Клиент не дошёл до проверки перезапуска')
            time.sleep(.2)
        stop(server)
        server = None
        server = start()
        marker.with_suffix('.resume').write_text('resume', encoding='utf-8')
        if client.wait(timeout=120):
            raise RuntimeError('Сквозная проверка не пройдена')
    finally:
        if client is not None and client.poll() is None:
            client.terminate()
            client.wait(timeout=15)
        stop(server)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--client', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--scenario', choices=['reactions', 'favorites', 'space_search', 'feed_social', 'participant_follows', 'user_export', 'pairing_modes'], required=True)
    args = parser.parse_args()
    if not os.environ.get('SPACE_DATABASE_URL'):
        raise ValueError('Нужна отдельная тестовая SPACE_DATABASE_URL')
    args.output = args.output.resolve()
    args.output.mkdir(parents=True, exist_ok=False)
    log_path = args.output / 'interop.log'
    try:
        with log_path.open('w', encoding='utf-8') as log:
            probe(args, log)
    finally:
        print(log_path.read_text(encoding='utf-8', errors='replace'))
    print(f'COMMUNITY_{args.scenario.upper()}_CI_OK: штатная остановка и перезапуск проверены')


if __name__ == '__main__':
    main()
