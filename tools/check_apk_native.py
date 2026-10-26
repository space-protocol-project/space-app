"""Проверить целостность APK и архитектуры всех нативных библиотек."""
import argparse
import hashlib
import json
from pathlib import Path
import struct
import zipfile


def inspect(apk):
    expected = {'armeabi-v7a': (1, 40), 'arm64-v8a': (2, 183), 'x86_64': (2, 62)}
    libraries = {abi: [] for abi in expected}
    with zipfile.ZipFile(apk) as archive:
        bad = archive.testzip()
        if bad:
            raise ValueError(f'Повреждённая запись APK: {bad}')
        for name in archive.namelist():
            parts = name.split('/')
            if len(parts) != 3 or parts[0] != 'lib' or not name.endswith('.so'):
                continue
            abi = parts[1]
            with archive.open(name) as stream:
                header = stream.read(20)
            elf_class, machine = expected[abi]
            if len(header) < 20 or header[:4] != b'\x7fELF' or header[4:6] != bytes([elf_class, 1]):
                raise ValueError(f'Неправильный ELF: {name}')
            if struct.unpack_from('<H', header, 18)[0] != machine:
                raise ValueError(f'Неправильная архитектура: {name}')
            libraries[abi].append(parts[2])
        if not all(libraries.values()):
            raise ValueError('Отсутствует одна из трёх архитектур APK')
    with apk.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    return {'apk': apk.name, 'bytes': apk.stat().st_size, 'sha256': digest,
            'crc': 'ok', 'native_libraries': libraries, 'elf_count': sum(map(len, libraries.values()))}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('apk', type=Path)
    parser.add_argument('--report', type=Path, required=True)
    args = parser.parse_args()
    result = json.dumps(inspect(args.apk), ensure_ascii=False, indent=2)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(result + '\n', encoding='utf-8')
    print(result)


if __name__ == '__main__':
    main()
