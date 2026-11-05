"""Выбрать синтетический каталог в настоящем GTK-окне стенда GitHub CI."""
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile


def main():
    if sys.platform != 'linux' or os.environ.get('GITHUB_ACTIONS') != 'true':
        raise RuntimeError('Только изолированный Linux GitHub CI')
    with tempfile.TemporaryDirectory(dir=os.environ['RUNNER_TEMP']) as path:
        folder = Path(path) / 'Games'
        folder.mkdir()
        (folder / 'sample').write_text('catalog-native-ui')
        marker = Path(path) / 'gtk-action'
        env = dict(os.environ, CATALOG_DRILL=path, GTK_USE_PORTAL='0', GSETTINGS_BACKEND='memory',
                   NO_AT_BRIDGE='1', GTK_MODULES=str(Path(sys.argv[3]).resolve(strict=True)),
                   SPACE_CATALOG_CI_DIRECTORY=str(folder), SPACE_CATALOG_CI_MARKER=str(marker))
        subprocess.run([sys.argv[1]], env=env, check=True, timeout=45)
        result = json.loads((Path(path) / 'picker.json').read_text())
        assert marker.read_text() == 'selected'
        assert result == {'system_dialog': 'GTK', 'read': True, 'revoked': True}
        Path(sys.argv[2]).write_text(json.dumps(result))


if __name__ == '__main__':
    main()
