import base64
from pathlib import Path
import runpy
import tempfile
import unittest

prepare = runpy.run_path(str(Path(__file__).with_name("prepare-android-signing.py")))["prepare"]


class AndroidSigningTest(unittest.TestCase):
    def test_missing_secrets_do_not_create_key_files(self):
        with tempfile.TemporaryDirectory() as root:
            with self.assertRaises(ValueError):
                prepare({}, Path(root))
            self.assertEqual(list(Path(root).iterdir()), [])

    def test_key_and_properties_are_written_without_output(self):
        secrets = {
            "SPACE_ANDROID_KEYSTORE": base64.b64encode(b"fixture").decode(),
            "SPACE_ANDROID_STORE_PASSWORD": "store-test",
            "SPACE_ANDROID_KEY_PASSWORD": "key-test",
            "SPACE_ANDROID_KEY_ALIAS": "space",
        }
        with tempfile.TemporaryDirectory() as root:
            prepare(secrets, Path(root))
            self.assertEqual((Path(root) / "space-release.jks").read_bytes(), b"fixture")
            self.assertIn("keyAlias=space\n", (Path(root) / "key.properties").read_text())
            secrets["SPACE_ANDROID_KEY_ALIAS"] = "space\nstoreFile=elsewhere"
            with self.assertRaises(ValueError):
                prepare(secrets, Path(root))
