"""Настоящий установщик и карточки уведомлений на отдельном Windows runner."""
import ctypes
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import uuid
import winreg

import psutil
from pywinauto import Desktop, keyboard
import win32gui
import win32process


def wait(check, label, timeout=90):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        error = read('error')
        if error:
            raise AssertionError(error)
        result = check()
        if result:
            return result
        time.sleep(.2)
    raise AssertionError('Timeout: ' + label)


def read(name):
    try:
        return json.loads((root / (name + '.json')).read_text(encoding='utf-8'))
    except (FileNotFoundError, PermissionError, json.JSONDecodeError):
        return {}


def command(action):
    request = {'id': uuid.uuid4().hex, 'action': action}
    pending = root / 'command.pending'
    pending.write_text(json.dumps(request), encoding='utf-8')
    pending.replace(root / 'command.json')
    return wait(lambda: (r if (r := read('reply')).get('id') == request['id'] else None), action)


def foreground(pid):
    window = win32gui.GetForegroundWindow()
    return win32process.GetWindowThreadProcessId(window)[1] == pid and not win32gui.IsIconic(window)


def active(old_pid=None, same=False):
    def ready():
        state = read('state')
        pid = state.get('pid')
        if not pid or state.get('lifecycle') != 'resumed' or state.get('state') != 'locked':
            return None
        if old_pid and ((pid == old_pid) != same):
            return None
        if state.get('pending_targets') != 0 or not foreground(pid):
            return None
        return state
    return wait(ready, 'foreground, locked profile, consumed token')


def wizard():
    process = subprocess.Popen([str(installer), '/SP-', '/LANG=english', '/NOICONS', '/TASKS=', '/DIR=' + str(install), '/LOG=' + str(root / 'install.log')])
    deadline = time.monotonic() + 180
    clicked = []
    while time.monotonic() < deadline and process.poll() is None:
        for window in Desktop(backend='win32').windows(class_name='TWizardForm'):
            for button in window.children(class_name='TNewButton'):
                title = button.window_text().replace('&', '').strip()
                if title not in ('Next >', 'Install', 'Finish') or not button.is_visible() or not button.is_enabled():
                    continue
                button.click_input()
                clicked.append(title)
                time.sleep(.5)
                break
        time.sleep(.2)
    assert process.wait(timeout=10) == 0, 'installer failed'
    assert 'Install' in clicked and 'Finish' in clicked, clicked
    return clicked


def click_toast(title):
    deadline = time.monotonic() + 45
    opened = False
    while time.monotonic() < deadline:
        for window in Desktop(backend='uia').windows():
            try:
                process = psutil.Process(window.process_id()).name().lower()
                if process not in ('shellexperiencehost.exe', 'explorer.exe'):
                    continue
                for control in window.descendants(control_type='Text'):
                    if control.window_text() == title and control.is_visible():
                        control.click_input()
                        return {'process': process, 'title': title}
            except (psutil.NoSuchProcess, RuntimeError):
                continue
        if not opened:
            keyboard.send_keys('#n')
            opened = True
        time.sleep(.3)
    raise AssertionError('Native notification not found: ' + title)


def stop(pid):
    wait(lambda: not psutil.pid_exists(pid), 'process exit')


def run():
    assert os.environ.get('GITHUB_ACTIONS') == 'true' and os.name == 'nt'
    for key in (r'Software\Classes\space-notification', r'Software\Microsoft\Windows\CurrentVersion\Uninstall\{A1D164D7-8CE9-4FF1-98B7-3D9970218441}_is1'):
        try:
            with winreg.OpenKey(winreg.HKEY_CURRENT_USER, key):
                raise AssertionError('Runner already contains Space registration')
        except FileNotFoundError:
            pass
    root.mkdir(parents=True)
    install.mkdir()
    (install / 'launch-ci.json').write_text(json.dumps({'root': str(root)}), encoding='utf-8')
    report = {'wizard': wizard()}
    initial = active()
    report['installer'] = initial
    assert command('unlock')['state'] == 'unlocked'
    old_pid = initial['pid']
    toast = command('toast-warm')
    assert toast['state'] == 'locked'
    report['warm_click'] = click_toast('Space launch ' + toast['id'])
    report['warm'] = active(old_pid, same=True)
    assert command('unlock')['state'] == 'unlocked'
    toast = command('toast-cold')
    stop(old_pid)
    report['cold_click'] = click_toast('Space launch ' + toast['id'])
    report['cold'] = active(old_pid)
    assert command('unlock')['state'] == 'unlocked'
    command('maximize')
    duplicate = subprocess.run([str(install / 'space_client.exe')], timeout=30)
    assert duplicate.returncode == 0
    assert foreground(report['cold']['pid'])
    assert ctypes.windll.user32.IsZoomed(win32gui.GetForegroundWindow())
    report['maximized_preserved'] = True
    current = command('quit')['pid']
    stop(current)
    subprocess.run([str(installer), '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/NOICONS', '/TASKS=', '/RELAUNCH', '/DIR=' + str(install)], check=True, timeout=180)
    report['relaunch'] = active(current)
    assert command('unlock')['state'] == 'unlocked'
    report['explicit_unlocks'] = 4
    report['wrong_password_rejected'] = True
    final_pid = command('quit')['pid']
    stop(final_pid)
    (root / 'report.json').write_text(json.dumps(report, indent=2), encoding='utf-8')


if __name__ == '__main__':
    installer = Path(sys.argv[1]).resolve(strict=True)
    root = Path(os.environ['RUNNER_TEMP']) / ('space-launch-' + uuid.uuid4().hex)
    install = root / 'Installed Space'
    try:
        run()
    finally:
        output = Path('launch-results')
        output.mkdir(exist_ok=True)
        if not (root / 'report.json').exists():
            # Диагностика только отдельного рабочего стола CI.
            Desktop(backend='win32').window(handle=win32gui.GetDesktopWindow()).capture_as_image().save(output / 'failure.png')
            details = []
            for window in Desktop(backend='uia').windows():
                try:
                    details.append({'title': window.window_text(), 'pid': window.process_id(), 'texts': [c.window_text() for c in window.descendants(control_type='Text')]})
                except Exception as error:
                    details.append({'error': str(error)})
            (output / 'desktop.json').write_text(json.dumps(details, ensure_ascii=False), encoding='utf-8')
        for name in ('report.json', 'error.json', 'boot.json', 'state.json', 'install.log'):
            if (root / name).exists():
                (output / name).write_bytes((root / name).read_bytes())
        # Завершаем только процессы из созданного каталога стенда.
        for process in psutil.process_iter(['exe']):
            if process.info['exe'] and Path(process.info['exe']).parent == install:
                process.kill()
                process.wait(timeout=15)
        uninstaller = install / 'unins000.exe'
        if uninstaller.exists():
            subprocess.run([str(uninstaller), '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART'], check=True, timeout=90)
