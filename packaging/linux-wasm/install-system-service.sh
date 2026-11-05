#!/usr/bin/env bash
# Отдельное явное действие администратора; приложение этот сценарий не вызывает.
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
test "$(id -u)" = 0
test "$#" = 1
binary=$(realpath -- "$1")
source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
version=$(systemctl --version | head -n 1 | awk '{print $2}')
test "$version" -ge 254
test "$(stat -fc %T /sys/fs/cgroup)" = cgroup2fs
expected=$(tr -d '\r\n ' < "$binary.sha256")
actual=$(sha256sum -- "$binary" | cut -d ' ' -f 1)
test "$actual" = "$expected"
destination=/usr/libexec/space-client-wasm
test ! -L "$destination"
install -d -o root -g root -m 0755 "$destination"
systemctl stop space-client-wasm.socket space-client-wasm.service 2>/dev/null || true
install -o root -g root -m 0755 "$binary" "$destination/space-client-wasm.new"
mv -f -- "$destination/space-client-wasm.new" "$destination/space-client-wasm"
install -o root -g root -m 0644 "$source_dir/space-client-wasm.service" /etc/systemd/system/
install -o root -g root -m 0644 "$source_dir/space-client-wasm.socket" /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now space-client-wasm.socket
