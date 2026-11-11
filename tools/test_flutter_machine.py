"""Порядок готовности экрана и подключения Flutter daemon без запуска устройства."""
import queue
import unittest
from unittest.mock import Mock

from check_community_ui import FlutterMachine


class FlutterMachineTest(unittest.TestCase):
    def machine(self):
        machine = FlutterMachine.__new__(FlutterMachine)
        machine.app, machine.ready, machine.started_at = 'test-app', 1, None
        machine.messages = queue.Queue()
        machine.command = Mock(return_value={'isError': False})
        return machine

    def test_screen_ready_before_daemon_waits_for_started(self):
        machine = self.machine()
        machine.messages.put({'event': 'app.progress'})
        machine.messages.put({'event': 'app.started', 'params': {'appId': machine.app}})
        def dispatch(*args):
            self.assertIsNotNone(machine.started_at)
            return {'isError': False}
        machine.command.side_effect = dispatch
        machine.driver('get_health')
        machine.command.assert_called_once()
        self.assertTrue(machine.messages.empty())

    def test_connected_daemon_does_not_wait_for_another_event(self):
        machine = self.machine()
        machine._event({'event': 'app.started'})
        machine.driver('get_health')
        machine.command.assert_called_once()

    def test_closed_stream_never_sends_command(self):
        machine = self.machine()
        machine.messages.put(None)
        with self.assertRaisesRegex(RuntimeError, 'Поток Flutter закрылся'):
            machine.driver('get_health')
        machine.command.assert_not_called()

    def test_real_driver_failure_is_not_retried(self):
        machine = self.machine()
        machine._event({'event': 'app.started'})
        machine.command.return_value = {'isError': True}
        with self.assertRaises(RuntimeError):
            machine.driver('get_health')
        machine.command.assert_called_once()


if __name__ == '__main__':
    unittest.main()
