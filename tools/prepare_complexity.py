"""Подготовить закреплённый анализатор и Dart-парсер для Linux/macOS CI."""

import argparse
import platform
import subprocess
from pathlib import Path

from check_complexity import ANALYZER_COMMIT, PARSER_COMMIT, ROOT


def checkout(directory, repository, commit):
    if not directory.exists():
        subprocess.run(["git", "init", str(directory)], check=True)
        subprocess.run(["git", "-C", str(directory), "fetch", "--depth=1", repository, commit], check=True)
        subprocess.run(["git", "-C", str(directory), "checkout", "--detach", "FETCH_HEAD"], check=True)
    actual = subprocess.check_output(["git", "-C", str(directory), "rev-parse", "HEAD"], text=True).strip()
    dirty = subprocess.check_output(["git", "-C", str(directory), "status", "--porcelain"], text=True).strip()
    if actual != commit or dirty:
        raise ValueError(f"Нужны неизменённые исходники {repository} на {commit}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--directory", type=Path, default=ROOT / ".local/complexity")
    options = parser.parse_args()
    if platform.system() not in ("Linux", "Darwin"):
        raise SystemExit("В Windows укажите --analyzer и --parser-runtime для уже собранного Dart-парсера. См. docs/READABILITY.md")
    directory = options.directory.resolve()
    directory.mkdir(parents=True, exist_ok=True)
    checkout(directory / "analyzer", "https://github.com/Hecatoncheir/treesitter_cyclomatic_complexity", ANALYZER_COMMIT)
    checkout(directory / "dart", "https://github.com/UserNobody14/tree-sitter-dart", PARSER_COMMIT)
    output = directory / "parsers/parser"
    output.mkdir(parents=True, exist_ok=True)
    source = directory / "dart/src"
    subprocess.run(["cc", "-shared", "-fPIC", "-O2", "-I", str(source), str(source / "parser.c"),
                    str(source / "scanner.c"), "-o", str(output / "dart.so")], check=True)


if __name__ == "__main__":
    main()
