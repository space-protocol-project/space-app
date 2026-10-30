"""Запуск loopback-стенда с cgroup только в GitHub CI."""
import json
import base64
import os
from pathlib import Path
import secrets
import subprocess
import time
import urllib.request
import urllib.error

server = Path('.local/p1-server/experiments/extensions').resolve()
out = Path('.local/p1-demo').resolve()
out.mkdir(parents=True, exist_ok=True)
credentials = {'Editor':secrets.token_hex(32), 'Reader':secrets.token_hex(32)}
credential_file = out/'credentials.json'
credential_file.write_text(json.dumps(credentials))
credential_file.chmod(0o600)
address = out/'address'
root = '/sys/fs/cgroup/space-p1-demo'
subprocess.run(['sudo','mkdir',root],check=True)
subprocess.run(['sudo','sh','-c',f'echo "+memory +pids +cpu" > {root}/cgroup.subtree_control'],check=True)
log = (out/'server.log').open('w')
process = subprocess.Popen(['sudo','-n',str(server/'p1-demo'),'-cgroup',root,'-worker','/tmp/space-p1-demo-worker','-credentials',str(credential_file),'-address-file',str(address)],cwd=server,stdout=log,stderr=log)
checks=[]
# Контроль запуска под тем же непривилегированным UID, только доверенная echo-фикстура.
probe_input=b'{"abi":"space_plugin_p1","kind":"query","name":"overview","payload":{},"context":{"space_id":"space_demo"}}'
probe_wire={'protocol':'space.worker.p1','wasm':base64.b64encode((server/'testdata/echo.wasm').read_bytes()).decode(),'request':base64.b64encode(probe_input).decode(),'interpreter':False,'allow_wait':False}
probe=subprocess.run(['sudo','-u','nobody','/tmp/space-p1-demo-worker'],input=json.dumps(probe_wire).encode(),capture_output=True,timeout=5)
(out/'worker-probe.txt').write_text(f'exit={probe.returncode} stdout={probe.stdout!r} stderr={probe.stderr!r}\n')


def exchange(token, change=None, extra=None):
    body={'protocol':'space.dispatch.p1','instance':'demo','kind':'query','name':'overview','payload':{}}
    body.update(change or {})
    body.update(extra or {})
    request=urllib.request.Request(address.read_text(),data=json.dumps(body).encode(),headers={'Content-Type':'application/json','Authorization':'Bearer '+token})
    try:
        with urllib.request.urlopen(request,timeout=8) as response:
            return response.status,json.load(response)
    except urllib.error.HTTPError as error:
        return error.code,json.load(error)

try:
    assert probe.returncode==0 and probe.stdout==probe_input, 'Direct worker probe failed'
    deadline=time.monotonic()+20
    while not Path(str(address)+'.pid').exists():
        if process.poll() is not None or time.monotonic()>deadline: raise RuntimeError('Demo server did not become ready')
        time.sleep(.1)
    for name,token,change,status,code in [
        ('missing-grant','invalid',{},403,'permission_denied'),
        ('read-only',credentials['Reader'],{'kind':'command','name':'acknowledge'},403,'permission_denied'),
        ('version',credentials['Editor'],{'protocol':'v99'},409,'unsupported_version'),
        ('context-spoof',credentials['Editor'],{'context':{'principal_id':'admin'}},400,'invalid_request'),
        ('unknown-instance',credentials['Editor'],{'instance':'other'},403,'permission_denied'),
        ('worker-loop',credentials['Editor'],{'instance':'broken'},504,'deadline'),
    ]:
        actual,body=exchange(token,change)
        assert actual==status and body=={'code':code},(name,actual,body)
        checks.append({'case':name,'status':actual,'code':code})
    status,body=exchange(credentials['Editor'])
    assert status==200 and body['strings']['ru']['status']=='Готово к проверке'
    env=dict(os.environ,P1_DEMO_URL=address.read_text(),P1_DEMO_EDITOR=credentials['Editor'],P1_DEMO_READER=credentials['Reader'])
    with (out/'widget-tests.txt').open('w') as output:
        subprocess.run(['flutter','test','test/extensions_p1_test.dart','test/extensions_p1_live_test.dart','--reporter','expanded'],cwd='client',env=env,stdout=output,stderr=subprocess.STDOUT,check=True)
    subprocess.run(['xvfb-run','-a','python3','tools/check_extension_demo_ui.py'],env=env,check=True)
    (out/'results.json').write_text(json.dumps({'http_checks':checks,'healthy_after_fault':True,'flutter_widgets':'passed','native_restart':'passed'},indent=2)+'\n')
finally:
    pidfile=Path(str(address)+'.pid')
    if pidfile.exists() and process.poll() is None:
        subprocess.run(['sudo','kill','-TERM',pidfile.read_text().strip()],check=True)
    process.wait(timeout=15)
    log.close()
    credential_file.unlink(missing_ok=True)
    subprocess.run(['sudo','rmdir',root],check=True)
