#!/usr/bin/env bash
# Отдельное явное действие администратора; приложение этот сценарий не вызывает.
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=C
umask 077
test "$(id -u)" = 0
test "$#" = 1

source_dir=$(cd -- "$(dirname -- "$0")" && pwd)
source "$source_dir/recovery-journal.sh"

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


rollback() {
  echo 'Restoring previous WASM service' >&2
  if test -e "$state/pending/format"; then verify_snapshot || return 1; fi
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


capture_state() {
  local enabled active unit marker
  enabled=$(systemctl is-enabled space-client-wasm.socket 2>/dev/null || true)
  case "$enabled" in
    enabled) touch "$state/staging/enabled" ;;
    disabled|not-found) ;;
    *) echo "Unsupported socket enable state: $enabled" >&2; return 1 ;;
  esac
  for unit in socket service; do
    active=$(systemctl show "space-client-wasm.$unit" -p ActiveState --value)
    marker="$state/staging/$unit-active"
    case "$active" in
      active) touch "$marker" ;;
      inactive|failed) ;;
      *) echo "Service is transitioning: $active" >&2; return 1 ;;
    esac
  done
}

ensure_recovery() {
  local recovery=/usr/libexec/space-client-wasm-recovery-v1 name unit
  local files=(recover-at-boot.sh recovery-journal.sh space-client-wasm-recovery.service recovery-socket.conf recovery-service.conf)
  test ! -L "$recovery"
  if test ! -d "$recovery"; then
    test ! -L "$recovery.next"
    rm -rf -- "$recovery.next"
    install -d -o root -g root -m 0755 "$recovery.next"
    for name in "${files[@]}"; do
      install -o root -g root -m 0644 "$source_dir/$name" "$recovery.next/$name"
    done
    sync -f "$recovery.next"
    mv -- "$recovery.next" "$recovery"
    sync -f "$recovery"
  fi
  # Код восстановления v1 не заменяется вместе с кандидатом. Новый формат
  # потребует отдельной версии и явного перехода, а не перезаписи живого recovery.
  private_directory "$recovery" 0755
  for name in "${files[@]}"; do
    test ! -L "$recovery/$name"
    test "$(stat -c %u:%a "$recovery/$name")" = 0:644
    cmp "$source_dir/$name" "$recovery/$name"
  done
  test ! -L "$units/space-client-wasm-recovery.service"
  test ! -L "$units/space-client-wasm-recovery.service.next"
  install -o root -g root -m 0644 "$recovery/space-client-wasm-recovery.service" "$units/space-client-wasm-recovery.service.next"
  mv -f -- "$units/space-client-wasm-recovery.service.next" "$units/space-client-wasm-recovery.service"
  for unit in socket service; do
    private_directory "$units/space-client-wasm.$unit.d" 0755
    test ! -L "$units/space-client-wasm.$unit.d/10-space-recovery.conf"
    test ! -L "$units/space-client-wasm.$unit.d/10-space-recovery.conf.next"
    install -o root -g root -m 0644 "$recovery/recovery-$unit.conf" "$units/space-client-wasm.$unit.d/10-space-recovery.conf.next"
    mv -f -- "$units/space-client-wasm.$unit.d/10-space-recovery.conf.next" "$units/space-client-wasm.$unit.d/10-space-recovery.conf"
  done
  sync -f "$units"
  systemctl daemon-reload
  systemctl enable space-client-wasm-recovery.service
  systemctl reset-failed space-client-wasm-recovery.service >/dev/null 2>&1 || true
  systemctl start space-client-wasm-recovery.service
}

prepare_candidate() {
  local binary expected actual index
  binary=$(realpath -- "$1")
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
      test "$(stat -c %u "${targets[$index]}")" = 0
      test "$(( 8#$(stat -c %a "${targets[$index]}") & 8#22 ))" = 0
      cp -p -- "${targets[$index]}" "$state/staging/old/${names[$index]}"
      sha256sum "$state/staging/old/${names[$index]}" | cut -d ' ' -f 1 > "$state/staging/old/${names[$index]}.sha256"
    else
      touch "$state/staging/old/${names[$index]}.missing"
    fi
  done
  capture_state
  echo 1 > "$state/staging/format"
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
  rm -f -- /run/space-client-wasm-recovery-blocked
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
ensure_recovery
prepare_candidate "$1"
activate_candidate
