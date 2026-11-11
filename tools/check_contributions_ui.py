"""Нативный клиент → Connect → сессии/ACL/PostgreSQL → отдельный WASM."""
import json
import os
from pathlib import Path
import time
from check_community_ui import FlutterMachine

out = Path('.local/p1-contributions-client')
private = out / 'private'
config = json.loads((private / 'connection.json').read_text())
os.environ['P1_CONTRIBUTIONS_URL'] = config['url']
os.environ['P1_CONTRIBUTIONS_AUTH'] = config['authorization']

def change(command):
    temporary = private / 'next-control'
    temporary.write_text(command)
    temporary.replace(private / 'control')
    deadline = time.monotonic() + 10
    while time.monotonic() < deadline:
        complete = private / 'completed'
        if complete.exists() and complete.read_text() == command:
            return
        time.sleep(.05)
    raise RuntimeError('Стенд не подтвердил изменение')

with (out / 'native-ui.log').open('w', encoding='utf-8') as log:
    machine = FlutterMachine(Path('client'), log, 'test/probes/contributions_probe.dart', device='linux')
    try:
        machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
        machine.driver('set_frame_sync', enabled='false')
        for iteration in range(2):
            machine.driver('waitFor', finderType='ByText', text='Сводка')
            machine.key('tap', 'contribution-summary')
            machine.driver('waitFor', finderType='ByText', text='Расширение')
            machine.key('tap', 'contributions-back')
            machine.key('tap', 'contribution-details')
            machine.driver('waitFor', finderType='ByText', text='Подробности')
            machine.driver('waitFor', finderType='ByText', text='Расширение')
            if iteration == 0:
                result = machine.command('app.restart', {'appId': machine.app, 'fullRestart': False, 'pause': False})
                assert result.get('code') == 0, result
                machine.driver('waitFor', finderType='ByText', text='Подробности')
                result = machine.command('app.restart', {'appId': machine.app, 'fullRestart': True, 'pause': False})
                assert result.get('code') == 0, result
                machine.wait(lambda _: machine.ready >= 2, timeout=60)
                machine.driver('set_frame_sync', enabled='false')
        machine.key('tap', 'contributions-back')
        machine.driver('waitFor', finderType='ByText', text='Сводка')
        change('hide')
        machine.key('tap', 'contribution-details')
        machine.driver('waitFor', finderType='ByText', text='Расширение недоступно')
        change('restore')
        machine.driver('tap', finderType='ByText', text='Повторить')
        machine.key('tap', 'contribution-summary')
        machine.driver('waitFor', finderType='ByText', text='Расширение')
        change('logout')
        machine.key('tap', 'contributions-back')
        machine.driver('waitFor', finderType='ByText', text='Расширение недоступно')
        assert machine.command('app.stop', {'appId': machine.app}) is True
        assert machine.process.wait(timeout=30) == 0
    finally:
        machine.close()
(out / 'native-result.json').write_text(json.dumps({
    'overview_and_section_twice': 'passed', 'hot_reload': 'passed', 'hot_restart': 'passed',
    'acl_revoke_before_open': 'passed', 'restore_and_retry': 'passed', 'logout_before_list': 'passed',
    'transport': 'Connect / PostgreSQL / isolated WASM', 'platform': 'linux',
}) + '\n')
