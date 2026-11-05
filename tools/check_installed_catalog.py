"""Поставка файлового процесса и восстановление установок в настольном CI."""
from contextlib import contextmanager, nullcontext
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time

from check_directory_macos import isolated_keychain


def command(args, **kwargs):
    subprocess.run(list(map(str, args)), check=True, timeout=180, **kwargs)


@contextmanager
def installed(root):
    destination = root / 'Installed Space'
    if sys.platform == 'win32':
        import winreg
        key = r'Software\Microsoft\Windows\CurrentVersion\Uninstall\{A1D164D7-8CE9-4FF1-98B7-3D9970218441}_is1'
        try:
            existing = winreg.OpenKey(winreg.HKEY_CURRENT_USER, key)
        except FileNotFoundError:
            pass
        else:
            existing.Close()
            raise RuntimeError('Space уже установлен: тест не изменяет чужую установку')
        command([Path('dist/Space-Setup-windows-x64.exe').resolve(), '/VERYSILENT',
                 '/SUPPRESSMSGBOXES', '/NORESTART', '/NOICONS', f'/DIR={destination}'])
        try:
            yield destination / 'space_client.exe'
        finally:
            command([destination / 'unins000.exe', '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART'])
    elif sys.platform == 'darwin':
        mount = root / 'mounted'
        command(['hdiutil', 'attach', next(Path('dist').glob('Space-macos-*.dmg')),
                 '-readonly', '-nobrowse', '-mountpoint', mount])
        try:
            command(['ditto', mount / 'Space.app', destination / 'Space.app'])
        finally:
            command(['hdiutil', 'detach', mount])
        yield destination / 'Space.app/Contents/MacOS/Space'
    else:
        command(['bash', 'dist/Space-linux-x64.run', '--extract', destination])
        yield destination / 'space_client'


def launch(args, root, role, environment, log):
    if sys.platform != 'darwin':
        command(args, env=environment, stdout=log, stderr=subprocess.STDOUT)
        return
    # Как flutter_tools: после готовности процесса open выводит его на передний план.
    process = subprocess.Popen(list(map(str, args)), env=environment, stdout=log, stderr=subprocess.STDOUT)
    try:
        ready = root / f'{role}.ready'
        deadline = time.monotonic() + 30
        while not ready.exists():
            if process.poll() is not None or time.monotonic() > deadline:
                raise RuntimeError('Приложение не подготовило первое окно')
            time.sleep(.05)
        assert ready.read_text() == str(process.pid)
        command(['/usr/bin/open', Path(args[0]).parents[2]], env=environment)
        if process.wait(timeout=180) != 0:
            raise RuntimeError('Нативная проверка macOS завершилась ошибкой')
    finally:
        if process.poll() is None:
            process.kill()
            process.wait(timeout=10)


def phases(root, binary, environment, output):
    helper = binary.parent / ('space-catalog.exe' if sys.platform == 'win32' else 'space-catalog')
    digest = hashlib.sha256(helper.read_bytes()).hexdigest()
    checksum = (binary.parent.parent / 'Resources/space-catalog.sha256' if sys.platform == 'darwin'
                else helper.with_suffix(helper.suffix + '.sha256'))
    assert checksum.read_text().strip() == digest
    if sys.platform == 'darwin':
        command(['codesign', '--verify', '--strict', helper])
    results = []
    for role in ('install', 'reopen', 'corrupt'):
        if role == 'corrupt':
            package = next((root / 'extensions/device/profile/packages').glob('*.package'))
            package.write_bytes(b'corrupt')
        env = dict(environment, DIRECTORY_CRASH_ROLE=role)
        args = [binary]
        if sys.platform == 'linux':
            args = ['dbus-run-session', '--', sys.executable, 'tools/directory_keyring_session.py', binary]
        with (output / f'{role}.log').open('w', encoding='utf-8') as log:
            try:
                launch(args, root, role, env, log)
            finally:
                error = root / 'error.json'
                if error.exists():
                    (output / 'error.json').write_bytes(error.read_bytes())
        result = json.loads((root / f'{role}.json').read_text())
        assert result['passed'] and result['sha256'] == digest
        assert Path(result['helper']).resolve() == helper.resolve()
        results.append(result)
    assert len({result['pid'] for result in results}) == 3
    (output / 'result.json').write_text(json.dumps({
        'platform': sys.platform, 'phases': results,
        'package_transport': {'win32': 'Inno Setup', 'darwin': 'DMG copy', 'linux': 'run extract'}[sys.platform],
        'authentication': 'fixture', 'directory_selection': 'fixture',
        'storage': 'native', 'catalog_process': 'installed bundle',
    }, ensure_ascii=False, indent=2), encoding='utf-8')


def main():
    if os.environ.get('GITHUB_ACTIONS') != 'true':
        raise RuntimeError('Сценарий разрешён только в GitHub CI')
    output = Path('installed-catalog-results')
    output.mkdir(exist_ok=True)
    with tempfile.TemporaryDirectory(dir=os.environ['RUNNER_TEMP']) as temporary:
        root = Path(temporary).resolve()
        profile = root / 'profile'
        profile.mkdir()
        (root / 'Games').mkdir()
        (root / 'Games/sample').write_bytes(b'installed catalog')
        environment = dict(os.environ, DIRECTORY_CRASH_CONTROL=str(root),
                           DIRECTORY_CRASH_PROFILE=str(profile),
                           DIRECTORY_CRASH_NAMESPACE='space-ci-' + hashlib.sha256(temporary.encode()).hexdigest()[:16],
                           XDG_DATA_HOME=str(profile / 'data'), XDG_CONFIG_HOME=str(profile / 'config'),
                           XDG_CACHE_HOME=str(profile / 'cache'), LIBGL_ALWAYS_SOFTWARE='1')
        with isolated_keychain(root) if sys.platform == 'darwin' else nullcontext() as keychain:
            if keychain:
                environment['DIRECTORY_CRASH_KEYCHAIN'] = str(keychain)
            with installed(root) as binary:
                phases(root, binary, environment, output)


if __name__ == '__main__':
    main()
