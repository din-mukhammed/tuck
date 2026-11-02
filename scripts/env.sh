ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/.build"

SWIFTC_FLAGS=(-target arm64-apple-macos13.0 -swift-version 5)

CLT_SWIFT_INCLUDE=/Library/Developer/CommandLineTools/usr/include/swift
if [[ -f "$CLT_SWIFT_INCLUDE/module.modulemap" && -f "$CLT_SWIFT_INCLUDE/bridging.modulemap" ]]; then
  : > "$ROOT/.build/empty.modulemap"
  cat > "$ROOT/.build/overlay.yaml" <<EOF
{ "version": 0, "roots": [ { "name": "$CLT_SWIFT_INCLUDE/module.modulemap", "type": "file", "external-contents": "$ROOT/.build/empty.modulemap" } ] }
EOF
  SWIFTC_FLAGS+=(-vfsoverlay "$ROOT/.build/overlay.yaml" -Xcc -ivfsoverlay -Xcc "$ROOT/.build/overlay.yaml")
fi
