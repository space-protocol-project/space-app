"""Проверить публичные файлы совместимого выпуска в GitHub CI."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
import urllib.request
import zipfile

from check_apk_native import inspect

PLATFORMS = ('windows-x64', 'linux-x64', 'macos-arm64')
INSTALLERS = ('Space-Setup-windows-x64.exe', 'Space-macos-arm64.dmg',
              'Space-linux-x64.run', 'Space-android.apk')


def release(project, tag):
    if not re.fullmatch(r'v\d+\.\d+\.\d+', tag):
        raise ValueError('Нужен стабильный тег vX.Y.Z')
    repo = f'space-protocol-project/space-{project}'
    result = json.loads(subprocess.check_output(
        ['gh', 'api', f'repos/{repo}/releases/tags/{tag}'], text=True))
    if result['draft'] or result['prerelease'] or result['tag_name'] != tag:
        raise ValueError('Выпуск ещё не опубликован как стабильный')
    return {asset['name']: asset for asset in result['assets']}


def download(asset, directory):
    target = directory / asset['name']
    digest = hashlib.sha256()
    with urllib.request.urlopen(asset['browser_download_url'], timeout=120) as response:
        with target.open('wb') as output:
            while chunk := response.read(1024 * 1024):
                output.write(chunk)
                digest.update(chunk)
    actual = digest.hexdigest()
    if target.stat().st_size != asset['size'] or asset['digest'] != f'sha256:{actual}':
        raise ValueError(f'Размер или SHA-256 не совпадает: {target.name}')
    return target, {'bytes': target.stat().st_size, 'sha256': actual}


def files(project, tag, names, directory):
    directory.mkdir()
    assets = release(project, tag)
    checksum, _ = download(assets['SHA256SUMS.txt'], directory)
    sums = {}
    for line in checksum.read_text(encoding='utf-8').splitlines():
        match = re.fullmatch(r'([a-f0-9]{64})  ([A-Za-z0-9_.-]+)', line)
        if match is None or match[2] in sums:
            raise ValueError('Неправильный файл контрольных сумм')
        sums[match[2]] = match[1]
    report = {}
    for name in names:
        path, metadata = download(assets[name], directory)
        if sums.get(name) != metadata['sha256']:
            raise ValueError(f'Контрольная сумма не совпадает с SHA256SUMS: {name}')
        report[name] = metadata
        print(f'PUBLIC_ASSET_OK: {name} {metadata["bytes"]} {metadata["sha256"]}', flush=True)
    return report


def runtime(tag, schema, root):
    directory = root / 'runtime'
    names = [f'Space-home-{platform}.zip' for platform in PLATFORMS]
    names += [f'{platform}.json' for platform in PLATFORMS]
    report = files('server', tag, names, directory)
    descriptors = {}
    for platform in PLATFORMS:
        name = f'Space-home-{platform}.zip'
        descriptor = json.loads((directory / f'{platform}.json').read_text(encoding='utf-8'))
        expected_url = f'https://github.com/space-protocol-project/space-server/releases/download/{tag}/{name}'
        if (descriptor['version'] != tag or descriptor['platform'] != platform or
                descriptor['url'] != expected_url or
                descriptor['sha256'] != report[name]['sha256'] or
                descriptor['bytes'] != report[name]['bytes']):
            raise ValueError(f'Несогласованный дескриптор runtime: {platform}')
        with zipfile.ZipFile(directory / name) as archive:
            if archive.testzip() is not None:
                raise ValueError(f'Повреждённый архив runtime: {platform}')
            info = json.loads(archive.read('runtime-info.json'))
            if info['schemaVersion'] != schema:
                raise ValueError(f'Неправильная схема runtime: {platform}')
            unpacked = sum(entry.file_size for entry in archive.infolist())
            if unpacked != descriptor['unpackedBytes']:
                raise ValueError(f'Неправильный размер распаковки: {platform}')
        descriptors[platform] = descriptor
        report[name].update(crc='ok', schema=schema, unpackedBytes=unpacked)
    return report, descriptors


def android_tools():
    root = Path(os.environ['ANDROID_HOME']) / 'build-tools'
    versions = [p for p in root.iterdir() if re.fullmatch(r'\d+(\.\d+)+', p.name)]
    return max(versions, key=lambda p: tuple(map(int, p.name.split('.'))))


def apk_metadata(apk, tools):
    badging = subprocess.check_output([str(tools / 'aapt'), 'dump', 'badging', str(apk)], text=True)
    signature = subprocess.check_output(
        [str(tools / 'apksigner'), 'verify', '--verbose', '--print-certs', str(apk)], text=True)
    return parse_apk_metadata(badging, signature)


def parse_apk_metadata(badging, signature):
    package = re.search(r"package: name='([^']+)' versionCode='(\d+)' versionName='([^']+)'", badging)
    sdk = re.search(r"sdkVersion:'(\d+)'", badging)
    certificates = sorted(set(re.findall(
        r'^.* certificate SHA-256 digest: ([a-f0-9]{64})$', signature, re.MULTILINE)))
    if package is None or sdk is None or not certificates:
        raise ValueError(f'Не получены метаданные APK: package={package is not None}, '
                         f'sdk={sdk is not None}, certificates={bool(certificates)}')
    return {'package': package[1], 'versionCode': int(package[2]),
            'versionName': package[3], 'minSdk': int(sdk[1]), 'certificates': certificates}


def application(tag, previous, code, descriptors, root):
    directory = root / 'app'
    report = files('app', tag, INSTALLERS, directory)
    apk = directory / 'Space-android.apk'
    report[apk.name].update(inspect(apk))
    with zipfile.ZipFile(apk) as archive:
        embedded = json.loads(archive.read('assets/flutter_assets/assets/home/runtime-manifest.json'))
    if embedded != descriptors:
        raise ValueError('Встроенный каталог runtime не соответствует опубликованным дескрипторам')
    tools = android_tools()
    metadata = apk_metadata(apk, tools)
    if (metadata['package'] != 'org.spaceprotocol.space_client' or
            metadata['versionName'] != tag[1:] or metadata['versionCode'] != code or
            metadata['minSdk'] != 24):
        raise ValueError('Неправильный пакет, версия или minSdk APK')
    old_directory = root / 'previous'
    old_directory.mkdir()
    old, _ = download(release('app', previous)['Space-android.apk'], old_directory)
    old_metadata = apk_metadata(old, tools)
    if (metadata['certificates'] != old_metadata['certificates'] or
            metadata['package'] != old_metadata['package'] or
            metadata['versionCode'] <= old_metadata['versionCode']):
        raise ValueError('Нарушена совместимость обновления Android')
    report[apk.name].update(metadata)
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--runtime-tag', required=True)
    parser.add_argument('--schema', required=True, type=int)
    parser.add_argument('--app-tag', default='')
    parser.add_argument('--previous-app-tag', default='')
    parser.add_argument('--version-code', default=0, type=int)
    parser.add_argument('--report', required=True, type=Path)
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix='space-public-release-') as temporary:
        root = Path(temporary)
        runtime_report, descriptors = runtime(args.runtime_tag, args.schema, root)
        report = {'runtimeTag': args.runtime_tag, 'runtime': runtime_report}
        if args.app_tag:
            report['appTag'] = args.app_tag
            report['app'] = application(args.app_tag, args.previous_app_tag,
                                        args.version_code, descriptors, root)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('PUBLIC_RELEASE_OK: полное скачивание, размеры, SHA-256 и содержимое проверены')


if __name__ == '__main__':
    main()
