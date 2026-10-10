#!/usr/bin/env bash
set -euo pipefail
mkdir -p dist
bundle=client/build/linux/x64/release/bundle
test -x "$bundle/space_client"
archive=$(mktemp)
trap 'rm -f "$archive"' EXIT
tar -C "$bundle" -czf "$archive" .
cat packaging/linux-header.sh "$archive" > dist/Space-linux-x64.run
chmod +x dist/Space-linux-x64.run
probe=$(mktemp -d)
trap 'rm -f "$archive"; rm -rf "$probe"' EXIT
./dist/Space-linux-x64.run --extract "$probe"
test -x "$probe/space_client"
test -f "$probe/data/flutter_assets/FontManifest.json"
