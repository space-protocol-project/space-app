"""Проверка установленного приложения в отдельной D-Bus-сессии и HOME."""
import json
import os
from pathlib import Path
import shutil
import signal
import subprocess
import sys
import tempfile
import threading
import time

APP = 'org.spaceprotocol.space_client'
OBJECT = '/org/spaceprotocol/space_client'


def wait_for(condition, label, seconds=45):
    end = time.monotonic() + seconds
    while time.monotonic() < end:
        if condition():
            return
        time.sleep(0.1)
    raise AssertionError('Не дождались: ' + label)


def lines(path):
    return path.read_text().splitlines() if path.exists() else []


def outer(installer, bundle):
    with tempfile.TemporaryDirectory(prefix='space-notification-') as temp:
        root = Path(temp)
        home = root / 'home with space'
        home.mkdir()
        probe = root / 'probe'
        probe.mkdir()
        (probe / 'seed').write_text('seed')
        env = dict(os.environ, HOME=str(home),
                   XDG_DATA_HOME=str(home / '.local/share'),
                   XDG_CONFIG_HOME=str(home / '.config'),
                   XDG_CACHE_HOME=str(home / '.cache'),
                   GDK_BACKEND='x11', LIBGL_ALWAYS_SOFTWARE='1',
                   SPACE_NOTIFICATION_PROBE_DIR=str(probe))
        subprocess.run([str(installer.resolve())], env=env, check=True)
        executable = home / '.local/opt/space/space_client'
        desktop = home / f'.local/share/applications/{APP}.desktop'
        service = home / f'.local/share/dbus-1/services/{APP}.service'
        assert 'DBusActivatable=true' in desktop.read_text()
        assert '--gapplication-service' in service.read_text()
        shutil.copytree(bundle, executable.parent, dirs_exist_ok=True)
        result = subprocess.run(['xvfb-run', '-a', 'dbus-run-session', '--',
                                 sys.executable, __file__, '--inside', str(root)], env=env)
        if result.returncode:
            log = probe / 'application.log'
            if log.exists():
                print(log.read_text(errors='replace'))
            raise SystemExit(result.returncode)


def inside(root):
    import gi
    gi.require_version('Gio', '2.0')
    from gi.repository import Gio, GLib

    probe = root / 'probe'
    executable = root / 'home with space/.local/opt/space/space_client'
    bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
    notices = {}
    node = Gio.DBusNodeInfo.new_for_xml('''<node><interface name="org.gtk.Notifications">
      <method name="AddNotification"><arg type="s" direction="in"/>
        <arg type="s" direction="in"/><arg type="a{sv}" direction="in"/></method>
      <method name="RemoveNotification"><arg type="s" direction="in"/>
        <arg type="s" direction="in"/></method></interface></node>''')

    def handle(_bus, _sender, _path, _interface, method, parameters, invocation):
        args = parameters.unpack()
        assert args[0] == APP
        if method == 'AddNotification':
            notices[args[1]] = args[2]
        else:
            notices.pop(args[1], None)
        invocation.return_value(GLib.Variant('()', ()))

    registration = bus.register_object('/org/gtk/Notifications', node.interfaces[0], handle, None, None)
    request = bus.call_sync('org.freedesktop.DBus', '/org/freedesktop/DBus',
                            'org.freedesktop.DBus', 'RequestName',
                            GLib.Variant('(su)', ('org.gtk.Notifications', 0)),
                            None, Gio.DBusCallFlags.NONE, 5000, None)
    assert request.unpack()[0] == 1
    loop = GLib.MainLoop()
    thread = threading.Thread(target=loop.run, daemon=True)
    thread.start()

    def activate(token):
        bus.call_sync(APP, OBJECT, 'org.gtk.Actions', 'Activate',
                      GLib.Variant('(sava{sv})', ('open-notification',
                                   [GLib.Variant('s', token)], {})),
                      None, Gio.DBusCallFlags.NONE, 45000, None)

    def owns_name():
        return bus.call_sync('org.freedesktop.DBus', '/org/freedesktop/DBus',
                             'org.freedesktop.DBus', 'NameHasOwner',
                             GLib.Variant('(s)', (APP,)), None,
                             Gio.DBusCallFlags.NONE, 5000, None).unpack()[0]

    def events():
        return [json.loads(line) for line in lines(probe / 'events')]

    try:
        with (probe / 'application.log').open('w') as log:
            first = subprocess.Popen([str(executable)], stdout=log, stderr=subprocess.STDOUT)
            wait_for(lambda: len(lines(probe / 'boots')) == 1, 'первый процесс')
            wait_for(lambda: len(notices) == 2, 'две системные карточки')
            tokens = json.loads((probe / 'tokens').read_text())
            for index, token in enumerate(tokens, 1):
                notice = notices[f'space-{index}']
                assert notice['default-action'] == 'app.open-notification'
                assert notice['default-action-target'] == token
                assert 'fixture.invalid' not in json.dumps(notice)
                assert notice['title'] == 'Space'
                assert notice['body'] == 'Новое сообщение'
            activate('invalid')
            assert not events()
            activate(tokens[0])
            wait_for(lambda: len(events()) == 1, 'нажатие в работающем процессе')
            assert first.wait(timeout=15) == 0
            wait_for(lambda: not owns_name(), 'завершение первого процесса')
            # Запускается исключительно D-Bus service из установленного пакета.
            activate(tokens[1])
            wait_for(lambda: len(events()) == 2, 'запуск закрытого приложения')
            wait_for(lambda: not owns_name(), 'завершение второго процесса')
            assert events()[0]['pid'] != events()[1]['pid']
            assert [event['payload'][3] for event in events()] == [1, 2]
            activate(tokens[1])
            wait_for(lambda: len(lines(probe / 'boots')) == 3, 'повтор использованного ключа')
            time.sleep(0.5)
            assert len(events()) == 2
            print('Linux: карточки, приватность, нажатие, D-Bus-запуск и защита от повтора проверены.')
    finally:
        for value in lines(probe / 'boots'):
            process = int(value)
            try:
                if Path(f'/proc/{process}/exe').resolve() == executable.resolve():
                    os.kill(process, signal.SIGTERM)
            except ProcessLookupError:
                pass
        loop.quit()
        thread.join(timeout=5)
        bus.unregister_object(registration)


if __name__ == '__main__':
    if sys.platform != 'linux':
        raise SystemExit('Проверка запускается только на Linux')
    if len(sys.argv) == 3 and sys.argv[1] == '--inside':
        inside(Path(sys.argv[2]))
    elif len(sys.argv) == 3:
        outer(Path(sys.argv[1]), Path(sys.argv[2]))
    else:
        raise SystemExit('Нужны установщик .run и каталог проверочного bundle')
