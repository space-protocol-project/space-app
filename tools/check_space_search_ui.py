"""Проверить нативный экран общего поиска и настоящий горячий перезапуск в CI."""
import argparse
import json
from pathlib import Path

from check_community_ui import FlutterMachine


class SearchMachine(FlutterMachine):
    def verify(self):
        self.wait(lambda _: self.app is not None and self.ready >= 1)
        self.driver('get_health')
        self.driver('set_frame_sync', enabled='false')
        self.driver('set_text_entry_emulation', enabled='true')
        self.key('tap', 'open-space-search')
        self.key('tap', 'space-search-input')
        self.driver('enter_text', text='совет')
        self.driver('tap', finderType='ByTooltipMessage', text='Поиск')
        self.key('waitFor', 'space-search-5:feed:item-5')
        self.key('tap', 'space-search-5:feed:item-5')
        self.driver('waitFor', finderType='ByText', text='feed:parent:3')
        restarted = self.command('app.restart', {'appId': self.app, 'fullRestart': True, 'pause': False})
        if restarted.get('code') != 0:
            raise RuntimeError(restarted)
        self.wait(lambda _: self.ready >= 2, timeout=60)
        self.driver('set_frame_sync', enabled='false')
        self.key('waitFor', 'open-space-search')
        if self.command('app.stop', {'appId': self.app}) is not True or self.process.wait(timeout=30):
            raise RuntimeError('Нативное приложение завершилось с ошибкой')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = SearchMachine(Path('client'), log, 'test/probes/space_search_probe.dart')
        try:
            machine.verify()
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'api': 'FakeSpaceSearch', 'query_and_target': 'passed',
        'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('SPACE_SEARCH_NATIVE_UI_OK: запрос, точная цель и горячий перезапуск')


if __name__ == '__main__':
    main()
