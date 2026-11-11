"""Временные loopback-учётные данные и изолированный WASM только в CI."""
import json
import os
from pathlib import Path
import secrets
import subprocess
import sys
import time
import urllib.error
import urllib.request

server=Path('.local/p1-server/experiments/extensions').resolve()
out=Path('.local/p1-form').resolve()
out.mkdir(parents=True,exist_ok=True)
windows=os.name=='nt'
suffix='.exe' if windows else ''
root=str(out/'worker-root') if windows else '/sys/fs/cgroup/space-p1-form'
if windows:
    Path(root).mkdir(exist_ok=True)
else:
    subprocess.run(['sudo','mkdir',root],check=True)
    subprocess.run(['sudo','sh','-c',f'echo "+memory +pids +cpu" > {root}/cgroup.subtree_control'],check=True)
tokens={'Editor':secrets.token_hex(32),'Reader':secrets.token_hex(32)}
credential=out/'credentials.json'
credential.write_text(json.dumps(tokens));credential.chmod(0o600)
address=out/'address'
address.unlink(missing_ok=True)
worker=str(server/('p1-worker'+suffix)) if windows else '/tmp/space-p1-form-worker'
command=[str(server/('p1-demo'+suffix)),'-form','-cgroup',root,'-worker',worker,'-credentials',str(credential),'-address-file',str(address)]
log=(out/'server.log').open('w',encoding='utf-8')
process=subprocess.Popen(command if windows else ['sudo','-n',*command],cwd=server,stdout=log,stderr=log)
checks=[]

def exchange(token,payload,kind='command',name='acknowledge'):
    body={'protocol':'space.dispatch.p1','instance':'demo','kind':kind,'name':name,'payload':payload}
    request=urllib.request.Request(address.read_text(),data=json.dumps(body).encode(),headers={'Content-Type':'application/json','Authorization':'Bearer '+token})
    try:
        with urllib.request.urlopen(request,timeout=8) as response:return response.status,json.load(response)
    except urllib.error.HTTPError as error:return error.code,json.load(error)

try:
    deadline=time.monotonic()+30
    while not address.exists():
        if process.poll() is not None or time.monotonic()>deadline:raise RuntimeError('Стенд не запустился')
        time.sleep(.1)
    payload={'message':'Привет 😀','kind':'a','enabled':True}
    for name,token,data,expected in [
        ('missing-fields',tokens['Editor'],{},400),
        ('spoofed-context',tokens['Editor'],dict(payload,principal_id='admin'),400),
        ('wrong-type',tokens['Editor'],dict(payload,enabled='true'),400),
        ('reader-denied',tokens['Reader'],payload,403),
        ('unknown-session','invalid',payload,403),
        ('valid',tokens['Editor'],payload,200),
    ]:
        status,body=exchange(token,data)
        assert status==expected,(name,status,body)
        checks.append({'case':name,'status':status})
    env=dict(os.environ,P1_DEMO_URL=address.read_text(),P1_DEMO_EDITOR=tokens['Editor'])
    command=[sys.executable,'tools/check_extension_form_ui.py']
    subprocess.run(command if windows else ['xvfb-run','-a',*command],env=env,check=True)
    (out/'http-results.json').write_text(json.dumps(checks,indent=2)+'\n')
finally:
    if process.poll() is None:
        if windows:process.terminate()
        else:
            pid=Path(str(address)+'.pid').read_text().strip()
            subprocess.run(['sudo','kill','-TERM',pid],check=True)
    process.wait(timeout=20)
    log.close();credential.unlink(missing_ok=True)
    if not windows:subprocess.run(['sudo','rmdir',root],check=True)
