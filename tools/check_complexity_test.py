"""Регрессии профиля: Flutter-коллекции, замыкания и отказ при неполном разборе."""

import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path

from check_complexity import analyze, default_tools, main, source_files, violations


class ComplexityProfileTest(unittest.TestCase):
    def measure(self, source):
        with tempfile.TemporaryDirectory(prefix="space-cognitive-fixture-") as temporary:
            path = Path(temporary) / "fixture.dart"
            path.write_text(source, encoding="utf-8")
            analyzer, runtime = default_tools()
            return analyze([path], analyzer, runtime)

    def test_collection_conditions_and_loops(self):
        report = self.measure("List<int> values(bool show, List<int> items) => [if(show) for(final n in items) if(n>0) n else -n];")
        self.assertEqual(report["entries"][0]["cognitive"], 7)

    def test_nested_callback_is_counted_inline(self):
        report = self.measure("void outer(bool a, bool b) { final callback = () { if(a) { if(b) print('x'); } }; callback(); }")
        self.assertEqual(len(report["entries"]), 1)
        self.assertGreaterEqual(report["entries"][0]["cognitive"], 3)

    def test_six_nested_conditions_fail_the_gate(self):
        report = self.measure("void deep(bool a) { if(a) { if(a) { if(a) { if(a) { if(a) { if(a) print('x'); } } } } } }")
        self.assertEqual(violations(report)[0]["cognitive"], 21)

    def test_top_level_getter(self):
        report = self.measure("int get value { if(true) return 1; return 0; }")
        self.assertEqual(report["entries"][0]["cognitive"], 1)

    def test_broken_dart_fails_instead_of_reporting_low_complexity(self):
        with self.assertRaisesRegex(ValueError, "Ошибки разбора"):
            self.measure("void broken( { if (")

    def test_empty_input_fails(self):
        analyzer, runtime = default_tools()
        with self.assertRaisesRegex(ValueError, "пустая проверка"):
            analyze([], analyzer, runtime)

    def test_no_functions_is_not_a_successful_check(self):
        with self.assertRaisesRegex(ValueError, "тела функций"):
            self.measure("export 'other.dart';")

    def test_command_fails_on_an_excessive_function(self):
        report = {"files": [{"path": "fixture.dart"}], "errors": [], "entries": [
            {"path": str(Path(__file__).resolve()), "name": "deep", "line": 1, "cognitive": 21},
        ]}
        with tempfile.TemporaryDirectory(prefix="space-cognitive-cli-") as temporary:
            destination = Path(temporary) / "report.json"
            with patch("check_complexity.analyze", return_value=report), patch("sys.argv", ["check", "--report", str(destination)]), patch("builtins.print"):
                self.assertEqual(main(), 1)
                self.assertTrue(destination.is_file())

    def test_source_scope_includes_own_packages_but_not_generated_or_vendor(self):
        with tempfile.TemporaryDirectory(prefix="space-cognitive-scope-") as temporary:
            root = Path(temporary)
            paths = ["client/lib/main.dart", "packages/admin/lib/panel.dart", "client/lib/generated/api.dart",
                     "client/lib/l10n/app_localizations.dart", "client/test/main_test.dart", "client/vendor/plugin/lib/main.dart"]
            for name in paths:
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("", encoding="utf-8")
            selected = [path.relative_to(root).as_posix() for path in source_files(root)]
            self.assertEqual(selected, ["client/lib/main.dart", "packages/admin/lib/panel.dart"])


if __name__ == "__main__":
    unittest.main()
