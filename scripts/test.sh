#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$ROOT"
swiftc "${SWIFTC_FLAGS[@]}" -target "$(uname -m)-apple-$DEPLOYMENT_TARGET" Sources/TuckCore/*.swift Tests/*.swift -o .build/tuck-tests
.build/tuck-tests
