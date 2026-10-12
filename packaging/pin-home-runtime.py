"""Закрепить опубликованный серверный выпуск и проверить метаданные GitHub assets."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import urllib.request

tag = sys.argv[1]
if not re.fullmatch(r"v\d+\.\d+\.\d+", tag):
    raise ValueError("Нужен тег vX.Y.Z")
repository = "space-protocol-project/space-server"
release = json.loads(subprocess.check_output(["gh", "api", f"repos/{repository}/releases/tags/{tag}"], text=True, encoding="utf-8"))
if release["draft"] or release["tag_name"] != tag:
    raise ValueError("Выпуск ещё не опубликован")
assets = {asset["name"]: asset for asset in release["assets"]}
manifest = {}
for platform in ("windows-x64", "linux-x64", "macos-arm64"):
    metadata = assets[platform + ".json"]
    with urllib.request.urlopen(metadata["browser_download_url"], timeout=30) as response:
        content = response.read(16385)
    if len(content) > 16384 or "sha256:" + hashlib.sha256(content).hexdigest() != metadata["digest"]:
        raise ValueError("Контрольная сумма JSON не совпадает")
    descriptor = json.loads(content)
    archive = assets[f"Space-home-{platform}.zip"]
    expected_url = f"https://github.com/{repository}/releases/download/{tag}/Space-home-{platform}.zip"
    if (descriptor["version"] != tag or descriptor["platform"] != platform or descriptor["url"] != expected_url or
            descriptor["bytes"] != archive["size"] or "sha256:" + descriptor["sha256"] != archive["digest"]):
        raise ValueError("Дескриптор не соответствует опубликованному архиву")
    if ("unpackedBytes" in descriptor and (type(descriptor["unpackedBytes"]) is not int or not 0 < descriptor["unpackedBytes"] <= 2*1024**3)):
        raise ValueError("Недопустимый размер распаковки")
    if ("releaseNotes" in descriptor and (not isinstance(descriptor["releaseNotes"], str) or len(descriptor["releaseNotes"].encode("utf-8")) > 8192)):
        raise ValueError("Недопустимое описание изменений")
    manifest[platform] = descriptor
target = Path(__file__).resolve().parents[1] / "client/assets/home/runtime-manifest.json"
target.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print("Закреплён " + tag + ": " + ", ".join(manifest))
