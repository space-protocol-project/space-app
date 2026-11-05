#!/usr/bin/env bash
# Общий фиксированный формат журнала; вызывается только доверенными root-сценариями.
destination=/usr/libexec/space-client-wasm
state=/var/lib/space-client-wasm-updater
units=/etc/systemd/system
names=(space-client-wasm space-client-wasm.service space-client-wasm.socket)
targets=("$destination/space-client-wasm" "$units/space-client-wasm.service" "$units/space-client-wasm.socket")

verify_snapshot() {
  local name expected actual index
  test "$(cat "$state/pending/format")" = 1 || return 1
  for index in 0 1 2; do
    name=${names[$index]}
    test ! -L "${targets[$index]}" || return 1
    test ! -L "${targets[$index]}.next" || return 1
    if test -f "$state/pending/old/$name.missing"; then
      test ! -e "$state/pending/old/$name" || return 1
    else
      test -f "$state/pending/old/$name" || return 1
      test ! -L "$state/pending/old/$name" || return 1
      expected=$(cat "$state/pending/old/$name.sha256") || return 1
      actual=$(sha256sum "$state/pending/old/$name" | cut -d ' ' -f 1) || return 1
      test "$expected" = "$actual" || return 1
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

finalize_commit() {
  if test -d "$state/committed"; then
    rm -rf -- "$state/previous"
    mv -- "$state/committed" "$state/previous"
    sync -f "$state"
  fi
}
