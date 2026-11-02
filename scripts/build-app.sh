#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$ROOT"

for arch in arm64 x86_64; do
  swiftc "${SWIFTC_FLAGS[@]}" -O -target "$arch-apple-$DEPLOYMENT_TARGET" \
    Sources/TuckCore/*.swift Sources/Tuck/*.swift -o ".build/Tuck-$arch"
done
lipo -create .build/Tuck-arm64 .build/Tuck-x86_64 -output .build/Tuck

APP=dist/Tuck.app
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp .build/Tuck "$APP/Contents/MacOS/Tuck"
cp Resources/Info.plist "$APP/Contents/Info.plist"

if [[ -n "${TUCK_SIGN_IDENTITY:-}" ]]; then
  codesign --force --options runtime --timestamp --sign "$TUCK_SIGN_IDENTITY" "$APP"
else
  codesign --force --sign - "$APP"
fi
echo "Built $APP"

if [[ "${1:-}" == "--install" || "${1:-}" == "--run" ]]; then
  pkill -x Tuck || true
  mkdir -p "$HOME/Applications"
  rm -rf "$HOME/Applications/Tuck.app"
  cp -R "$APP" "$HOME/Applications/Tuck.app"
  echo "Installed $HOME/Applications/Tuck.app"
fi

if [[ "${1:-}" == "--run" ]]; then
  open "$HOME/Applications/Tuck.app"
fi
