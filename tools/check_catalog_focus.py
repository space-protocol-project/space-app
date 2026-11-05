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
            try:
                if sys.platform == 'darwin':
                    # XCUITest загружается отдельным процессом и наследует пути
                    # CocoaPods от приложения. Делаем готовые фреймворки видимыми
                    # также по стандартному пути BUILT_PRODUCTS_DIR для тестов.
                    products = binary.parents[3]
                    for framework in (binary.parents[1] / 'Frameworks').glob('*.framework'):
                        link = products / framework.name
                        if not link.exists() and not link.is_symlink():
                            link.symlink_to(framework, target_is_directory=True)
                    config = Path(os.environ['RUNNER_TEMP']) / 'catalog-focus-xctest.json'
                    config.write_text(json.dumps({k:env[k] for k in ('GITHUB_ACTIONS','CATALOG_DRILL','DIRECTORY_CRASH_NAMESPACE','SPACE_CATALOG_HELPER')}))
                    subprocess.run(['xcodebuild','test','-workspace','client/macos/Runner.xcworkspace','-scheme','Runner','-configuration','Debug','-destination','platform=macOS','-derivedDataPath','client/build/macos','-parallel-testing-enabled','NO','-only-testing:RunnerTests/CatalogUITests/testSystemFolder','CODE_SIGN_STYLE=Manual','CODE_SIGN_IDENTITY=-','FLUTTER_TARGET=test/probes/catalog_focus_probe.dart'],check=True,timeout=1000)
                else:
                    subprocess.run([str(binary)], env=env, check=True, timeout=180)
            finally:
                progress = root / 'progress.log'
                if progress.exists():
                    print(progress.read_text(encoding='utf-8'))
        data = json.loads((root / 'report.json').read_text())
        assert all(data[k] for k in ['fresh_session','wrong_password_rejected','confirmed_read','relocked'])
        assert 'inactive' in data['focus'] and 'resumed' in data['focus']
        Path(sys.argv[2]).write_bytes((root/'report.json').read_bytes())


if __name__ == '__main__':
    run()
