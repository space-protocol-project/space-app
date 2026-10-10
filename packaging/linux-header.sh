#!/bin/sh
set -eu
if [ "${1:-}" = "--extract" ]; then
  destination=${2:?Укажите каталог}
  mkdir -p "$destination"
else
  destination="$HOME/.local/opt/space"
  mkdir -p "$destination"
fi
payload=$(awk '/^__SPACE_PAYLOAD__$/ { print NR+1; exit }' "$0")
tail -n +"$payload" "$0" | tar -xzf - -C "$destination"
if [ "${1:-}" = "--extract" ]; then exit 0; fi
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
ln -sf "$destination/space_client" "$HOME/.local/bin/space"
cat > "$HOME/.local/share/applications/space.desktop" <<ENTRY
[Desktop Entry]
Type=Application
Name=Space
Exec="$destination/space_client"
Icon=$destination/data/flutter_assets/assets/branding/space-app-icon.png
Terminal=false
Categories=Network;Chat;
ENTRY
printf '%s\n' "Space installed: $destination" "Run: $HOME/.local/bin/space"
exit 0
__SPACE_PAYLOAD__
