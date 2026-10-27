"""Настоящий экран, начало Noise, отмена и горячий перезапуск в GitHub CI."""
import argparse
import json
from pathlib import Path
import time

from check_community_ui import FlutterMachine


def cancel_transfer(machine):
    machine.driver('tap', finderType='ByText', text='Получить каталог')
    machine.driver('waitFor', finderType='ByText', text='Скопировать QR-запрос')
    machine.driver('tap', finderType='ByText', text='Отмена')
    machine.driver('waitFor', finderType='ByText', text='Получить каталог')
    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        result = machine.driver('request_data', message='status')
        if result.get('response', {}).get('message') == '1:true':
            return
        time.sleep(.1)
    raise RuntimeError('Начало Noise либо отмена не подтверждены')


def verify(machine):
    machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
    machine.driver('set_frame_sync', enabled='false')
    cancel_transfer(machine)
    result = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
    if result.get('code') != 0:
        raise RuntimeError(result)
    machine.wait(lambda _: machine.ready >= 2, timeout=60)
    machine.driver('set_frame_sync', enabled='false')
    cancel_transfer(machine)
    if machine.command('app.stop', {'appId': machine.app}) is not True:
        raise RuntimeError('Приложение не остановилось')
    if machine.process.wait(timeout=30):
        raise RuntimeError('Ошибка завершения приложения')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--client', type=Path, default=Path('client'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = FlutterMachine(args.client, log, 'test/probes/directory_transfer_probe.dart')
        try:
            verify(machine)
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'relay': 'DirectoryProbeRelay HTTP fixture',
        'native_noise_request_cancel': 'passed', 'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('DIRECTORY_TRANSFER_NATIVE_UI_OK: Noise, отмена и горячий перезапуск')


if __name__ == '__main__':
    main()
