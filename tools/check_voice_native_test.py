"""Проверка CLI в кодировке консоли Windows CI."""
import os
from pathlib import Path
import subprocess
import sys
import unittest


class VoiceNativeConsoleTest(unittest.TestCase):
    def test_legacy_console_encoding(self):
        script = Path(__file__).with_name('check_voice_native.py')
        result = subprocess.run(
            [sys.executable, str(script)],
            env={**os.environ, 'PYTHONIOENCODING': 'cp1252'},
            capture_output=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr.decode('utf-8', errors='replace'))
        self.assertIn('DeepFilterNet3 проверены', result.stdout.decode('utf-8'))


if __name__ == '__main__':
    unittest.main()
