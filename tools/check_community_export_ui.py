"""Нативное создание JSON-экспорта и горячий перезапуск в GitHub CI."""
import argparse
import json
import os
from pathlib import Path
from check_community_ui import FlutterMachine


def verify(machine, path):
    machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
    machine.driver('set_frame_sync', enabled='false')
    machine.driver('scrollIntoView', finderType='ByValueKey', keyValueType='String', keyValueString='prepare-user-export', alignment='1.0')
    machine.key('tap', 'prepare-user-export')
    machine.driver('waitFor', finderType='ByText', text='Записей подготовлено: 1')
    machine.driver('scrollIntoView', finderType='ByValueKey', keyValueType='String', keyValueString='save-user-export', alignment='1.0')
    machine.key('tap', 'save-user-export')
    machine.driver('waitFor', finderType='ByText', text='Экспорт сохранён')
    document = json.loads(path.read_text(encoding='utf-8'))
    if document['format'] != 'space.user-content' or document['content']['principalId'] != 'me':
        raise RuntimeError('Файл экспорта не соответствует формату или владельцу')
    restarted = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
    if restarted.get('code') != 0:
        raise RuntimeError(restarted)
    machine.wait(lambda _: machine.ready >= 2, timeout=60)
    machine.driver('set_frame_sync', enabled='false')
    machine.driver('scrollIntoView', finderType='ByValueKey', keyValueType='String', keyValueString='prepare-user-export', alignment='1.0')
    machine.key('tap', 'prepare-user-export')
    machine.driver('waitFor', finderType='ByText', text='Записей подготовлено: 1')
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
    path = (args.output / 'user-content.json').resolve()
    os.environ['SPACE_EXPORT_PROBE_PATH'] = str(path)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = FlutterMachine(args.client, log, 'test/probes/user_export_probe.dart')
        try:
            verify(machine, path)
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'api': 'ProbeExportApi', 'json_file': 'passed',
        'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('USER_EXPORT_NATIVE_UI_OK: JSON-файл и горячий перезапуск')


if __name__ == '__main__':
    main()
