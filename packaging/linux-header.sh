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
mkdir -p "$HOME/.local/share/dbus-1/services" "$HOME/.local/share/icons/hicolor/256x256/apps"
ln -sf "$destination/space_client" "$HOME/.local/bin/space"
cat > "$HOME/.local/share/applications/org.spaceprotocol.space_client.desktop" <<ENTRY
[Desktop Entry]
Type=Application
Name=Space
Exec="$destination/space_client"
Icon=$destination/data/flutter_assets/assets/branding/space-app-icon.png
Terminal=false
Categories=Network;Chat;
DBusActivatable=true
X-GNOME-UsesNotifications=true
ENTRY
cat > "$HOME/.local/share/dbus-1/services/org.spaceprotocol.space_client.service" <<ENTRY
[D-BUS Service]
Name=org.spaceprotocol.space_client
Exec="$destination/space_client" --gapplication-service
ENTRY
cp "$destination/data/flutter_assets/assets/branding/space-app-icon.png" "$HOME/.local/share/icons/hicolor/256x256/apps/org.spaceprotocol.space_client.png"
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$HOME/.local/share/applications" || true
fi
legacy="$HOME/.local/share/applications/space.desktop"
if [ -f "$legacy" ] && grep -Fqx "Exec=\"$destination/space_client\"" "$legacy"; then
  rm -- "$legacy"
fi
printf '%s\n' "Space installed: $destination" "Run: $HOME/.local/bin/space"
exit 0
__SPACE_PAYLOAD__
