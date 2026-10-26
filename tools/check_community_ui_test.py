import io
import json
import queue
from types import SimpleNamespace
import unittest

from check_community_ui import FlutterMachine


class CommunityUiMachineTest(unittest.TestCase):
    def machine(self, lines):
        machine = FlutterMachine.__new__(FlutterMachine)
        machine.process = SimpleNamespace(stdout=io.StringIO(lines))
        machine.log = io.StringIO()
        machine.messages = queue.Queue()
        machine.app, machine.ready, machine.started_at = None, 0, None
        machine._read()
        return machine

    def drain(self, machine):
        while (message := machine.messages.get_nowait()) is not None:
            machine._event(message)

    def test_flutter_protocol_and_raw_application_output(self):
        lines = json.dumps([{'event': 'app.start', 'params': {'appId': 'probe'}}]) + '\n'
        lines += 'Building Linux application...\nflutter: COMMUNITY_UI_READY\n'
        machine = self.machine(lines)
        self.drain(machine)
        self.assertEqual(machine.app, 'probe')
        self.assertEqual(machine.ready, 1)

    def test_runtime_error_in_raw_output_fails(self):
        machine = self.machine('flutter: COMMUNITY_UI_ERROR: render failure\n')
        with self.assertRaisesRegex(RuntimeError, 'render failure'):
            self.drain(machine)

    def test_marker_in_structured_output_is_counted_once(self):
        machine = self.machine(json.dumps([{'event': 'app.log', 'params': {'log': 'COMMUNITY_UI_READY'}}]) + '\n')
        self.drain(machine)
        self.assertEqual(machine.ready, 1)


if __name__ == '__main__':
    unittest.main()
