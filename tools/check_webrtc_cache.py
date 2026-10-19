"""Проверка смены версии нативного комплекта без сети и Flutter."""
from pathlib import Path
import os
import shutil
import subprocess
import tempfile
import zipfile


def cmake_path():
    found = shutil.which('cmake')
    if found:
        return found
    vswhere = Path(os.environ['ProgramFiles(x86)']) / 'Microsoft Visual Studio/Installer/vswhere.exe'
    found = subprocess.check_output([
        str(vswhere), '-latest', '-products', '*', '-find',
        'Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin/cmake.exe',
    ], text=True).strip()
    if not found:
        raise RuntimeError('CMake not found')
    return found


def main():
    root = Path(__file__).resolve().parents[1]
    source = root / 'client/vendor/flutter_webrtc/third_party/CMakeLists.txt'
    cmake = cmake_path()
    with tempfile.TemporaryDirectory(prefix='space-webrtc-cache-') as directory:
        work = Path(directory)
        dependency = work / 'third_party'
        dependency.mkdir()
        shutil.copyfile(source, dependency / 'CMakeLists.txt')
        (work / 'CMakeLists.txt').write_text(
            'cmake_minimum_required(VERSION 3.15)\nproject(cache NONE)\n'
            'set(CMAKE_SYSTEM_NAME Windows)\nset(CMAKE_SIZEOF_VOID_P 8)\n'
            'include(third_party/CMakeLists.txt)\n', encoding='utf-8')
        # Имитируем оставшийся unversioned кеш прежнего сборщика.
        (dependency / 'downloads').mkdir()
        (dependency / 'downloads/libwebrtc-win-x64-release.zip').write_bytes(b'stale')
        (dependency / 'libwebrtc').mkdir()
        (dependency / 'libwebrtc/old.dll').write_bytes(b'stale')
        for index, version in enumerate(('v1', 'v2', 'v2')):
            release = work / 'releases' / version
            release.mkdir(parents=True, exist_ok=True)
            with zipfile.ZipFile(release / 'libwebrtc-win-x64-release.zip', 'w') as archive:
                archive.writestr('include/version.h', version)
                archive.writestr('lib/test.dll', version)
            (dependency / 'libwebrtc_version.ini').write_text(
                f'binary_version = {version}\ndownload_url = {(work / "releases").as_uri()}\n',
                encoding='utf-8')
            subprocess.run([cmake, '-S', str(work), '-B', str(work / 'build')],
                           check=True, capture_output=True, text=True)
            extracted = dependency / 'libwebrtc'
            assert (extracted / 'include/version.h').read_text() == version
            assert (extracted / 'lib/test.dll').read_text() == version
            assert (extracted / '.space-version').read_text() == f'{version}/libwebrtc-win-x64-release'
            assert not (extracted / 'old.dll').exists()
            marker = extracted / 'same-version-kept'
            if index == 1:
                marker.write_text('keep')
            if index == 2:
                assert marker.read_text() == 'keep'
            assert not list((dependency / 'downloads').rglob('*.partial'))
        manifest = dependency / 'libwebrtc_version.ini'
        manifest.write_text(manifest.read_text().replace('v2', 'missing'))
        failed = subprocess.run([cmake, '-S', str(work), '-B', str(work / 'build')],
                                capture_output=True, text=True)
        assert failed.returncode != 0
        assert not list((dependency / 'downloads/missing').glob('*.zip'))
        assert not list((dependency / 'downloads').rglob('*.partial'))
        assert (extracted / '.space-version').read_text() == 'v2/libwebrtc-win-x64-release'
    print('Native cache: legacy cache, version change and same-version reuse passed')


if __name__ == '__main__':
    main()
