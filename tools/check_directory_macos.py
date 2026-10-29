"""Изолированная PostgreSQL из закреплённого runtime и Keychain-сценарий macOS CI."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import urllib.request
import zipfile

from check_community_interop import free_ports


def command(args, **kwargs):
    subprocess.run([str(value) for value in args], check=True, **kwargs)


def postgres(root, app):
    manifest = json.loads((app / 'client/assets/home/runtime-manifest.json').read_text())
    descriptor = manifest['macos-arm64']
    expected = ('https://github.com/space-protocol-project/space-server/releases/download/'
                + descriptor['version'] + '/Space-home-macos-arm64.zip')
    if descriptor['url'] != expected:
        raise RuntimeError('Недопустимый источник PostgreSQL')
    archive = root / 'runtime.zip'
    urllib.request.urlretrieve(expected, archive)
    with archive.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    if archive.stat().st_size != descriptor['bytes'] or digest != descriptor['sha256']:
        raise RuntimeError('Размер или SHA-256 runtime не совпадает')
    with zipfile.ZipFile(archive) as package:
        for entry in package.infolist():
            if entry.filename.startswith('/') or '..' in Path(entry.filename).parts:
                raise RuntimeError('Недопустимый путь runtime')
        if package.testzip() is not None:
            raise RuntimeError('Повреждён архив runtime')
    destination = root / 'runtime'
    command(['/usr/bin/ditto', '-x', '-k', archive, destination])
    return destination / 'postgres/bin'


def main():
    if sys.platform != 'darwin' or os.environ.get('GITHUB_ACTIONS') != 'true':
        raise RuntimeError('Сценарий разрешён только в GitHub CI macOS')
    root = (Path(os.environ['RUNNER_TEMP']) / 'directory-macos-crash').resolve()
    root.relative_to(Path(os.environ['RUNNER_TEMP']).resolve())
    root.mkdir(mode=0o700, exist_ok=False)
    app = Path(__file__).resolve().parent.parent
    binary = Path(sys.argv[1]).resolve()
    pg = postgres(root, app)
    database = root / 'database'
    port, _ = free_ports()
    started = False
    with (root / 'postgres.log').open('w') as log:
        try:
            command([pg / 'initdb', '-D', database, '-U', 'space_test', '-A', 'trust',
                     '--encoding=UTF8', '--no-locale'], stdout=log, stderr=log)
            command([pg / 'pg_ctl', '-D', database, '-l', root / 'database.log',
                     '-o', f'-h 127.0.0.1 -p {port}', '-w', 'start'], stdout=log, stderr=log)
            started = True
            environment = dict(os.environ)
            environment['SPACE_DATABASE_URL'] = f'postgres://space_test@127.0.0.1:{port}/postgres?sslmode=disable'
            command([sys.executable, app / 'tools/check_directory_crash.py', '--app',
                     app / 'client/build/macos/Build/Products/Debug/Space.app/Contents/MacOS/Space',
                     '--server', binary, '--output', root / 'cases'], env=environment)
        finally:
            if started:
                command([pg / 'pg_ctl', '-D', database, '-m', 'fast', '-w', 'stop'], stdout=log, stderr=log)


if __name__ == '__main__':
    main()
