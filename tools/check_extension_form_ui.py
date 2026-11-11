"""Нативная форма: ввод, команда через WASM, hot reload и горячий перезапуск."""
import json
import os
from pathlib import Path
from check_community_ui import FlutterMachine

out=Path('.local/p1-form')
out.mkdir(parents=True,exist_ok=True)
with (out/'native-ui.log').open('w',encoding='utf-8') as log:
    machine=FlutterMachine(Path('client'),log,'test/probes/extension_demo_probe.dart',device='windows' if os.name=='nt' else 'linux')
    try:
        machine.wait(lambda _:machine.app is not None and machine.ready>=1)
        for iteration in range(2):
            machine.driver('set_frame_sync',enabled='false')
            machine.driver('waitFor',finderType='ByText',text='Отправить')
            machine.key('tap','form.submit')
            machine.driver('waitFor',finderType='ByText',text='Проверьте поля формы')
            machine.driver('tap',finderType='ByType',type='TextFormField')
            machine.driver('enter_text',text='Привет из CI')
            machine.key('tap','form-field-kind')
            machine.driver('tap',finderType='ByText',text='Первый')
            machine.key('tap','form-field-enabled')
            machine.key('tap','form.submit')
            machine.driver('waitFor',finderType='ByText',text='Отправлено')
            if iteration==0:
                result=machine.command('app.restart',{'appId':machine.app,'fullRestart':False,'pause':False})
                assert result.get('code')==0,result
                machine.driver('waitFor',finderType='ByText',text='Отправлено')
                result=machine.command('app.restart',{'appId':machine.app,'fullRestart':True,'pause':False})
                assert result.get('code')==0,result
                machine.wait(lambda _:machine.ready>=2,timeout=60)
        assert machine.command('app.stop',{'appId':machine.app}) is True
        assert machine.process.wait(timeout=30)==0
    finally:
        machine.close()
(out/'native-result.json').write_text(json.dumps({'form_submit_twice_after_restart':'passed','hot_reload':'passed','hot_restart':'passed','transport':'HTTP to isolated WASM','platform':os.name})+'\n')
