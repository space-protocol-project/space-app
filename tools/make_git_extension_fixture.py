"""Создание подписанной Git-фикстуры. Ключ общедоступен и не является доверенным."""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

REPOSITORY = 'https://github.com/space-protocol-project/space-app'
PACKAGE_PATH = 'client/test/fixtures/git-extension'
PAYLOAD = ['manifest.json', 'client.wasm', 'LICENSE']


def encoded(value):
    return json.dumps(value, separators=(',', ':'), ensure_ascii=True).encode()


def b64(value):
    return base64.b64encode(value).decode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--commit')
    args = parser.parse_args()
    output = Path(PACKAGE_PATH)
    output.mkdir(parents=True, exist_ok=True)
    temporary_root = Path('.local/git-fixture-signing').resolve()
    temporary_root.mkdir(parents=True, exist_ok=True)
    openssl = shutil.which('openssl') or 'C:/Program Files/Git/usr/bin/openssl.exe'
    with tempfile.TemporaryDirectory(dir=temporary_root) as directory:
        root = Path(directory).resolve()
        root.relative_to(temporary_root)
        seed = hashlib.sha256(b'Space P1 public CI fixture publisher, never trust').digest()
        key = root / 'key.der'
        key.write_bytes(bytes.fromhex('302e020100300506032b657004220420') + seed)
        public = subprocess.check_output([openssl, 'pkey', '-inform', 'DER', '-in', str(key), '-pubout', '-outform', 'DER'])[-32:]

        def sign(domain, value):
            source = root / 'message'
            source.write_bytes(domain.encode() + b'\0' + value)
            return subprocess.check_output([openssl, 'pkeyutl', '-sign', '-rawin', '-inkey', str(key), '-keyform', 'DER', '-in', str(source)])

        if not args.commit:
            manifest = {'format': 'space.package-profile.p1', 'plugin_id': 'org.spaceprotocol.ci-games',
                        'version': '0.1.0', 'profile': 'client', 'modules': {'client': {
                            'entrypoint': 'client.wasm', 'host_api': 'space.client.p1', 'wasm_abi': 'space_client_p1',
                            'data_schema': 1, 'permissions': ['device.catalog.read'],
                            'platforms': ['windows', 'linux', 'macos']}}, 'contributions': []}
            (output / 'manifest.json').write_bytes(encoded(manifest))
            (output / 'client.wasm').write_bytes(b'\0asm\x01\0\0\0')
            (output / 'LICENSE').write_bytes(b'Public CI fixture only. Public signing seed; never trust this key for real extensions. CC0-1.0.\n')
            index = encoded({'format': 'space.package.index.p1', 'files': {
                name: hashlib.sha256((output / name).read_bytes()).hexdigest() for name in PAYLOAD}})
            (output / 'index.json').write_bytes(index)
            (output / 'index.sig').write_text(b64(sign('space.package.index.p1', index)) + '\n', encoding='ascii')
            (output / 'publisher.key').write_text(b64(public) + '\n', encoding='ascii')
            return
        assert len(args.commit) == 40 and all(c in '0123456789abcdef' for c in args.commit)
        bundle = encoded({'format': 'space.client.bundle.p1', 'index': b64((output / 'index.json').read_bytes()),
                          'signature': (output / 'index.sig').read_text().strip(), 'publisher': b64(public),
                          'files': {name: b64((output / name).read_bytes()) for name in PAYLOAD}})
        origin = encoded({'format': 'space.package.origin.p1', 'repository': REPOSITORY, 'commit': args.commit,
                          'path': PACKAGE_PATH, 'digest': hashlib.sha256(bundle).hexdigest(), 'build_profile': 'prebuilt-client-p1'})
        (output / 'provenance.json').write_bytes(encoded({'payload': b64(origin),
                    'signature': b64(sign('space.package.origin.p1', origin)), 'public_key': b64(public)}))


if __name__ == '__main__':
    main()
