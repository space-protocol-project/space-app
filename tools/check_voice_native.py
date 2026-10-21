"""Проверить закреплённые исходники/модель и зависимости обработки голоса."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
VENDOR = ROOT / 'native/space_voice/vendor/deep_filter'
TARGETS = ['x86_64-pc-windows-msvc', 'x86_64-unknown-linux-gnu',
           'aarch64-apple-darwin', 'x86_64-apple-darwin',
           'aarch64-linux-android', 'armv7-linux-androideabi', 'x86_64-linux-android']


def verify_sources():
    manifest = json.loads((VENDOR / 'UPSTREAM.json').read_text())
    if manifest['commit'] != '978576aa8400552a4ce9730838c635aa30db5e61':
        raise ValueError('Неизвестная версия DeepFilterNet3')
    for entry in manifest['files']:
        name = entry['path']
        path = VENDOR / name
        if name == 'libDF/Cargo.toml':
            path = VENDOR / 'libDF/Cargo.upstream.toml'
        content = path.read_bytes()
        if name == 'libDF/src/tract.rs':
            content = content.replace(b'\r\n', b'\n').replace(b'.symbols.sym(', b'.symbol_table.sym(')
        # Локальная запись текста Windows может сменить переводы строк.
        digest = hashlib.sha256(content).hexdigest()
        if digest != entry['sha256']:
            raise ValueError('Изменён закреплённый исходник/модель: ' + name)
    print('Закреплённые исходники и модель DeepFilterNet3 проверены')


def packages():
    selected = {}
    for target in TARGETS:
        raw = subprocess.check_output(['cargo', '+1.99.0', 'metadata', '--locked',
            '--format-version', '1', '--filter-platform', target,
            '--manifest-path', str(ROOT / 'native/space_voice/Cargo.toml')], text=True)
        metadata = json.loads(raw)
        active = {node['id'] for node in metadata['resolve']['nodes']}
        selected.update({p['id']: p for p in metadata['packages']
                        if p['id'] in active and p.get('source')})
    return sorted(selected.values(), key=lambda p: (p['name'], p['version']))


def check_advisories():
    selected = packages()
    query = {'queries': [{'package': {'ecosystem': 'crates.io', 'name': p['name']},
                          'version': p['version']} for p in selected]}
    request = urllib.request.Request('https://api.osv.dev/v1/querybatch',
        data=json.dumps(query).encode(), headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(request, timeout=45) as response:
        results = json.load(response)['results']
    if len(results) != len(selected):
        raise ValueError('Неполный ответ проверки уязвимостей')
    issues = []
    warnings = []
    for package, result in zip(selected, results):
        for advisory in result.get('vulns', []):
            with urllib.request.urlopen('https://api.osv.dev/v1/vulns/' + advisory['id'], timeout=30) as response:
                detail = json.load(response)
            affected = detail.get('affected', [])
            informational = affected and all(
                item.get('database_specific', {}).get('informational') == 'unmaintained'
                for item in affected)
            entry = (package['name'], package['version'], advisory['id'])
            (warnings if informational else issues).append(entry)
    if issues:
        raise RuntimeError('Замечания к зависимостям голоса: ' + json.dumps(issues))
    print(f'OSV: {len(selected)} зависимостей, уязвимостей не найдено')
    if warnings:
        print('Информационные предупреждения о сопровождении: ' + json.dumps(warnings))


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')
    parser = argparse.ArgumentParser()
    parser.add_argument('--advisories', action='store_true')
    args = parser.parse_args()
    verify_sources()
    if args.advisories:
        check_advisories()
