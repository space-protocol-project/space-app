"""Расшифрование, проверка и применение каталога с hot restart в CI."""
import argparse
import json
from pathlib import Path
import time

from check_community_ui import FlutterMachine


def restore_directory(machine):
    result = machine.driver('request_data', message='preview')
    if result.get('response', {}).get('message') != 'preview':
        raise RuntimeError('Предварительная проверка не завершилась')
    machine.driver('tap', finderType='ByText', text='Применить каталог')
    machine.driver('tap', finderType='ByText', text='Подтвердить')
    machine.driver('waitFor', finderType='ByText', text='Локальное восстановление завершено. Подписки применяются отдельной командой после входа той же личности.')
    result = machine.driver('request_data', message='status')
    if result.get('response', {}).get('message') != 'restored':
        raise RuntimeError('Каталог не применён')


def verify(machine):
    machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
    machine.driver('set_frame_sync', enabled='false')
    restore_directory(machine)
    restarted = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
    if restarted.get('code') != 0:
        raise RuntimeError(restarted)
    machine.wait(lambda _: machine.ready >= 2, timeout=60)
    machine.driver('set_frame_sync', enabled='false')
    restore_directory(machine)
    if machine.command('app.stop', {'appId': machine.app}) is not True:
        raise RuntimeError('Приложение не подтвердило остановку')
    if machine.process.wait(timeout=30):
        raise RuntimeError('Нативное приложение завершилось с ошибкой')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--client', type=Path, default=Path('client'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = FlutterMachine(args.client, log, 'test/probes/directory_probe.dart')
        try:
            verify(machine)
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'storage': 'DirectoryStorage fixture',
        'decrypt_preview_apply': 'passed', 'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('DIRECTORY_NATIVE_UI_OK: расшифрование, проверка, применение и горячий перезапуск')


if __name__ == '__main__':
    main()
