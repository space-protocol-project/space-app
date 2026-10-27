"""Настоящие HTTPS/Connect хранилище и свидетель с раздельными БД в GitHub CI."""
import argparse
import hashlib
import http.client
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import ssl
import subprocess
import threading
import time

from check_community_interop import free_ports, ready, stop


def tls_proxy(backend, certificate, key):
    class Proxy(BaseHTTPRequestHandler):
        def do_GET(self):
            self.forward()

        def do_POST(self):
            self.forward()

        def log_message(self, *args):
            pass

        def forward(self):
            body = self.request_body()
            connection = http.client.HTTPConnection('127.0.0.1', backend, timeout=45)
            headers = {k: v for k, v in self.headers.items()
                       if k.lower() not in ['host', 'connection', 'transfer-encoding', 'content-length']}
            headers['Content-Length'] = str(len(body))
            try:
                connection.request(self.command, self.path, body=body, headers=headers)
                response = connection.getresponse()
                body = response.read(8 * 1024 * 1024 + 1)
                if len(body) > 8 * 1024 * 1024:
                    raise ValueError('Ответ слишком велик')
                self.send_response(response.status)
                for name, value in response.getheaders():
                    if name.lower() not in ['connection', 'transfer-encoding', 'content-length']:
                        self.send_header(name, value)
                self.send_header('Content-Length', str(len(body)))
                self.end_headers()
                self.wfile.write(body)
            finally:
                connection.close()

        def request_body(self):
            limit = 6 * 1024 * 1024
            if self.headers.get('Transfer-Encoding', '').lower() == 'chunked':
                body = bytearray()
                for _ in range(4096):
                    line = self.rfile.readline(128)
                    size = int(line.split(b';', 1)[0].strip(), 16)
                    if size < 0 or len(body) + size > limit:
                        raise ValueError('Тело слишком велико')
                    if size == 0:
                        if self.rfile.readline(128) != b'\r\n':
                            raise ValueError('Неожиданный trailer')
                        return bytes(body)
                    body.extend(self.rfile.read(size))
                    if self.rfile.read(2) != b'\r\n':
                        raise ValueError('Неверный chunk')
                raise ValueError('Слишком много частей')
            length = int(self.headers.get('Content-Length', '0'))
            if length < 0 or length > limit:
                raise ValueError('Тело слишком велико')
            return self.rfile.read(length)

    server = ThreadingHTTPServer(('127.0.0.1', 0), Proxy)
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.load_cert_chain(certificate, key)
    server.socket = context.wrap_socket(server.socket, server_side=True)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    return server, thread


def run(args):
    database = os.environ['SPACE_DATABASE_URL']
    servers, proxies, threads, commands, environments, origins = [], [], [], [], [], []
    client = None
    marker = args.output / 'restart'
    with (args.output / 'interop.log').open('w', encoding='utf-8') as log:
        try:
            for role in ['storage', 'witness']:
                subprocess.run(['psql', database, '-v', 'ON_ERROR_STOP=1', '-c', f'CREATE SCHEMA remote_{role}'], check=True, stdout=log, stderr=log)
                environment = dict(os.environ)
                environment['SPACE_DATABASE_URL'] = database + f'&search_path=remote_{role}'
                environment.pop('SPACE_SETUP_CODE', None)
                http, grpc = free_ports()
                command = [str(args.server.resolve()), '-http', f'127.0.0.1:{http}', '-grpc', f'127.0.0.1:{grpc}', '-managed']
                instance = subprocess.Popen(command, env=environment, stdin=subprocess.PIPE, stdout=log, stderr=log)
                servers.append(instance)
                origin = f'http://127.0.0.1:{http}'
                ready(instance, origin)
                commands.append(command)
                environments.append(environment)
                origins.append(origin)
                certificate, key = args.output / f'{role}.pem', args.output / f'{role}.key'
                subprocess.run(['openssl', 'req', '-x509', '-newkey', 'rsa:2048', '-nodes', '-days', '1', '-subj', '/CN=127.0.0.1', '-addext', 'subjectAltName=IP:127.0.0.1', '-keyout', str(key), '-out', str(certificate)], check=True, stdout=log, stderr=log)
                proxy, thread = tls_proxy(http, certificate, key)
                proxies.append(proxy)
                threads.append(thread)
            defines = []
            for role, proxy, auth_origin in zip(['STORAGE', 'WITNESS'], proxies, origins):
                der = ssl.PEM_cert_to_DER_cert((args.output / f'{role.lower()}.pem').read_text())
                fingerprint = hashlib.sha256(der).hexdigest()
                defines += [f'--dart-define=REMOTE_{role}=https://127.0.0.1:{proxy.server_port}', f'--dart-define=REMOTE_{role}_TLS={fingerprint}', f'--dart-define=REMOTE_{role}_AUTH={auth_origin}']
            command = ['flutter', 'test', 'test/remote_backup_interop_test.dart', *defines, f'--dart-define=REMOTE_RESTART={marker}']
            client = subprocess.Popen(command, cwd=args.client, stdin=subprocess.DEVNULL, stdout=log, stderr=log)
            deadline = time.monotonic() + 600
            while not marker.with_suffix('.ready').exists():
                if client.poll() is not None:
                    raise RuntimeError('Клиент не дошёл до перезапуска')
                if time.monotonic() > deadline:
                    raise TimeoutError('Клиент не готов к перезапуску')
                time.sleep(.2)
            for index, instance in enumerate(servers):
                stop(instance)
                servers[index] = None
            for index, command in enumerate(commands):
                instance = subprocess.Popen(command, env=environments[index], stdin=subprocess.PIPE, stdout=log, stderr=log)
                servers[index] = instance
                ready(instance, origins[index])
            marker.with_suffix('.resume').write_text('resume')
            if client.wait(timeout=240):
                raise RuntimeError('Сквозная проверка не пройдена')
            (args.output / 'report.json').write_text(json.dumps({'result':'passed','https_servers':2,'postgres_schemas':2,'lost_commit_reply':True,'restart_both':True,'restore_without_session':True,'revocation':True}, indent=2) + '\n')
        finally:
            if client is not None and client.poll() is None:
                client.terminate()
                client.wait(timeout=15)
            for instance in servers:
                stop(instance)
            for proxy, thread in zip(proxies, threads):
                proxy.shutdown()
                proxy.server_close()
                thread.join(timeout=5)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--server', type=Path, required=True)
    parser.add_argument('--client', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if os.environ.get('GITHUB_ACTIONS') != 'true' or not os.environ.get('SPACE_DATABASE_URL'):
        raise RuntimeError('Стенд разрешён только в GitHub CI с тестовой БД')
    args.output = args.output.resolve()
    args.output.relative_to(Path(os.environ['RUNNER_TEMP']).resolve())
    args.output.mkdir(parents=True, exist_ok=False)
    try:
        run(args)
    finally:
        print((args.output / 'interop.log').read_text(encoding='utf-8', errors='replace'))
    print('REMOTE_BACKUP_INTEROP_OK: HTTPS, независимый свидетель, перезапуск и отзыв')


if __name__ == '__main__':
    main()
