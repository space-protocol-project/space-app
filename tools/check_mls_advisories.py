"""Проверка активного графа Rust-зависимостей по OSV; ошибка сети прерывает проверку."""

import json
import pathlib
import re
import subprocess
import urllib.request

from collect_mls_notices import TARGETS

ROOT = pathlib.Path(__file__).resolve().parents[1]


def dependencies():
    packages = set()
    for target in TARGETS:
        output = subprocess.check_output(
            ["cargo", "tree", "--locked", "--target", target, "--prefix", "none",
             "--format", "{p}", "-e", "normal,build,dev"],
            cwd=ROOT / "native" / "space_mls_bridge", text=True,
        )
        for line in output.splitlines():
            match = re.fullmatch(r"([\w-]+) v([\w.+-]+)(?: \(proc-macro\))?(?: \(\*\))?", line)
            if match:
                packages.add(match.groups())
            elif not line.startswith(("space_mls v", "space_mls_bridge v")):
                raise RuntimeError("Неизвестный формат Rust-зависимости: " + line)
    if not packages:
        raise RuntimeError("Не удалось определить Rust-зависимости")
    return sorted(packages)


def main():
    packages = dependencies()
    queries = [{"package": {"ecosystem": "crates.io", "name": name}, "version": version}
               for name, version in packages]
    request = urllib.request.Request(
        "https://api.osv.dev/v1/querybatch", data=json.dumps({"queries": queries}).encode(),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(request, timeout=45) as response:
        results = json.load(response)["results"]
    if len(results) != len(packages):
        raise RuntimeError("Неполный ответ базы уязвимостей")
    if any(not isinstance(result, dict) or set(result) - {"vulns"} for result in results):
        raise RuntimeError("Неожиданный ответ базы уязвимостей")
    findings = [{"package": name, "version": version, "vulns": result["vulns"]}
                for (name, version), result in zip(packages, results) if result.get("vulns")]
    print(json.dumps({"packages": len(packages), "findings": findings}, indent=2))
    if findings:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
