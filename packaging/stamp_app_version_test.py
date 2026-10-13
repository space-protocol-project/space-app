from pathlib import Path
import runpy
import unittest

stamp = runpy.run_path(str(Path(__file__).with_name("stamp-app-version.py")))["stamp"]


class StampVersionTest(unittest.TestCase):
    def test_tag_version_preserves_build_number_and_other_fields(self):
        source = "name: space_client\nversion: 0.2.0+2\ndependencies:\n  flutter:\n    sdk: flutter\n"
        self.assertEqual(stamp(source, "v0.3.0-rc.1"), source.replace("0.2.0+2", "0.3.0-rc.1+2"))

    def test_invalid_tag_or_missing_version_fails(self):
        with self.assertRaises(ValueError):
            stamp("version: 0.2.0", "main")
        with self.assertRaises(ValueError):
            stamp("name: space_client", "v0.3.0")


if __name__ == "__main__":
    unittest.main()
