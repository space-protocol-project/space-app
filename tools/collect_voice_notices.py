"""Собрать лицензии встроенной модели и закреплённых зависимостей голоса."""
from pathlib import Path
from check_voice_native import ROOT, VENDOR, packages
from collect_mls_notices import local_licenses, upstream_licenses
from urllib.error import HTTPError


def licenses_for(package, directory, cache):
    found = local_licenses(directory)
    if found:
        return found
    try:
        return upstream_licenses(package, directory, cache)
    except HTTPError as error:
        if error.code != 404 or package['name'] != 'realfft':
            raise
        # RealFFT публикует объявление MIT в README, но отдельного LICENSE нет.
        return [('README.md', (directory / 'README.md').read_text(encoding='utf-8')),
                ('MIT license terms',
                 'Permission is hereby granted' +
                 (VENDOR / 'libDF/LICENSE-MIT').read_text(encoding='utf-8').split('Permission is hereby granted', 1)[1])]


def main():
    sections = ['Space: DeepFilterNet3 и нативная обработка голоса.\n'
        'Модель и libDF: Hendrik Schröter, DeepFilterNet v0.5.6, '
        '978576aa8400552a4ce9730838c635aa30db5e61.\n'
        'https://github.com/Rikorose/DeepFilterNet\n'
        'Локальные изменения: manifest только необходимых зависимостей, '
        'совместимость с tract 0.22.3/ndarray 0.16.1. Веса модели не изменены.\n'
        'Rust stdlib: лицензии приведены также в mls-NOTICES.txt.']
    for name, text in local_licenses(VENDOR / 'libDF'):
        sections.append(name + '\n' + text)
    cache = {}
    selected = packages()
    for p in selected:
        directory = Path(p['manifest_path']).parent
        licenses = licenses_for(p, directory, cache)
        sections.append(f"{p['name']} {p['version']}\nSPDX: {p['license']}\nАвторы: {', '.join(p['authors'])}\n"
            f"https://crates.io/api/v1/crates/{p['name']}/{p['version']}/download\n\n" +
            '\n\n'.join(name + '\n' + text for name, text in licenses))
    output = ROOT / 'client/assets/legal/voice-NOTICES.txt'
    content = '\n\n'.join(sections)
    output.write_text('\n'.join(line.rstrip() for line in content.splitlines()).rstrip() + '\n', encoding='utf-8')
    print(f'Лицензии модели и {len(selected)} зависимостей: {output}')


if __name__ == '__main__':
    main()
