"""Проверить типы адаптированных плагинов, включая неактивные на хосте платформы."""

import json
import shutil
import subprocess
import tempfile
from pathlib import Path
from urllib.parse import urljoin

ROOT = Path(__file__).resolve().parents[1]
CLIENT = ROOT / "client"
EXISTING_VENDORS = {"camera_windows", "flutter_webrtc", "flutter_secure_storage_windows"}


def prepare(destination):
    config = CLIENT / ".dart_tool/package_config.json"
    packages = json.loads(config.read_text(encoding="utf-8"))
    adapted = {p.name for p in (CLIENT / "vendor").iterdir()
               if p.is_dir() and p.name not in EXISTING_VENDORS}
    for package in packages["packages"]:
        uri = urljoin(config.as_uri(), package["rootUri"])
        if package["name"] in adapted:
            source = CLIENT / "vendor" / package["name"]
            target = destination / package["name"]
            shutil.copytree(source / "lib", target / "lib")
            shutil.copy2(source / "pubspec.yaml", target / "pubspec.yaml")
            uri = target.as_uri() + "/"
        package["rootUri"] = uri
    (destination / ".dart_tool").mkdir()
    (destination / ".dart_tool/package_config.json").write_text(
        json.dumps(packages), encoding="utf-8",
    )
    (destination / "pubspec.yaml").write_text(
        "name: space_file_adapters_validation\nenvironment:\n  sdk: ^3.13.7\n",
        encoding="utf-8",
    )
    print(f"Проверка API {len(adapted)} адаптированных пакетов", flush=True)


def main():
    with tempfile.TemporaryDirectory(prefix="space-file-adapters-") as directory:
        destination = Path(directory).resolve()
        prepare(destination)
        # Стиль стороннего кода не меняем; ошибки типов и предупреждения фатальны.
        dart = shutil.which("dart")
        if dart is None:
            raise RuntimeError("Dart SDK не найден в PATH")
        subprocess.run([dart, "analyze", str(destination)], check=True)


if __name__ == "__main__":
    main()
