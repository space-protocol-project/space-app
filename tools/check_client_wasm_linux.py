"""CI: системная служба и клиент с обычным UID; без пользовательских данных."""
import base64
import concurrent.futures
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import time

SOCKET = "/run/space-client-wasm/control.sock"
HELLO = b'{"protocol":"space.client.wasm.linux.p1","version":1}\n'


def connect():
    client = socket.socket(socket.AF_UNIX)
    client.settimeout(5)
    client.connect(SOCKET)
    assert client.recv(512) == HELLO
    client.sendall(HELLO)
    assert client.recv(128) == b'{"ready":true}\n'
    return client


def request(name):
    module = (Path(os.environ["WASM_FIXTURES"]) / (name + ".wasm")).read_bytes()
    return json.dumps({"wasm": base64.b64encode(module).decode(),
                       "input": base64.b64encode(b'{"event":"start"}').decode()}).encode() + b"\n"


def call(payload):
    with connect() as client:
        client.sendall(payload)
        chunks = []
        while chunk := client.recv(32768):
            chunks.append(chunk)
        return b"".join(chunks)


def inspect():
    assert os.geteuid() == 0
    group = subprocess.check_output(["systemctl", "show", "space-client-wasm.service",
                                     "-p", "ControlGroup", "--value"], text=True).strip()
    root = Path("/sys/fs/cgroup") / group.lstrip("/")
    assert (root / "memory.max").read_text().strip() == str(640 << 20)
    deadline = time.monotonic() + 3
    while time.monotonic() < deadline:
        for worker in root.glob("space-p1-*/call-*"):
            try:
                values = {name: (worker / name).read_text().strip() for name in
                          ("memory.max", "memory.swap.max", "pids.max", "cpu.max")}
                assert values == {"memory.max": str(256 << 20), "memory.swap.max": "0",
                                  "pids.max": "64", "cpu.max": "100000 100000"}
                assert (worker.parent / "memory.max").read_text().strip() == str(512 << 20)
                for pid in (worker / "cgroup.procs").read_text().split():
                    status = (Path("/proc") / pid / "status").read_text()
                    fields = dict(line.split(":", 1) for line in status.splitlines() if ":" in line)
                    assert fields["Uid"].split() == ["65534"] * 4
                    assert fields["Gid"].split() == ["65534"] * 4
                    assert fields["Groups"].strip() == ""
                    assert fields["CapEff"].strip() == "0000000000000000"
                    assert fields["CapPrm"].strip() == "0000000000000000"
                    assert fields["CapAmb"].strip() == "0000000000000000"
                    assert fields["NoNewPrivs"].strip() == "1"
                    assert os.readlink(f"/proc/{pid}/ns/net") != os.readlink("/proc/self/ns/net")
                    assert not os.path.exists(f"/proc/{pid}/root/home/runner")
                    return {"worker_uid": 65534, "capabilities": 0, "no_new_privileges": True,
                            "private_network": True, "hidden_home": True, "limits": values,
                            "shared_memory": 512 << 20, "service_memory": 640 << 20}
            except (FileNotFoundError, ProcessLookupError):
                pass
        time.sleep(.005)
    raise AssertionError("worker not observed")


def exercise():
    assert os.geteuid() != 0
    payload = request("catalog")
    result = json.loads(call(payload))
    assert json.loads(base64.b64decode(result["result"]))["op"] == "list"
    assert call(b'{"command":"/bin/sh","path":"/etc/shadow"}\n') == b""
    # Четыре медленных соединения — жёсткий общий предел; пятое не получает ready.
    held = [connect() for _ in range(4)]
    with socket.socket(socket.AF_UNIX) as extra:
        extra.settimeout(1)
        extra.connect(SOCKET)
        assert extra.recv(128) == b""
    for client in held:
        client.close()
    time.sleep(.1)
    looping = request("loop")
    until = time.monotonic() + 4

    def load():
        while time.monotonic() < until:
            try:
                call(looping)
            except (OSError, AssertionError):
                pass

    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
        tasks = [pool.submit(load) for _ in range(2)]
        snapshot = json.loads(subprocess.check_output(
            ["sudo", sys.executable, __file__, "--inspect"], text=True))
        for task in tasks:
            task.result()
    # EOF является отменой; следующий запрос не ждёт старого вызова.
    for _ in range(8):
        with connect() as client:
            client.sendall(looping)
            client.shutdown(socket.SHUT_WR)
            assert client.recv(32768) == b""
    assert json.loads(call(payload))["result"]
    subprocess.run(["sudo", "systemctl", "kill", "--signal=KILL",
                    "--kill-whom=all", "space-client-wasm.service"], check=True)
    time.sleep(2)
    assert json.loads(call(payload))["result"]
    return {"client_uid": os.geteuid(), "isolation": snapshot, "connections_limit": 4,
            "unknown_command_rejected": True, "eof_cancellation": True,
            "restart_after_kill": True, "passed": True}


if __name__ == "__main__":
    if sys.argv[1:] == ["--inspect"]:
        print(json.dumps(inspect()))
    else:
        result = exercise()
        Path("client-wasm-linux.json").write_text(json.dumps(result, indent=2) + "\n")
        print(json.dumps(result))
