"""Проверить ответы, репост и горячий перезапуск настоящего интерфейса Linux."""
import argparse
import json
from pathlib import Path

from check_community_ui import FlutterMachine


class SocialMachine(FlutterMachine):
    def scroll(self, key):
        return self.driver('scrollIntoView', finderType='ByValueKey',
                           keyValueType='String', keyValueString=key, alignment='0.5')

    def verify(self):
        self.wait(lambda _: self.app is not None and self.ready >= 1)
        self.driver('get_health')
        self.driver('set_frame_sync', enabled='false')
        self.driver('set_text_entry_emulation', enabled='true')
        self.key('waitFor', 'feed-reply-comment')
        self.scroll('feed-reply-comment')
        self.key('tap', 'feed-reply-comment')
        self.driver('waitFor', finderType='ByText', text='Ответ на комментарий №1')
        self.scroll('feed-text')
        self.key('tap', 'feed-text')
        self.driver('enter_text', text='Ответ участнику')
        self.scroll('feed-send')
        self.key('tap', 'feed-send')
        self.driver('waitFor', finderType='ByText', text='reply:comment')
        self.scroll('feed-share-post')
        self.key('tap', 'feed-share-post')
        send = {
            'finderType': 'Descendant',
            'of': json.dumps({'finderType': 'ByType', 'type': 'Dialog'}),
            'matching': json.dumps({'finderType': 'ByValueKey', 'keyValueType': 'String', 'keyValueString': 'feed-send'}),
            'matchRoot': 'false', 'firstMatchOnly': 'false',
        }
        self.driver('waitForTappable', **send)
        self.driver('tap', **send)
        self.driver('waitFor', finderType='ByText', text='repost:post')
        restarted = self.command('app.restart', {'appId': self.app, 'fullRestart': True, 'pause': False})
        if restarted.get('code') != 0:
            raise RuntimeError(restarted)
        self.wait(lambda _: self.ready >= 2, timeout=60)
        self.driver('set_frame_sync', enabled='false')
        self.key('waitFor', 'feed-reply-comment')
        if self.command('app.stop', {'appId': self.app}) is not True or self.process.wait(timeout=30):
            raise RuntimeError('Ошибка остановки нативного приложения')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    with (args.output / 'native-ui.log').open('w', encoding='utf-8') as log:
        machine = SocialMachine(Path('client'), log, 'test/probes/feed_social_probe.dart')
        try:
            machine.verify()
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'api': 'SocialFeed', 'reply': 'passed',
        'repost': 'passed', 'hot_restart': 'passed', 'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('FEED_SOCIAL_NATIVE_UI_OK: ответ, репост и горячий перезапуск')


if __name__ == '__main__':
    main()
