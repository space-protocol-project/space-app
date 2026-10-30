"""Нативный Linux: реальный WASM, кнопка и горячий перезапуск через Flutter machine."""
import json
from pathlib import Path
from check_community_ui import FlutterMachine

out = Path('.local/p1-demo-native')
out.mkdir(parents=True, exist_ok=True)
with (out/'native-ui.log').open('w', encoding='utf-8') as log:
    machine = FlutterMachine(Path('client'), log, 'test/probes/extension_demo_probe.dart')
    try:
        machine.wait(lambda _: machine.app is not None and machine.ready >= 1)
        machine.driver('set_frame_sync', enabled='false')
        for count in [1, 2]:
            machine.driver('waitFor', finderType='ByText', text='Готово к проверке')
            machine.driver('tap', finderType='ByText', text='Выполнить команду')
            machine.driver('waitFor', finderType='ByText', text='Команда выполнена')
            if count == 1:
                result = machine.command('app.restart', {'appId':machine.app, 'fullRestart':True, 'pause':False})
                assert result.get('code') == 0, result
                machine.wait(lambda _: machine.ready >= 2, timeout=60)
                machine.driver('set_frame_sync', enabled='false')
        assert machine.command('app.stop', {'appId':machine.app}) is True
        assert machine.process.wait(timeout=30) == 0
    finally:
        machine.close()
(out/'result.json').write_text(json.dumps({'query_command_query_after_restart':'passed', 'hot_restart':'passed', 'transport':'HTTP to isolated WASM worker'})+'\n')
