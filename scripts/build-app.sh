#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$ROOT"

swiftc "${SWIFTC_FLAGS[@]}" -O Sources/TuckCore/*.swift Sources/Tuck/*.swift -o .build/Tuck

APP=dist/Tuck.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp .build/Tuck "$APP/Contents/MacOS/Tuck"
cp Resources/Info.plist "$APP/Contents/Info.plist"
codesign --force --sign - "$APP"

pkill -x Tuck || true
mkdir -p "$HOME/Applications"
rm -rf "$HOME/Applications/Tuck.app"
cp -R "$APP" "$HOME/Applications/Tuck.app"
echo "Installed $HOME/Applications/Tuck.app"

if [[ "${1:-}" == "--run" ]]; then
  open "$HOME/Applications/Tuck.app"
fi
