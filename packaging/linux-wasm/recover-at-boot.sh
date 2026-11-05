#!/usr/bin/env bash
set -euo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export LC_ALL=C
umask 077
test "$(id -u)" = 0
source /usr/libexec/space-client-wasm-recovery-v1/recovery-journal.sh
test ! -L "$state"
test "$(stat -c %u:%a "$state")" = 0:700
# Первая установка запускает этот unit под блокировкой, но до публикации журнала.
# При отсутствии работы ничего не изменяем и не конкурируем за блокировку.
if test ! -d "$state/pending" && test ! -d "$state/committed"; then exit 0; fi
exec 9>"$state/lock"
flock -n 9

fail_closed() {
  local result=$?
  if test "$result" != 0; then
    touch /run/space-client-wasm-recovery-blocked
    echo "WASM recovery failed; journal preserved: $state/pending" >&2
  fi
  exit "$result"
}

recover_pending() {
  local unit active
  # Защищает также от ручного restart recovery при уже работающей службе.
  for unit in socket service; do
    active=$(systemctl show "space-client-wasm.$unit" -p ActiveState --value)
    case "$active" in inactive|failed) ;; *) return 1 ;; esac
  done
  verify_snapshot
  touch /run/space-client-wasm-recovery-blocked
  restore_files
  systemctl disable space-client-wasm.socket >/dev/null 2>&1 || true
  systemctl daemon-reload
  systemctl reset-failed space-client-wasm.service space-client-wasm.socket >/dev/null 2>&1 || true
  if test -f "$state/pending/enabled"; then
    systemctl enable space-client-wasm.socket
    rm -f -- /run/space-client-wasm-recovery-blocked
  fi
  sync -f "$destination"
  sync -f "$units"
  rm -rf -- "$state/pending"
  sync -f "$state"
  echo 'WASM boot recovery restored previous installation'
}

trap fail_closed EXIT
if test -d "$state/pending"; then recover_pending; fi
finalize_commit
