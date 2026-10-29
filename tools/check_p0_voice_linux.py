"""Два настоящих Flutter/WebRTC процесса с управляемым PCM-источником CI."""
import argparse
from array import array
import json
import math
import os
from pathlib import Path
import platform
import subprocess
import time
import uuid
import wave

from check_community_interop import free_ports, ready, stop


def wait_files(work, names, workers, timeout=90):
    deadline = time.monotonic() + timeout
    while not all((work / name).exists() for name in names):
        if any(p.poll() is not None for p in workers):
            raise RuntimeError(f'Клиент завершился до {names}; см. {work}')
        if time.monotonic() > deadline:
            raise TimeoutError(f'Нет {names}; см. {work}')
        time.sleep(.1)


def tone(path):
    # 300 секунд PCM, без микрофона пользователя и без сохранения принятого звука.
    second = array('h', (int(6000 * math.sin(2 * math.pi * 440 * i / 48000)) for i in range(48000)))
    with wave.open(str(path), 'wb') as output:
        output.setparams((1, 2, 48000, 0, 'NONE', 'not compressed'))
        for _ in range(300):
            output.writeframesraw(second.tobytes())


def measure(args, round_number):
    work = args.output / f'voice-check-{uuid.uuid4().hex}'
    work.mkdir()
    database = f'p0_voice_{round_number}'
    subprocess.run(['createdb', '-h', '127.0.0.1', '-U', 'space', database], check=True)
    http, grpc = free_ports()
    origin = f'http://127.0.0.1:{http}'
    env = dict(os.environ, SPACE_DATABASE_URL=f'postgres://space:ci-only-password@127.0.0.1:5432/{database}?sslmode=disable',
               SPACE_VOICE_TURN_CHECK='1', SPACE_VOICE_DESKTOP_CHECK='1', SPACE_VOICE_RECOVERY_CHECK='1', SPACE_VOICE_PCM_CHECK='1')
    for key in ('SPACE_SETUP_CODE', 'SPACE_VOICE_STUN_URLS', 'SPACE_VOICE_PUBLIC_IP', 'SPACE_VOICE_UDP_MIN', 'SPACE_VOICE_UDP_MAX', 'SPACE_VOICE_TURN_SECRET_FILE'):
        env.pop(key, None)
    workers, logs = [], []
    server = turn = source = None

    def launch(command, name, environment=env, stdin=None):
        log = (work / f'{name}.log').open('w', encoding='utf-8')
        logs.append(log)
        return subprocess.Popen(command, env=environment, stdin=stdin, stdout=log, stderr=log)

    command = [str(args.server), '-http', f'127.0.0.1:{http}', '-grpc', f'127.0.0.1:{grpc}', '-managed']
    try:
        (work / 'baseline.json').write_text(json.dumps({'round': round_number, 'platform': platform.platform(),
            'relay': 'tcp', 'recovery': True, 'audio': 'PulseAudio remapped input and separate output sink, PCM 48 kHz sine 440 Hz; studio profile, fixed gate -60 dB; received energy must increase',
            'app': subprocess.check_output(['git', 'rev-parse', 'HEAD'], text=True).strip(),
            'server': subprocess.check_output(['git', '-C', 'server-source', 'rev-parse', 'HEAD'], text=True).strip()}))
        turn = launch([str(args.turn), str(work)], 'turn')
        wait_files(work, ['turn.json'], [turn], 10)
        config = json.loads((work / 'turn.json').read_text())
        env.update(SPACE_VOICE_TURN_URLS=config['tcp'], SPACE_VOICE_TURN_SECRET=config['secret'], SPACE_VOICE_RELAY_ONLY='true')
        server = launch(command, 'server', stdin=subprocess.PIPE)
        ready(server, origin)
        source = launch(['paplay', '--device=p0', str(args.output / 'tone.wav')], 'pcm')
        for role in ('A', 'B'):
            client_env = dict(env, SPACE_VOICE_ORIGIN=origin, SPACE_VOICE_WORK=str(work), SPACE_VOICE_ROLE=role)
            workers.append(launch(['dbus-run-session', '--', str(args.client)], role, client_env))
            if role == 'A':
                wait_files(work, ['room'], workers, 40)
        wait_files(work, ['A-recovery-ready', 'B-recovery-ready'], workers)
        server.kill()
        server.wait(timeout=10)
        server = None
        wait_files(work, ['A-reconnecting', 'B-reconnecting'], workers)
        server = launch(command, 'server-restarted', stdin=subprocess.PIPE)
        ready(server, origin)
        for worker in workers:
            if worker.wait(timeout=120):
                raise RuntimeError(f'Ошибка Flutter; см. {work}')
        reports = [json.loads((work / f'{role}.json').read_text()) for role in ('A', 'B')]
        if not all(r['success'] and r['reconnected'] for r in reports) or reports[0]['pid'] == reports[1]['pid']:
            raise RuntimeError('Два клиента и восстановление не подтверждены')
        print(json.dumps(reports), flush=True)
    finally:
        for worker in workers:
            if worker.poll() is None:
                worker.terminate()
                worker.wait(timeout=10)
        if source and source.poll() is None:
            source.terminate()
            source.wait(timeout=10)
        if turn and turn.poll() is None:
            (work / 'turn.stop').write_text('stop')
            turn.wait(timeout=10)
        stop(server)
        for log in logs:
            log.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ('server', 'turn', 'client', 'output'):
        parser.add_argument('--' + name, type=Path, required=True)
    args = parser.parse_args()
    for name in ('server', 'turn', 'client', 'output'):
        setattr(args, name, getattr(args, name).resolve())
    args.output.mkdir(parents=True)
    tone(args.output / 'tone.wav')
    for round_number in range(4):
        measure(args, round_number)


if __name__ == '__main__':
    main()
