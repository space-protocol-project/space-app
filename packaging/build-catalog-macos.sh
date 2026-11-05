#!/usr/bin/env bash
set -euo pipefail
source_dir="${PROJECT_DIR}/../../native/space_catalog"
output="${TARGET_BUILD_DIR}/${EXECUTABLE_FOLDER_PATH}/space-catalog"
checksum="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/space-catalog.sha256"
mkdir -p "$(dirname "$output")" "$(dirname "$checksum")"
# Старый результат этой фазы не должен мешать подписи при повторной сборке.
rm -f "$output.sha256"
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
parts=()
for arch in ${ARCHS}; do
  case "$arch" in
    arm64) goarch=arm64 ;;
    x86_64) goarch=amd64 ;;
    *) echo "Unsupported catalog architecture: $arch" >&2; exit 1 ;;
  esac
  (cd "$source_dir" && CGO_ENABLED=0 GOOS=darwin GOARCH="$goarch" go build -trimpath -o "$temporary/$arch" .)
  parts+=("$temporary/$arch")
done
lipo -create "${parts[@]}" -output "$output"
codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY:--}" "$output"
shasum -a 256 "$output" | cut -d ' ' -f 1 > "$checksum"
