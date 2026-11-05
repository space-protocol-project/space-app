#!/usr/bin/env bash
# Отдельное явное действие администратора; приложение этот сценарий не вызывает.
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=C
umask 077
test "$(id -u)" = 0
test "$#" = 1

destination=/usr/libexec/space-client-wasm
state=/var/lib/space-client-wasm-updater
units=/etc/systemd/system
names=(space-client-wasm space-client-wasm.service space-client-wasm.socket)
targets=("$destination/space-client-wasm" "$units/space-client-wasm.service" "$units/space-client-wasm.socket")

private_directory() {
  test ! -L "$1"
  if test -e "$1"; then
    test -d "$1"
    test "$(stat -c %u "$1")" = 0
    test "$(( 8#$(stat -c %a "$1") & 8#22 ))" = 0
  fi
  install -d -o root -g root -m "$2" "$1"
}

stop_broker() {
  local unit loaded
  for unit in space-client-wasm.socket space-client-wasm.service; do
    loaded=$(systemctl show "$unit" -p LoadState --value) || return 1
    if test "$loaded" != not-found; then
      systemctl stop "$unit" || return 1
    fi
  done
}

restore_files() {
  local index target name
  for index in 0 1 2; do
    target=${targets[$index]}
    name=${names[$index]}
    if test -f "$state/pending/old/$name"; then
      cp -p -- "$state/pending/old/$name" "$target.next" || return 1
      mv -f -- "$target.next" "$target" || return 1
    else
      rm -f -- "$target" || return 1
    fi
  done
}

rollback() {
  echo 'Restoring previous WASM service' >&2
  stop_broker || return 1
  systemctl disable space-client-wasm.socket >/dev/null 2>&1 || true
  restore_files || return 1
  systemctl daemon-reload || return 1
  if test -f "$state/pending/enabled"; then
    systemctl enable space-client-wasm.socket || return 1
  fi
  systemctl reset-failed space-client-wasm.service >/dev/null 2>&1 || true
  if test -f "$state/pending/socket-active"; then
    systemctl start space-client-wasm.socket || return 1
  fi
  if test -f "$state/pending/service-active"; then
    systemctl start space-client-wasm.service || return 1
  fi
  sync -f "$destination" || return 1
  sync -f "$units" || return 1
  rm -rf -- "$state/pending" || return 1
  sync -f "$state"
}

finish() {
  local result=$?
  trap - EXIT INT TERM
  if test -d "$state/pending"; then
    if ! rollback; then
      echo "Rollback failed; preserved journal: $state/pending" >&2
      exit 2
    fi
  fi
  exit "$result"
}

finalize_commit() {
  if test -d "$state/committed"; then
    rm -rf -- "$state/previous"
    mv -- "$state/committed" "$state/previous"
    sync -f "$state"
  fi
}

prepare_candidate() {
  local binary source_dir expected actual index
  binary=$(realpath -- "$1")
  source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
  # Проверяем приватную копию, чтобы замена исходника не меняла устанавливаемые байты.
  rm -rf -- "$state/staging"
  mkdir -m 0700 "$state/staging" "$state/staging/new" "$state/staging/old"
  install -o root -g root -m 0755 "$binary" "$state/staging/new/space-client-wasm"
  expected=$(tr -d '\r\n ' < "$binary.sha256")
  actual=$(sha256sum -- "$state/staging/new/space-client-wasm" | cut -d ' ' -f 1)
  test "$actual" = "$expected"
  for index in 1 2; do
    install -o root -g root -m 0644 "$source_dir/${names[$index]}" "$state/staging/new/${names[$index]}"
  done
  for index in 0 1 2; do
    test ! -L "${targets[$index]}"
    test ! -L "${targets[$index]}.next"
    if test -e "${targets[$index]}"; then
      test -f "${targets[$index]}"
      cp -p -- "${targets[$index]}" "$state/staging/old/${names[$index]}"
    fi
  done
  if systemctl is-enabled --quiet space-client-wasm.socket; then touch "$state/staging/enabled"; fi
  if systemctl is-active --quiet space-client-wasm.socket; then touch "$state/staging/socket-active"; fi
  if systemctl is-active --quiet space-client-wasm.service; then touch "$state/staging/service-active"; fi
  sync -f "$state"
  mv -- "$state/staging" "$state/pending"
  sync -f "$state"
}

activate_candidate() {
  local index
  # На первой установке отсутствующие units не требуют остановки.
  if test -f "$state/pending/socket-active" || test -f "$state/pending/service-active"; then
    stop_broker
  fi
  for index in 0 1 2; do
    cp -p -- "$state/pending/new/${names[$index]}" "${targets[$index]}.next"
    mv -f -- "${targets[$index]}.next" "${targets[$index]}"
  done
  sync -f "$destination"
  sync -f "$units"
  systemctl daemon-reload
  systemctl reset-failed space-client-wasm.service >/dev/null 2>&1 || true
  systemctl enable --now space-client-wasm.socket
  # Реальная компиляция и вызов WASM через обычный UID; Flutter не повышает права.
  timeout --kill-after=2 10 setpriv --reuid=65534 --regid=65534 --clear-groups \
    "$destination/space-client-wasm" --check-linux-broker
  mv -- "$state/pending" "$state/committed"
  sync -f "$state"
  finalize_commit
  echo 'WASM service update committed'
}

version=$(systemctl --version | head -n 1 | awk '{print $2}')
test "$version" -ge 254
test "$(stat -fc %T /sys/fs/cgroup)" = cgroup2fs
private_directory "$destination" 0755
private_directory "$state" 0700
exec 9>"$state/lock"
flock -n 9
trap finish EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
# SIGKILL не выполняет trap: откат до новой попытки по сохранённому журналу.
if test -d "$state/pending"; then rollback; fi
finalize_commit
prepare_candidate "$1"
activate_candidate
