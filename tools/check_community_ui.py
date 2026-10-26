"""Нативный интерфейс избранного и настоящий hot restart в GitHub CI."""
import argparse
import json
from pathlib import Path
import queue
import subprocess
import threading
import time


class FlutterMachine:
    def __init__(self, client, log):
        self.process = subprocess.Popen(
            ['flutter', 'run', '--machine', '-d', 'linux', '--debug', '--no-pub',
             '--enable-software-rendering', '--no-enable-impeller', '--target', 'tool/community_favorites_probe.dart'],
            cwd=client, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, encoding='utf-8', bufsize=1)
        self.messages = queue.Queue()
        self.log, self.app, self.ready, self.sequence = log, None, 0, 0
        threading.Thread(target=self._read, daemon=True).start()

    def _read(self):
        for line in self.process.stdout:
            self.log.write(line)
            self.log.flush()
            try:
                messages = json.loads(line)
            except json.JSONDecodeError:
                continue
            if isinstance(messages, list):
                for message in messages:
                    self.messages.put(message)
        self.messages.put(None)

    def _event(self, message):
        params = message.get('params', {})
        if message.get('event') == 'app.start':
            self.app = params['appId']
        if message.get('event') == 'app.log':
            text = params.get('log', '')
            if 'COMMUNITY_UI_ERROR:' in text:
                raise RuntimeError(text)
            if 'COMMUNITY_UI_READY' in text:
                self.ready += 1

    def wait(self, predicate, timeout=900):
        deadline = time.monotonic() + timeout
        while time.monotonic() < deadline:
            try:
                message = self.messages.get(timeout=1)
            except queue.Empty:
                if self.process.poll() is not None:
                    raise RuntimeError('Flutter завершился до конца проверки')
                continue
            if message is None:
                raise RuntimeError('Поток Flutter закрылся до конца проверки')
            self._event(message)
            if predicate(message):
                return message
        raise TimeoutError('Превышено время ожидания Flutter')

    def command(self, method, params):
        self.sequence += 1
        request_id = self.sequence
        self.process.stdin.write(json.dumps([{'id': request_id, 'method': method, 'params': params}]) + '\n')
        self.process.stdin.flush()
        response = self.wait(lambda value: value.get('id') == request_id, timeout=45)
        if response.get('error'):
            raise RuntimeError(response['error'])
        return response.get('result')

    def driver(self, command, **params):
        result = self.command('app.callServiceExtension', {
            'appId': self.app, 'methodName': 'ext.flutter.driver',
            'params': {'command': command, 'timeout': '15000', **params},
        })
        if result.get('isError'):
            raise RuntimeError(result)
        return result

    def key(self, command, value):
        return self.driver(command, finderType='ByValueKey', keyValueType='String', keyValueString=value)

    def verify(self):
        self.wait(lambda _: self.app is not None and self.ready >= 1)
        self.driver('get_health')
        self.driver('set_frame_sync', enabled='false')
        self.key('tap', 'favorite-1:topic')
        self.driver('waitFor', finderType='ByTooltipMessage', text='Сохранить в избранное')
        self.key('tap', 'favorite-1:topic')
        self.driver('waitFor', finderType='ByTooltipMessage', text='Убрать из избранного')
        self.key('tap', 'open-favorites')
        self.driver('waitFor', finderType='ByText', text='Тема topic')
        self.driver('tap', finderType='Descendant',
                    of=json.dumps({'finderType': 'ByType', 'type': 'Dialog'}),
                    matching=json.dumps({'finderType': 'ByValueKey', 'keyValueType': 'String', 'keyValueString': 'favorite-1:topic'}),
                    matchRoot='false', firstMatchOnly='true')
        self.driver('waitFor', finderType='ByText', text='В этом разделе пока нет избранного.')
        self.driver('tap', finderType='ByTooltipMessage', text='К темам')
        restarted = self.command('app.restart', {'appId': self.app, 'fullRestart': True, 'pause': False})
        if restarted.get('code') != 0:
            raise RuntimeError(restarted)
        self.wait(lambda _: self.ready >= 2, timeout=60)
        self.command('app.stop', {'appId': self.app})
        if self.process.wait(timeout=30):
            raise RuntimeError('Нативное приложение завершилось с ошибкой')

    def close(self):
        if self.process.poll() is None:
            self.process.terminate()
            try:
                self.process.wait(timeout=20)
            except subprocess.TimeoutExpired:
                self.process.kill()
                self.process.wait(timeout=10)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--client', type=Path, default=Path('client'))
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    log_path = args.output / 'native-ui.log'
    with log_path.open('w', encoding='utf-8') as log:
        machine = FlutterMachine(args.client, log)
        try:
            machine.verify()
        finally:
            machine.close()
    (args.output / 'native-ui.json').write_text(json.dumps({
        'platform': 'Linux', 'api': 'FakeCommunityFavorites',
        'add_remove': 'passed', 'list_remove': 'passed', 'hot_restart': 'passed',
        'runtime_errors': 0,
    }, indent=2) + '\n', encoding='utf-8')
    print('COMMUNITY_NATIVE_UI_CI_OK: закладки, список и горячий перезапуск')


if __name__ == '__main__':
    main()
