import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from contextlib import nullcontext
from check_directory_macos import isolated_keychain


def run():
    assert os.environ['GITHUB_ACTIONS'] == 'true'
    binary = Path(sys.argv[1]).resolve(strict=True)
    with tempfile.TemporaryDirectory(dir=os.environ['RUNNER_TEMP']) as path:
        root = Path(path); folder = root / 'Games'; folder.mkdir()
        (folder / 'sample').write_text('catalog-focus-ci')
        env = dict(os.environ, CATALOG_DRILL=path, DIRECTORY_CRASH_NAMESPACE='space-ci-'+hashlib.sha256(path.encode()).hexdigest())
        with isolated_keychain(root) if sys.platform == 'darwin' else nullcontext():
            subprocess.run([str(binary)], env=env, check=True, timeout=180)
        data = json.loads((root / 'report.json').read_text())
        assert all(data[k] for k in ['fresh_session','wrong_password_rejected','confirmed_read','relocked'])
        assert 'inactive' in data['focus'] and 'resumed' in data['focus']
        Path(sys.argv[2]).write_bytes((root/'report.json').read_bytes())


if __name__ == '__main__':
    run()
