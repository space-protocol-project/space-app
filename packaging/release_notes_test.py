import runpy
import re
import unittest
from pathlib import Path

notes = runpy.run_path(str(Path(__file__).with_name("release-notes.py")))["release_notes"]


class ReleaseNotesTest(unittest.TestCase):
    def test_prepared_stable_app_has_release_notes(self):
        root = Path(__file__).resolve().parent.parent
        source = (root / "client/pubspec.yaml").read_text(encoding="utf-8")
        match = re.search(r"^version: ([^+\s]+)", source, re.MULTILINE)
        self.assertIsNotNone(match)
        tag = "v" + match.group(1)
        metadata = runpy.run_path(str(root / "packaging/release-notes.py"))["tag_info"](tag)
        if metadata["prerelease"]:
            self.skipTest("Разработка предварительной версии может использовать Unreleased")
        description = notes((root / "Changelog.md").read_text(encoding="utf-8"), tag)
        self.assertLessEqual(len(description.encode("utf-8")), 8192)

    def test_selects_exact_section_and_preserves_newlines(self):
        text = "# Изменения\n\n## v0.1.0 — дата\n\nПервый абзац.\n\n- Пункт\n\n## v0.2.0\n\nСервер.\n"
        self.assertEqual(notes(text, "v0.1.0"), "Первый абзац.\n\n- Пункт\n")
        self.assertEqual(notes(text, "v0.2.0"), "Сервер.\n")

    def test_missing_empty_duplicate_and_invalid_tags_fail(self):
        for text, tag in [("## v0.1.1\nДругой", "v0.1.0"), ("## v0.1.0\n", "v0.1.0"),
                          ("## v0.1.0\nПервый\n## v0.1.0\nВторой", "v0.1.0"), ("", "v../bad")]:
            with self.assertRaises(ValueError):
                notes(text, tag)

    def test_empty_duplicate_and_invalid_semver_fail(self):
        with self.assertRaises(ValueError):
            notes("## v0.3.0\n\n## v0.3.0\nЗаполненный раздел", "v0.3.0")
        for tag in ["v01.2.3", "v1.2.3-..", "v1.2.3-rc.01", "v1.2", "v1.2.3+build"]:
            with self.assertRaises(ValueError):
                notes("## " + tag + "\nПункт", tag)
        self.assertEqual(notes("## v0.3.0-rc.1\nПредварительный выпуск", "v0.3.0-rc.1"), "Предварительный выпуск\n")


if __name__ == "__main__":
    unittest.main()
