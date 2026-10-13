"""Записать версию тега в pubspec для сборки и страницы настроек."""
from pathlib import Path
import re
import runpy
import sys


def stamp(source, tag):
    helper = runpy.run_path(str(Path(__file__).with_name("release-notes.py")))
    version = helper["tag_info"](tag)["version"]
    match = re.search(r"^version: ([^\s]+)$", source, re.MULTILINE)
    if match is None:
        raise ValueError("В pubspec.yaml нет версии")
    build = match.group(1).partition("+")[2]
    suffix = "+" + build if build else ""
    return source[:match.start()] + f"version: {version}{suffix}" + source[match.end():]


if __name__ == "__main__":
    path = Path("client/pubspec.yaml")
    path.write_text(stamp(path.read_text(encoding="utf-8"), sys.argv[1]), encoding="utf-8")
