"""Собрать уведомления из закреплённых crates и исходников их лицензий."""

import json
import re
import subprocess
import urllib.request
from html import unescape
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGETS = ("x86_64-pc-windows-msvc", "x86_64-unknown-linux-gnu", "aarch64-apple-darwin", "x86_64-apple-darwin", "aarch64-linux-android", "armv7-linux-androideabi", "x86_64-linux-android")


def packages():
    selected = {}
    for target in TARGETS:
        result = subprocess.run(["cargo", "+1.99.1", "metadata", "--locked", "--format-version", "1", "--filter-platform", target, "--manifest-path", str(ROOT / "native/space_mls_bridge/Cargo.toml")], capture_output=True, text=True, check=True)
        metadata = json.loads(result.stdout)
        active = {node["id"] for node in metadata["resolve"]["nodes"]}
        selected.update({p["id"]: p for p in metadata["packages"]
                         if p["id"] in active and (p["source"] or p["name"] == "openmls_libcrux_crypto")})
    return sorted(selected.values(), key=lambda p: (p["name"], p["version"]))


def local_licenses(directory):
    result = []
    for entry in sorted(directory.iterdir()):
        if entry.name.upper().startswith(("LICENSE", "LICENCE", "COPYING", "NOTICE")):
            files = [entry] if entry.is_file() else sorted(p for p in entry.rglob("*") if p.is_file())
            result.extend((file.name, file.read_text(encoding="utf-8", errors="replace")) for file in files)
    return result


def download(url):
    print(url, flush=True)
    with urllib.request.urlopen(url, timeout=30) as response:
        return response.read().decode("utf-8")


def upstream_licenses(package, directory, cache):
    repository = package["repository"].split("/tree/", 1)[0].removesuffix("/").removesuffix(".git")
    revision = json.loads((directory / ".cargo_vcs_info.json").read_text())["git"]["sha1"]
    key = (repository, revision)
    if key not in cache:
        base = repository.replace("https://github.com/", "https://raw.githubusercontent.com/")
        url = f"{base}/{revision}/LICENSE"
        cache[key] = [(url, download(url))]
    result = list(cache[key])
    if "MPL-2.0" in package["license"]:
        url = "https://www.mozilla.org/media/MPL/2.0/index.txt"
        if url not in cache:
            cache[url] = download(url)
        result.append((url, cache[url]))
    return result


def rust_notices():
    result = subprocess.run(["rustup", "run", "1.99.1", "rustc", "--print", "sysroot"], capture_output=True, text=True, check=True)
    docs = Path(result.stdout.strip()) / "share/doc/rust"
    html = (docs / "COPYRIGHT-library.html").read_text(encoding="utf-8")
    text = unescape(re.sub("<[^>]+>", " ", re.sub(r"<style.*?</style>", "", html, flags=re.S)))
    sections = ["Rust standard library 1.99.1\n" + text]
    names = set(re.findall(r'licenses/([^"#<> ]+\.txt)', html)) | {"MIT.txt", "Apache-2.0.txt"}
    sections.extend((docs / "licenses" / name).read_text(encoding="utf-8") for name in sorted(names))
    return "\n\n".join(sections)


def main():
    sections = ["Уведомления о лицензиях нативного модуля MLS Space.\nВерсии закреплены в native/space_mls_bridge/Cargo.lock.\nИсходники неизменённых внешних crates доступны по приведённым адресам."]
    cache = {}
    selected = packages()
    for package in selected:
        directory = Path(package["manifest_path"]).parent
        licenses = local_licenses(directory) or upstream_licenses(package, directory, cache)
        source = (f"https://crates.io/api/v1/crates/{package['name']}/{package['version']}/download"
                  if package["source"] else "native/vendor/openmls_libcrux_crypto (SPACE-PATCH.md)")
        header = f"{package['name']} {package['version']}\nSPDX: {package['license']}\nАвторы: {', '.join(package['authors'])}\nИсходники: {source}"
        sections.append(header + "\n\n" + "\n\n".join(name + "\n" + text for name, text in licenses))
    sections.append(rust_notices())
    destination = ROOT / "client/assets/legal/mls-NOTICES.txt"
    destination.parent.mkdir(parents=True, exist_ok=True)
    text = "\n".join(line.rstrip() for line in "\n\n".join(sections).splitlines()).rstrip() + "\n"
    destination.write_text(text, encoding="utf-8")
    print(f"Уведомления для {len(selected)} внешних crates: {destination}")


if __name__ == "__main__":
    main()
