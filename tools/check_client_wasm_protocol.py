"""CI: несовместимая root-служба не получает WASM; обновление выполняет администратор."""
import json
import contextlib
import os
from pathlib import Path
import socket
import subprocess
import sys
import tempfile

from check_client_wasm_linux import HELLO, SOCKET, call, request


def fake_broker(kind):
    assert os.geteuid() == 0
    Path(SOCKET).parent.mkdir(mode=0o755, exist_ok=True)
    greetings = {"legacy": b'{"ready":true}\n',
                 "future": HELLO.replace(b':1}', b':2}'),
                 "oversized": b'x' * 513 + b'\n',
                 "truncated": HELLO[:-1]}
    with socket.socket(socket.AF_UNIX) as listener:
        listener.settimeout(5)
        listener.bind(SOCKET)
        os.chmod(SOCKET, 0o666)
        listener.listen(1)
        print("ready", flush=True)
        connection, _ = listener.accept()
        with connection:
            connection.settimeout(5)
            connection.sendall(greetings[kind])
            with contextlib.suppress(OSError):
                connection.shutdown(socket.SHUT_WR)
            try:
                received = connection.recv(128 << 10)
            except ConnectionResetError:
                received = b""
            print(json.dumps({"received_bytes": len(received)}), flush=True)
    os.unlink(SOCKET)


def control(*arguments):
    subprocess.run(["sudo", "systemctl", *arguments], check=True)


def install(binary):
    return subprocess.run(["sudo", "bash", "packaging/linux-wasm/install-system-service.sh",
                           str(binary)], capture_output=True, text=True, timeout=20)


def main_pid():
    return int(subprocess.check_output(["systemctl", "show", "space-client-wasm.service",
                                        "-p", "MainPID", "--value"], text=True))


def reject_server(kind, binary, payload):
    with subprocess.Popen(["sudo", "/usr/bin/python3", __file__, "--fake", kind],
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as fake:
        assert fake.stdout.readline().strip() == "ready"
        result = subprocess.run([str(binary), "--serve"], input=payload,
                                capture_output=True, timeout=8)
        output, errors = fake.communicate(timeout=8)
        assert fake.returncode == 0, errors
        assert result.returncode != 0 and result.stdout == b""
        observed = json.loads(output)
        assert observed["received_bytes"] == 0
        return {"kind": kind, **observed, "rejected": True}


def reject_client(payload):
    with socket.socket(socket.AF_UNIX) as client:
        client.settimeout(5)
        client.connect(SOCKET)
        assert client.recv(512) == HELLO
        client.sendall(payload)
        try:
            response = client.recv(32768)
        except ConnectionResetError:
            response = b""
        assert response == b""


def exercise():
    assert os.geteuid() != 0
    binary = Path(os.environ["SPACE_CLIENT_WASM_BINARY"])
    payload = request("catalog")
    assert json.loads(call(payload))["result"]
    reject_client(payload)
    reject_client(HELLO.replace(b':1}', b':2}'))
    rejected = []
    control("stop", "space-client-wasm.socket", "space-client-wasm.service")
    try:
        for kind in ("legacy", "future", "oversized", "truncated"):
            rejected.append(reject_server(kind, binary, payload))
    finally:
        restored = install(binary)
        assert restored.returncode == 0, restored.stderr
    assert json.loads(call(payload))["result"]
    previous = main_pid()
    # Неверная поставка должна быть отклонена до остановки рабочей службы.
    with tempfile.TemporaryDirectory() as directory:
        invalid = Path(directory) / "invalid"
        invalid.write_bytes(b"not an executable")
        Path(str(invalid) + ".sha256").write_text("0" * 64)
        assert install(invalid).returncode != 0
    assert main_pid() == previous
    assert json.loads(call(payload))["result"]
    # Совместимая повторная установка обрывает старое соединение до нового процесса.
    with socket.socket(socket.AF_UNIX) as held:
        held.settimeout(5)
        held.connect(SOCKET)
        assert held.recv(512) == HELLO
        updated = install(binary)
        assert updated.returncode == 0, updated.stderr
        assert held.recv(128) == b""
    assert json.loads(call(payload))["result"]
    assert main_pid() != previous
    info = Path("/usr/libexec/space-client-wasm/space-client-wasm").stat()
    assert info.st_uid == 0 and info.st_mode & 0o7777 == 0o755
    return {"client_uid": os.geteuid(), "protocol_version": 1,
            "incompatible_servers": rejected, "legacy_client_rejected": True,
            "future_client_rejected": True, "bad_update_preserved_service": True,
            "reinstall_reconnected": True, "old_connection_closed": True, "passed": True}


if __name__ == "__main__":
    if sys.argv[1:2] == ["--fake"]:
        fake_broker(sys.argv[2])
    else:
        result = exercise()
        Path("client-wasm-linux-protocol.json").write_text(json.dumps(result, indent=2) + "\n")
        print(json.dumps(result))
