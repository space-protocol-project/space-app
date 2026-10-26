"""Создание/отмена настоящего клиентского запроса и hot restart в CI."""
import argparse
import json
from pathlib import Path
import time

from check_community_ui import FlutterMachine


def cancel_pairing(machine):
    machine.driver('tap', finderType='ByText', text='Доверять серверу и начать сопряжение')
    machine.driver('waitFor', finderType='ByText', text='pc_' + 'b' * 43)
    machine.driver('tap', finderType='ByText', text='Отменить сопряжение')
    machine.driver('waitFor', finderType='ByText', text='Доверять серверу и начать сопряжение')
    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        result = machine.driver('request_data', message='cancellations')
        if result.get('response', {}).get('message') == '1':
            return
        time.sleep(.1)
    raise RuntimeError('Клиент не отменил запрос сопряжения')


def verify(machine):
    machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
    machine.driver('set_frame_sync', enabled='false')
    cancel_pairing(machine)
    restarted = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
    if restarted.get('code') != 0:
        raise RuntimeError(restarted)
    machine.wait(lambda _: machine.ready >= 2, timeout=60)
    machine.driver('set_frame_sync', enabled='false')
    cancel_pairing(machine)
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
        machine = FlutterMachine(args.client, log, 'test/probes/pairing_probe.dart')
        try:
            verify(machine)
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'server': 'PairingServer fixture',
        'request_cancel': 'passed', 'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('PAIRING_NATIVE_UI_OK: запрос, отмена и горячий перезапуск')


if __name__ == '__main__':
    main()
