"""Подписка, личная лента и горячий перезапуск нативного интерфейса в CI."""
import argparse
import json
from pathlib import Path
from check_community_ui import FlutterMachine


def verify(machine):
    machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
    machine.driver('set_frame_sync', enabled='false')
    machine.key('tap', 'follow-author')
    machine.driver('waitFor', finderType='ByTooltipMessage', text='Отписаться')
    machine.key('tap', 'open-personal-feed')
    machine.key('waitFor', 'personal-post-post')
    machine.key('tap', 'personal-open-post')
    machine.driver('waitFor', finderType='ByText', text='Давайте обсудим здесь')
    restarted = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
    if restarted.get('code') != 0:
        raise RuntimeError(restarted)
    machine.wait(lambda _: machine.ready >= 2, timeout=60)
    machine.driver('set_frame_sync', enabled='false')
    machine.key('tap', 'follow-author')
    machine.key('tap', 'open-following')
    machine.key('tap', 'unfollow-author')
    machine.driver('waitFor', finderType='ByText', text='Вы пока ни на кого не подписаны.')
    if machine.command('app.stop', {'appId': machine.app}) is not True:
        raise RuntimeError('Приложение не подтвердило остановку')
    if machine.process.wait(timeout=30):
        raise RuntimeError('Ошибка завершения приложения')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--client', type=Path, default=Path('client'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = FlutterMachine(args.client, log, 'test/probes/participant_follows_probe.dart')
        try:
            verify(machine)
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'api': 'FakeFollows', 'subscribe': 'passed',
        'personal_feed_open_original': 'passed', 'unsubscribe': 'passed',
        'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('PARTICIPANT_FOLLOWS_NATIVE_UI_OK: подписки, личная лента и горячий перезапуск')


if __name__ == '__main__':
    main()
