"""Восстановить закрытый ключ из секретов CI, не выводя его в журнал."""
import base64
import os
from pathlib import Path


def prepare(environment, directory):
    names = ["SPACE_ANDROID_KEYSTORE", "SPACE_ANDROID_STORE_PASSWORD",
             "SPACE_ANDROID_KEY_PASSWORD", "SPACE_ANDROID_KEY_ALIAS"]
    if any(not environment.get(name) for name in names):
        raise ValueError("Не настроены секреты подписи Android")
    if any("\n" in environment[name] or "\r" in environment[name] for name in names[1:]):
        raise ValueError("Некорректный секрет подписи Android")
    key = directory / "space-release.jks"
    key.write_bytes(base64.b64decode(environment[names[0]], validate=True))
    key.chmod(0o600)
    props = directory / "key.properties"
    props.write_text(
        f"storeFile={key.resolve().as_posix()}\n"
        f"storePassword={environment[names[1]]}\n"
        f"keyPassword={environment[names[2]]}\n"
        f"keyAlias={environment[names[3]]}\n", encoding="utf-8")
    props.chmod(0o600)


if __name__ == "__main__":
    prepare(os.environ, Path("client/android"))
