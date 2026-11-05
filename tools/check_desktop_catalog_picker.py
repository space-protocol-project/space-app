"""Выбрать синтетический каталог в настоящем GTK-окне стенда GitHub CI."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time


def xdo(*args):
    subprocess.run(['xdotool', *args], check=True, timeout=10)


def dialog():
    result = subprocess.run(['xdotool', 'search', '--onlyvisible', '--name', '^Choose Directory$'],
                            capture_output=True, text=True, timeout=5)
    return result.stdout.splitlines()[-1] if result.returncode == 0 else None


def drive(process, folder):
    deadline = time.monotonic() + 45
    while time.monotonic() < deadline and process.poll() is None:
        win = dialog()
        if win:
            break
        time.sleep(.2)
    else:
        raise RuntimeError('Окно выбора каталога отсутствует')
    xdo('windowfocus', '--sync', win)
    xdo('key', 'ctrl+l')
    time.sleep(.3)
    xdo('type', '--clearmodifiers', '--', str(folder))
    xdo('key', 'Return')
    for _ in range(5):
        time.sleep(1)
        if dialog() != win:
            break
        xdo('key', 'Return')
    if process.wait(timeout=20) != 0:
        raise RuntimeError('Нативный стенд не подтвердил выбор')


def main():
    if sys.platform != 'linux' or os.environ.get('GITHUB_ACTIONS') != 'true':
        raise RuntimeError('Только изолированный Linux GitHub CI')
    with tempfile.TemporaryDirectory(dir=os.environ['RUNNER_TEMP']) as path:
        folder = Path(path) / 'Games'
        folder.mkdir()
        (folder / 'sample').write_text('catalog-native-ui')
        env = dict(os.environ, CATALOG_DRILL=path, GTK_USE_PORTAL='0', GSETTINGS_BACKEND='memory')
        process = subprocess.Popen([sys.argv[1]], env=env)
        try:
            drive(process, folder)
            result = json.loads((Path(path) / 'picker.json').read_text())
            assert result == {'system_dialog': 'GTK', 'read': True, 'revoked': True}
            Path(sys.argv[2]).write_text(json.dumps(result))
        finally:
            if process.poll() is None:
                process.kill()
                process.wait(timeout=10)


if __name__ == '__main__':
    main()
