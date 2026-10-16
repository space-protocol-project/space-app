"""Проверить весь рукописный Dart приложения; предел COG 15, без исключений функций."""

import argparse
import json
import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIMIT = 15
ANALYZER_COMMIT = "7b216f2344d87a910e6c1ffbd974fe60950c15ce"
PARSER_COMMIT = "be07cf7118d3dba06236a3f19541685a68209934"


def source_files(root):
    roots = [root / "client/lib", *sorted((root / "packages").glob("*/lib"))]
    return sorted(path for directory in roots for path in directory.rglob("*.dart") if handwritten(path))


def handwritten(path):
    if "generated" in path.parts or "vendor" in path.parts:
        return False
    return "localizations" not in path.name and not path.name.endswith(".g.dart")


def default_tools():
    prepared = ROOT / ".local/complexity/analyzer"
    if prepared.exists():
        return prepared, ROOT / ".local/complexity/parsers"
    previous = ROOT / ".local/network/complexity-analyzer"
    return previous, previous / ".ci/parsers"


def analyze(paths, analyzer, parser_runtime, nvim="nvim"):
    if not paths:
        raise ValueError("Не найдены исходники Dart: пустая проверка запрещена")
    with tempfile.TemporaryDirectory(prefix="space-cognitive-") as temporary:
        listing = Path(temporary) / "files.txt"
        listing.write_text("\n".join(path.resolve().as_posix() for path in paths) + "\n", encoding="utf-8")
        result = subprocess.run([
            nvim, "--headless", "-u", "NONE", "-l", str(ROOT / "tools/complexity/check.lua"),
            str(analyzer.resolve()), str(parser_runtime.resolve()),
            str(ROOT / "tools/complexity/dart.scm"), str(listing),
        ], capture_output=True, text=True, encoding="utf-8", check=True, timeout=120)
    report = json.loads(result.stdout)
    if len(report["files"]) != len(paths):
        raise ValueError("Анализатор пропустил исходники")
    if report["errors"]:
        raise ValueError(f"Ошибки разбора Dart, оценка неполная: {report['errors']}")
    if not report["entries"]:
        raise ValueError("Анализатор не нашёл тела функций: пустая оценка запрещена")
    return report


def violations(report):
    return sorted((entry for entry in report["entries"] if entry["cognitive"] > LIMIT),
                  key=lambda entry: (-entry["cognitive"], entry["path"], entry["line"]))


def main():
    analyzer, parser_runtime = default_tools()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--analyzer", type=Path, default=analyzer)
    parser.add_argument("--parser-runtime", type=Path, default=parser_runtime)
    parser.add_argument("--nvim", default="nvim")
    parser.add_argument("--report", type=Path, default=ROOT / ".local/complexity/report.json")
    options = parser.parse_args()
    report = analyze(source_files(ROOT), options.analyzer, options.parser_runtime, options.nvim)
    for entry in report["entries"]:
        entry["path"] = Path(entry["path"]).relative_to(ROOT).as_posix()
    report["limit"] = LIMIT
    report["profile"] = "inline; collection if/for; no recursion resolution"
    options.report.parent.mkdir(parents=True, exist_ok=True)
    options.report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    failed = violations(report)
    for entry in failed:
        print(f"{entry['path']}:{entry['line']} {entry['name']}: COG {entry['cognitive']} > {LIMIT}")
    maximum = max((entry["cognitive"] for entry in report["entries"]), default=0)
    print(f"Файлов: {len(report['files'])}; функций: {len(report['entries'])}; максимум COG: {maximum}; превышений: {len(failed)}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
