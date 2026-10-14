"""Повторяемый аудит сложности без установки или загрузки зависимостей."""

import argparse
import json
import subprocess
import tempfile
from pathlib import Path

LANGUAGES = {".dart": "dart", ".go": "go", ".py": "python", ".js": "javascript", ".mjs": "javascript", ".cjs": "javascript"}


def category(path):
    parts = path.parts
    if "vendor" in parts:
        return "vendor"
    if "generated" in parts or "gen" in parts or "generated_" in path.name or path.name.startswith("app_localizations") or ".g." in path.name:
        return "generated"
    if "test" in parts or path.name.endswith(("_test.go", "_test.py")):
        return "test"
    if parts[0] in ("tools", "tool", "packaging", "scripts") or "tool" in parts:
        return "tool"
    if "design" in parts:
        return "prototype"
    return "production"


def inventory(root):
    result = subprocess.run(["git", "ls-files", "--cached", "--others", "--exclude-standard"], cwd=root, capture_output=True, text=True, check=True)
    return sorted({Path(name) for name in result.stdout.splitlines() if (root / name).is_file()})


def analyze(root, paths, language, analyzer, nvim):
    with tempfile.TemporaryDirectory(prefix="space-complexity-") as temporary:
        listing = Path(temporary) / "files.txt"
        listing.write_text("\n".join(str(root / path) for path in paths), encoding="utf-8")
        result = subprocess.run([nvim, "--headless", "-l", str(analyzer / "scripts/dump-complexity.lua"), language, str(listing), "inline"], capture_output=True, text=True, encoding="utf-8", check=True)
    rows = []
    for line in result.stdout.splitlines():
        absolute, row, cc, cog, name = line.split("\t", 4)
        relative = Path(absolute).relative_to(root)
        rows.append({"path": relative.as_posix(), "line": int(row), "cc": int(cc), "cog": int(cog), "name": name, "category": category(relative)})
    return rows


def audit(root, analyzer, nvim):
    paths = inventory(root)
    rows = []
    for language in sorted(set(LANGUAGES.values())):
        selected = [path for path in paths if LANGUAGES.get(path.suffix) == language]
        if selected:
            rows.extend(analyze(root, selected, language, analyzer, nvim))
    return {"files": [{"path": path.as_posix(), "category": category(path), "measured": path.suffix in LANGUAGES} for path in paths], "functions": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--analyzer", type=Path, required=True)
    parser.add_argument("--app", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--server", type=Path, required=True)
    parser.add_argument("--nvim", default="nvim")
    parser.add_argument("--output", type=Path, required=True)
    options = parser.parse_args()
    report = {"mode": "inline", "repositories": {}}
    for name, root in (("app", options.app), ("server", options.server)):
        report["repositories"][name] = audit(root.resolve(), options.analyzer.resolve(), options.nvim)
    options.output.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
