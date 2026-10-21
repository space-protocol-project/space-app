"""Одноразовые этапы Android-проверки через adb reverse, только loopback."""
import argparse
import ipaddress
import re
import socket
import socketserver
import threading
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("work", type=Path)
parser.add_argument("--turn-host")
parser.add_argument("--turn-port", type=int)
args = parser.parse_args()
root = args.work.resolve()
if not re.fullmatch(r"voice-check-[a-f0-9]{32}", root.name):
    raise ValueError("Нужен одноразовый каталог проверки")


class Stages(BaseHTTPRequestHandler):
    def log_message(self, *_):
        pass

    def handle_stage(self, write=False):
        name = self.path.removeprefix("/")
        allowed = r"(?:[AB](?:-[A-Za-z0-9_.-]+|\.json)|room|config|background-started|background-checked|foreground-restored)"
        if not re.fullmatch(allowed, name):
            self.send_error(400)
            return
        target = root / name
        if write:
            size = int(self.headers.get("Content-Length", "0"))
            if not (name.startswith("B-") or name == "B.json") or size < 0 or size > 65536:
                self.send_error(400)
                return
            temporary = target.with_suffix(".android.tmp")
            temporary.write_bytes(self.rfile.read(size))
            temporary.replace(target)
        if not target.is_file():
            self.send_error(404)
            return
        data = target.read_bytes()
        self.send_response(200)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        self.handle_stage()

    def do_PUT(self):
        self.handle_stage(write=True)


class Tunnel(socketserver.BaseRequestHandler):
    def handle(self):
        with socket.create_connection((args.turn_host, args.turn_port)) as remote:
            def copy(source, destination):
                try:
                    while block := source.recv(65536):
                        destination.sendall(block)
                except OSError:
                    pass
                finally:
                    try:
                        destination.shutdown(socket.SHUT_WR)
                    except OSError:
                        pass
            threading.Thread(target=copy, args=(self.request, remote), daemon=True).start()
            copy(remote, self.request)


if args.turn_host:
    if not ipaddress.ip_address(args.turn_host).is_private:
        raise ValueError("TURN должен принадлежать локальному стенду")
    tunnel = socketserver.ThreadingTCPServer(("127.0.0.1", args.turn_port), Tunnel)
    tunnel.daemon_threads = True
    threading.Thread(target=tunnel.serve_forever, daemon=True).start()
ThreadingHTTPServer(("127.0.0.1", 8766), Stages).serve_forever()
