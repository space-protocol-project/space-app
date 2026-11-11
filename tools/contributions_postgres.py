"""Отдельная PostgreSQL Windows для CI, без службы и рабочих данных."""
from contextlib import contextmanager
import hashlib
import json
import os
from pathlib import PurePosixPath
import secrets
import socket
import subprocess
import urllib.request
import zipfile

VERSION = '17.11'
SOURCE = f'https://get.enterprisedb.com/postgresql/postgresql-{VERSION}-1-windows-x64-binaries.zip'


def binaries(out):
    archive = out / 'postgres.zip'
    urllib.request.urlretrieve(SOURCE, archive)
    target = out / 'postgres-binaries'
    with zipfile.ZipFile(archive) as source:
        for entry in source.infolist():
            name = PurePosixPath(entry.filename)
            if name.is_absolute() or '..' in name.parts or '\\' in entry.filename:
                raise ValueError('Недопустимый путь PostgreSQL')
            if entry.filename.startswith(('pgsql/bin/', 'pgsql/lib/', 'pgsql/share/')):
                source.extract(entry, target)
    executable = target / 'pgsql/bin/pg_ctl.exe'
    version = subprocess.check_output([str(executable), '--version'], text=True).strip()
    if version != f'pg_ctl (PostgreSQL) {VERSION}':
        raise ValueError('Неожиданная версия PostgreSQL')
    (out / 'postgres-source.json').write_text(json.dumps({
        'url': SOURCE, 'version': version,
        'sha256': hashlib.sha256(archive.read_bytes()).hexdigest(),
        'verification': 'HTTPS and version; digest records downloaded bytes',
    }, indent=2) + '\n', encoding='utf-8')
    return executable.parent


@contextmanager
def windows_database(out, private):
    directory = binaries(out)
    data = out / 'postgres-data'
    password_file = private / 'postgres-password'
    password = secrets.token_hex(32)
    password_file.write_text(password, encoding='ascii')
    control = [str(directory / 'pg_ctl.exe'), '-D', str(data)]
    started = False
    try:
        subprocess.run([str(directory / 'initdb.exe'), '-D', str(data), '-U', 'space',
                        '--encoding=UTF8', '--locale=C', '--auth=scram-sha-256',
                        '--pwfile=' + str(password_file)], check=True)
        with socket.socket() as reservation:
            reservation.bind(('127.0.0.1', 0))
            port = reservation.getsockname()[1]
        subprocess.run([*control, '-l', str(out / 'postgres.log'),
                        '-o', f'-h 127.0.0.1 -p {port}', '-w', 'start'], check=True)
        started = True
        yield f'postgres://space:{password}@127.0.0.1:{port}/postgres?sslmode=disable'
    finally:
        password_file.unlink(missing_ok=True)
        if started:
            subprocess.run([*control, '-m', 'fast', '-w', 'stop'], check=True)
            status = subprocess.run([*control, 'status'], capture_output=True)
            if status.returncode != 3:
                raise RuntimeError('PostgreSQL не остановлена')
            (out / 'postgres-stop.json').write_text('{"stopped":true}\n', encoding='utf-8')


@contextmanager
def database(out, private):
    if os.name == 'nt':
        with windows_database(out, private) as url:
            yield url
    else:
        yield os.environ['SPACE_TEST_DATABASE_URL']
